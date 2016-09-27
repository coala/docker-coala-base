FROM opensuse:tumbleweed
MAINTAINER Fabian Neuschmidt fabian@neuschmidt.de

# Set the locale
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  

# Add repos for suitesparse and luarocks
RUN zypper addrepo http://download.opensuse.org/repositories/home:stecue/openSUSE_Tumbleweed/home:stecue.repo

RUN zypper addrepo -f \
  http://download.opensuse.org/repositories/devel:/languages:/lua/openSUSE_Factory/ \
  devel:languages:lua

# Package dependencies
RUN zypper --no-gpg-checks --non-interactive dist-upgrade && \
  zypper --non-interactive install -t pattern devel_basis && \
  zypper --non-interactive install \
  bzr \
  cppcheck \
  curl \
  espeak \
  dbus-1-python3 \
  gcc-c++ \
  gcc-fortran \
  git \
  go \
  gsl \
  mercurial \
  hlint \
  indent \
  java \
  java-1_8_0-openjdk-devel \
  julia \
  libcholmod-3_0_6 \
  libclang3_8 \
  libcurl-devel \
  libncurses5 \
  libopenssl-devel \
  libxml2-tools \
  lua \
  lua-devel \
  luarocks \
  m4 \
  mono \
  npm \
  perl \
  perl-Perl-Critic \
  php \
  python3 \
  python3-gobject \
  python3-pip \
  python3-setuptools \
  R-base \
  ruby \
  ruby-devel \
  ShellCheck \
  subversion \
  sudo \
  suitesparse-devel \
  tar \
  texlive-chktex \
  unzip \
  verilator \
  wget

# Coala setup and python deps
RUN pip3 install --upgrade pip

RUN git clone https://github.com/coala-analyzer/coala.git
WORKDIR /coala
RUN git checkout release/0.8
RUN pip3 install -r requirements.txt
RUN pip3 install -r test-requirements.txt
RUN pip3 install -e .
WORKDIR /

RUN git clone https://github.com/coala-analyzer/coala-bears.git
WORKDIR /coala-bears
RUN git checkout release/0.8
RUN pip3 install -r requirements.txt
RUN pip3 install -r test-requirements.txt
RUN pip3 install -e .
WORKDIR /

# Dart Lint setup
ADD https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/sdk/dartsdk-linux-x64-release.zip /root/dart-sdk.zip
RUN unzip -n /root/dart-sdk.zip -d ~/
ENV PATH=$PATH:/root/dart-sdk/bin

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
# RUN ["julia", "-e", "\\"Pkg.add(\\\\"Lint\\\\")\\""]

# Lua commands
RUN luarocks install luacheck

# NPM setup
# FIXME: we should use package.json from coala
RUN npm install -g \
  alex \
  autoprefixer \
  bootlint \
  coffeelint \
  complexity-report \
  csslint \
  dockerfile_lint \
  eslint \
  jshint \
  postcss-cli \
  remark-cli \
  tslint \
  typescript \
  ramllint

# Nltk data
RUN python3 -m nltk.downloader punkt
RUN python3 -m nltk.downloader maxent_treebank_pos_tagger
RUN python3 -m nltk.downloader averaged_perceptron_tagger

# PMD setup
ADD https://github.com/pmd/pmd/releases/download/pmd_releases%2F5.4.1/pmd-bin-5.4.1.zip /root/pmd.zip
RUN unzip /root/pmd.zip -d /root/
ENV PATH=$PATH:/root/pmd-bin-5.4.1/bin

# R setup
RUN mkdir -p ~/.RLibrary
RUN echo '.libPaths( c( "~/.RLibrary", .libPaths()) )' >> ~/.Rprofile
RUN echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' >> ~/.Rprofile
RUN R -e "install.packages('lintr', dependencies=TRUE,  verbose=FALSE)"
RUN R -e "install.packages('formatR', dependencies=TRUE, verbose=FALSE)"

# Ruby gems
# FIXME: we should use gemfile from coala
RUN gem install rubocop sqlint scss_lint reek && \
  ln -s /usr/bin/rubocop.ruby2.2 /usr/bin/rubocop && \
  ln -s /usr/bin/scss-lint.ruby2.2 /usr/bin/scss-lint && \
  ln -s /usr/bin/sqlint.ruby2.2 /usr/bin/sqlint && \
  ln -s /usr/bin/reek.ruby2.2 /usr/bin/reek

# Tailor (Swift) setup
RUN curl -fsSL https://tailor.sh/install.sh | sed 's/read -r CONTINUE < \/dev\/tty/CONTINUE=y/' > install.sh
RUN /bin/bash install.sh

# # VHDL Bakalint Installation
# ADD http://downloads.sourceforge.net/project/fpgalibre/bakalint/0.4.0/bakalint-0.4.0.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ffpgalibre%2Ffiles%2Fbakalint%2F0.4.0%2F&ts=1461844926&use_mirror=netcologne /root/bl.tar.gz
# RUN tar xf /root/bl.tar.gz -C /root/
# ENV PATH=$PATH:/root/bakalint-0.4.0

