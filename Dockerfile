FROM opensuse:tumbleweed
MAINTAINER Fabian Neuscasdhmidt fabian@neuschmidt.de

# Set the locale
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en PATH=$PATH:/root/pmd-bin-5.4.1/bin:/root/dart-sdk/bin:/coala-bears/node_modules/.bin

# Add packaged flawfinder
RUN zypper addrepo http://download.opensuse.org/repositories/home:illuusio/openSUSE_Tumbleweed/home:illuusio.repo && \
  # Add repos for suitesparse and luarocks
  zypper addrepo http://download.opensuse.org/repositories/home:stecue/openSUSE_Tumbleweed/home:stecue.repo && \
  zypper addrepo -f \
    http://download.opensuse.org/repositories/devel:/languages:/lua/openSUSE_Factory/ \
    devel:languages:lua && \
  # Use Leap for nodejs
  zypper addrepo http://download.opensuse.org/repositories/devel:languages:nodejs/openSUSE_Leap_42.2/devel:languages:nodejs.repo && \
  # Add repo for rubygem-bundler
  zypper addrepo http://download.opensuse.org/repositories/home:AtastaChloeD:ChiliProject/openSUSE_Factory/home:AtastaChloeD:ChiliProject.repo && \
  # Package dependencies
  zypper --no-gpg-checks --non-interactive install \
    bzr \
    cppcheck \
    curl \
    expect \
    flawfinder \
    gcc-c++ \
    gcc-fortran \
    git \
    go \
    gsl \
    mercurial \
    hlint \
    indent \
    java-1_8_0-openjdk \
    julia \
    libcholmod-3_0_6 \
    libclang3_8 \
    libcurl-devel \
    libncurses5 \
    libopenssl-devel \
    libpcre2-8-0 \
    libxml2-tools \
    lua \
    lua-devel \
    luarocks \
    m4 \
    nodejs \
    npm \
    patch \
    perl \
    perl-Perl-Critic \
    php \
    php7-pear \
    php7-tokenizer \
    php7-xmlwriter \
    python3 \
    python3-dbm \
    python3-gobject \
    python3-pip \
    python3-setuptools \
    R-base \
    ruby \
    ruby-devel \
    ruby2.2-rubygem-bundler \
    ShellCheck \
    subversion \
    sudo \
    suitesparse-devel \
    tar \
    texlive-chktex \
    unzip && \
  # Clear zypper cache
  zypper clean -a

# Coala setup and python deps
RUN pip3 install --upgrade pip

RUN cd / && \
  git clone https://github.com/coala/coala.git && \
  cd coala && \
  pip3 install -r requirements.txt && \
  pip3 install -r test-requirements.txt && \
  pip3 install -e .

RUN cd / && \
  git clone https://github.com/coala/coala-bears.git && \
  cd coala-bears && \
  pip3 install -r requirements.txt && \
  pip3 install -r test-requirements.txt && \
  pip3 install -e . && \
  # NLTK data
  python3 -m nltk.downloader punkt maxent_treebank_pos_tagger averaged_perceptron_tagger && \
  # Remove Ruby directive from Gemfile as this image has 2.2.5
  sed -i '/^ruby/d' Gemfile && \
  bundle install --system && \
  # NPM dependencies
  npm install

RUN git clone https://github.com/coala/coala-quickstart.git && \
  cd coala-quickstart && \
  pip3 install -r requirements.txt -r test-requirements.txt && \
  pip3 install -e . && \
  cd ..

RUN pear install PHP_CodeSniffer

# Dart Lint setup
RUN curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/sdk/dartsdk-linux-x64-release.zip -o /root/dart-sdk.zip && \
  unzip -n /root/dart-sdk.zip -d ~/ && \
  rm -rf /root/dart-sdk.zip

# GO setup
RUN source /etc/profile.d/go.sh \
  && go get -u github.com/golang/lint/golint \
  && go get -u golang.org/x/tools/cmd/goimports \
  && go get -u sourcegraph.com/sqs/goreturns \
  && go get -u golang.org/x/tools/cmd/gotype \
  && go get -u github.com/kisielk/errcheck

# # Infer setup using opam
# RUN useradd -ms /bin/bash opam && usermod -G wheel opam
# RUN echo "opam ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
# # necessary because there is a sudo bug in the base image
# RUN sed -i '51 s/^/#/' /etc/security/limits.conf
# USER opam
# WORKDIR /home/opam
# ADD https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh opam_installer.sh
# RUN sudo sh opam_installer.sh /usr/local/bin
# RUN yes | /usr/local/bin/opam init --comp 4.02.1
# RUN opam switch 4.02.3 && \
#   eval `opam config env` && \
#   opam update && \
#   opam pin add -y merlin 'https://github.com/the-lambda-church/merlin.git#reason-0.0.1' && \
#   opam pin add -y merlin_extend 'https://github.com/let-def/merlin-extend.git#reason-0.0.1' && \
#   opam pin add -y reason 'https://github.com/facebook/reason.git#0.0.6'
# ADD https://github.com/facebook/infer/releases/download/v0.9.0/infer-linux64-v0.9.0.tar.xz infer-linux64-v0.9.0.tar.xz
# RUN sudo tar xf infer-linux64-v0.9.0.tar.xz
# WORKDIR /home/opam/infer-linux64-v0.9.0
# RUN opam pin add -y --no-action infer . && \
#   opam install --deps-only --yes infer && \
#   ./build-infer.sh java
# USER root
# WORKDIR /
# ENV PATH=$PATH:/home/opam/infer-linux64-v0.9.0/infer/bin

# Julia setup
RUN julia -e 'Pkg.add("Lint")'

# Lua commands
RUN luarocks install luacheck

# PMD setup
RUN curl -fsSL https://github.com/pmd/pmd/releases/download/pmd_releases/5.4.1/pmd-bin-5.4.1.zip -o /root/pmd.zip && \
  unzip /root/pmd.zip -d /root/ && \
  rm -rf /root/pmd.zip

# R setup
RUN mkdir -p ~/.RLibrary && \
  echo '.libPaths( c( "~/.RLibrary", .libPaths()) )' >> ~/.Rprofile && \
  echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' >> ~/.Rprofile && \
  R -e "install.packages('lintr', dependencies=TRUE,  verbose=FALSE)" && \
  R -e "install.packages('formatR', dependencies=TRUE, verbose=FALSE)"

# Tailor (Swift) setup
RUN curl -fsSL https://tailor.sh/install.sh | sed 's/read -r CONTINUE < \/dev\/tty/CONTINUE=y/' > install.sh && \
  /bin/bash install.sh

# # VHDL Bakalint Installation
# ADD http://downloads.sourceforge.net/project/fpgalibre/bakalint/0.4.0/bakalint-0.4.0.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ffpgalibre%2Ffiles%2Fbakalint%2F0.4.0%2F&ts=1461844926&use_mirror=netcologne /root/bl.tar.gz
# RUN tar xf /root/bl.tar.gz -C /root/
# ENV PATH=$PATH:/root/bakalint-0.4.0

