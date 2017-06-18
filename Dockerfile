FROM opensuse:tumbleweed
MAINTAINER Fabian Neuschmidt fabian@neuschmidt.de

ARG branch=master
RUN echo branch=$branch

# Set the locale
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    PATH=$PATH:/root/pmd-bin-5.4.1/bin:/root/dart-sdk/bin:/coala-bears/node_modules/.bin:/root/bakalint-0.4.0:/root/elm-format-0.18 \
    NODE_PATH=/coala-bears/node_modules

# Create symlink for cache
RUN mkdir -p /root/.local/share/coala && \
  ln -s /root/.local/share/coala /cache

# Add packaged flawfinder
RUN zypper addrepo http://download.opensuse.org/repositories/home:illuusio/openSUSE_Tumbleweed/home:illuusio.repo && \
  # Remove unnecessary repos to avoid refreshes
  zypper removerepo 'NON-OSS' && \
  # Package dependencies
  time zypper --no-gpg-checks --non-interactive \
      # science contains latest Julia
      --plus-repo http://download.opensuse.org/repositories/science/openSUSE_Tumbleweed/ \
      # luarocks
      --plus-repo http://download.opensuse.org/repositories/devel:languages:lua/openSUSE_Tumbleweed/ \
      install \
    bzr \
    cppcheck \
    curl \
    expect \
    flawfinder \
    gcc-c++ \
    gcc-fortran \
    git \
    go \
    mercurial \
    hlint \
    indent \
    java-1_8_0-openjdk-headless \
    julia \
    libclang3_8 \
    # libcurl-devel needed by R httr
    libcurl-devel \
    # icu needed by R stringi
    libicu-devel \
    libopenssl-devel \
    # pcre needed by Julia runtime
    libpcre2-8-0 \
    libxml2-devel \
    # libxml2-tools provides xmllint
    libxml2-tools \
    libxslt-devel \
    # needed for licensecheck
    devscripts \
    # linux-glibc-devel needed for Ruby native extensions
    linux-glibc-devel \
    lua \
    lua-devel \
    luarocks \
    m4 \
    nodejs6 \
    npm \
    # patch is used by Ruby gem pg_query
    patch \
    perl-Perl-Critic \
    php \
    php7-pear \
    # Needed for PHPMD
    php7-dom \
    php7-imagick \
    # Needed for PHP CodeSniffer
    php7-pear-Archive_Tar \
    php7-tokenizer \
    php7-xmlwriter \
    # Used by bzr, mecurial, hgext, and flawfinder
    python \
    python3 \
    # Needed for proselint
    python3-dbm \
    python3-pip \
    python3-devel \
    R-base \
    ruby \
    ruby-devel \
    ruby2.2-rubygem-bundler \
    ShellCheck \
    subversion \
    tar \
    texlive-chktex \
    unzip && \
  time rpm -e -f --nodeps -v \
    aaa_base \
    cron \
    cronie \
    dbus-1 \
    fdupes \
    fontconfig \
    fonts-config \
    kbd \
    iproute2 \
    kmod \
    libICE6 \
    libnl-config \
    libthai-data \
    libxcb1 libxcb-render0 libxcb-shm0 \
    libX11-6 libX11-data \
    libXau6 \
    libXext6 \
    libXft2 \
    libXmu6 \
    libXmuu1 \
    libXrender1 \
    libXss1 libXt6 \
    lksctp-tools \
    logrotate \
    ncurses-utils \
    openssh \
    openslp \
    perl-File-ShareDir \
    perl-Net-DBus \
    perl-Pod-Coverage \
    perl-Test-Pod \
    perl-Test-Pod-Coverage \
    perl-X11-Protocol \
    postfix \
    php7-zlib \
    python-curses \
    python-rpm-macros \
    python-xml \
    R-core-doc \
    rsync \
    rsyslog \
    sysconfig \
    sysconfig-netconfig \
    syslog-service \
    systemd \
    texlive-gsftopk \
    texlive-gsftopk-bin \
    texlive-kpathsea \
    texlive-kpathsea-bin \
    texlive-tetex-bin \
    texlive-texconfig \
    texlive-texconfig-bin \
    texlive-texlive.infra \
    texlive-updmap-map \
    util-linux-systemd \
    wicked \
    wicked-service \
    xhost \
    xorg-x11-fonts \
    xorg-x11-fonts-core \
    && \
  rm -rf \
    /usr/lib64/python2.7/doctest.py \
    /usr/lib64/python2.7/ensurepip/ \
    /usr/lib64/python2.7/idlelib/ \
    /usr/lib64/python2.7/imaplib.py \
    /usr/lib64/python2.7/lib2to3/ \
    /usr/lib64/python2.7/pydoc.py \
    /usr/lib64/python2.7/pydoc_data/ \
    /usr/lib64/python2.7/unittest/ \
    /usr/lib64/python2.7/test/ \
    /usr/lib64/python2.7/turtle.py \
    /usr/lib64/python2.7/wsgiref \
    /usr/lib64/python2.7/site-packages/bzrlib/doc/ \
    /usr/lib64/python2.7/site-packages/bzrlib/export/ \
    /usr/lib64/python2.7/site-packages/bzrlib/help_topics/en/ \
    /usr/lib64/python2.7/site-packages/hgext/convert/ \
    /usr/lib64/python2.7/site-packages/mercurial/help/ \
    /usr/lib64/python2.7/site-packages/mercurial/hgweb/ \
    /usr/lib64/python2.7/site-packages/mercurial/templates/ \
    /usr/lib64/ruby/gems/2.2.0/gems/bundler-*/man/* \
    /usr/lib64/R/library/translations/*/LC_MESSAGES/*.[mp]o* \
    /usr/lib64/R/library/*/po/* \
    /usr/lib64/R/library/*/doc/* \
    /usr/lib64/R/library/*/help/* \
    /usr/lib64/R/library/*/demo/* \
    /usr/lib64/R/library/*/man/* \
    /usr/lib64/R/library/*/NEWS \
    /usr/lib64/libsvnjavahl-* \
    /usr/lib64/svn-javahl \
    /usr/share/emacs/ \
    /usr/share/xemacs/ \
    /usr/share/locale/*/LC_MESSAGES/*.[mp]o* \
    /var/log/ \
    && \
  find /usr/lib64/python2.7/ \
    \( -name 'test' -o -name 'tests' -o -name 'test_*' -o \
       -name '*.pyc' -o -name '*.pyo' \
    \) -prune -exec rm -rf '{}' '+' \
    && \
  # Clear zypper cache
  time zypper clean -a && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# Coala setup and python deps
RUN cd / && \
  git clone --depth 1 --branch=$branch https://github.com/coala/coala.git && \
  git clone --depth 1 --branch=$branch https://github.com/coala/coala-bears.git && \
  git clone --depth 1 https://github.com/coala/coala-quickstart.git && \
  time pip3 install --no-cache-dir \
    -e /coala \
    -e '/coala-bears[alldeps]' \
    -e /coala-quickstart \
    -r /coala/test-requirements.txt && \
  cd coala-bears && \
  # NLTK data
  time python3 -m nltk.downloader punkt maxent_treebank_pos_tagger averaged_perceptron_tagger && \
  # Remove Ruby directive from Gemfile as this image has 2.2.5
  sed -i '/^ruby/d' Gemfile && \
  # Ruby dependencies
  time bundle install --system && rm -rf ~/.bundle && \
  # NPM dependencies
  time npm install && npm cache clean && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

RUN time pear install PHP_CodeSniffer && \
  pear channel-discover pear.phpmd.org && \
  pear channel-discover pear.pdepend.org && \
  pear install --alldeps phpmd/PHP_PMD && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# Dart Lint setup
RUN curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/sdk/dartsdk-linux-x64-release.zip -o /tmp/dart-sdk.zip && \
  unzip -n /tmp/dart-sdk.zip -d ~/ && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

RUN curl -fsSL https://github.com/avh4/elm-format/releases/download/0.5.2-alpha/elm-format-0.17-0.5.2-alpha-linux-x64.tgz -o /tmp/elm-format.tgz && \
  mkdir ~/elm-format-0.18 && \
  tar -xvzf /tmp/elm-format.tgz -C ~/elm-format-0.18 && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# GO setup
RUN source /etc/profile.d/go.sh && time go get -u \
  github.com/golang/lint/golint \
  golang.org/x/tools/cmd/goimports \
  sourcegraph.com/sqs/goreturns \
  golang.org/x/tools/cmd/gotype \
  github.com/BurntSushi/toml/cmd/tomlv \
  github.com/kisielk/errcheck && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

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
RUN time julia -e 'Pkg.add("Lint")' && \
  rm -rf \
    ~/.julia/.cache \
    ~/.julia/v0.5/.cache \
    ~/.julia/v0.5/METADATA \
    ~/.julia/v0.5/*/.git \
    ~/.julia/v0.5/*/test \
    ~/.julia/v0.5/*/docs && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# Lua commands
RUN time luarocks install luacheck && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# PMD setup
RUN curl -fsSL https://github.com/pmd/pmd/releases/download/pmd_releases/5.4.1/pmd-bin-5.4.1.zip -o /tmp/pmd.zip && \
  unzip /tmp/pmd.zip -d ~/ && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# R setup
RUN mkdir -p ~/.RLibrary && \
  echo '.libPaths( c( "~/.RLibrary", .libPaths()) )' >> ~/.Rprofile && \
  echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' >> ~/.Rprofile && \
  export ICUDT_DIR=/usr/share/icu/57.1/ && \
  time R -e "install.packages(c('lintr', 'formatR'), dependencies=TRUE, verbose=FALSE)" && \
  rm -rf \
    ~/.RLibrary/*/annouce/* \
    ~/.RLibrary/*/po/* \
    ~/.RLibrary/*/demo/* \
    ~/.RLibrary/*/doc/* \
    ~/.RLibrary/*/examples/* \
    ~/.RLibrary/*/help/* \
    ~/.RLibrary/*/html/* \
    ~/.RLibrary/*/man/* \
    ~/.RLibrary/*/tests/ \
    ~/.RLibrary/*/NEWS \
    ~/.RLibrary/Rcpp/unitTests/ \
    && \
  unset ICUDT_DIR && export ICUDT_DIR && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# Tailor (Swift) setup
RUN curl -fsSL https://tailor.sh/install.sh | sed 's/read -r CONTINUE < \/dev\/tty/CONTINUE=y/' > install.sh && \
  time /bin/bash install.sh && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# # VHDL Bakalint Installation
RUN curl -L 'http://downloads.sourceforge.net/project/fpgalibre/bakalint/0.4.0/bakalint-0.4.0.tar.gz' > /tmp/bl.tar.gz && \
  tar xf /tmp/bl.tar.gz -C /root/ && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# Add checkstyle image
RUN mkdir -p /root/.local/share/coala-bears/CheckstyleBear && \
  curl -fsSL https://github.com/coala/bear-runtime-deps/raw/master/CheckstyleBear/checkstyle-6.15-all.jar -o /root/.local/share/coala-bears/CheckstyleBear/checkstyle-6.15-all.jar && \
  ln -s /root/.local/share/coala-bears/CheckstyleBear/checkstyle-6.15-all.jar /root/.local/share/coala-bears/CheckstyleBear/checkstyle.jar && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# Scalalint Installation
RUN mkdir -p /root/.local/share/coala-bears/ScalaLintBear && \
  curl -fsSL https://github.com/coala/bear-runtime-deps/raw/master/ScalaLintBear/scalastyle_2.10-0.8.0-batch.jar -o /root/.local/share/coala-bears/ScalaLintBear/scalastyle_2.10-0.8.0-batch.jar && \
  ln -s /root/.local/share/coala-bears/ScalaLintBear/scalastyle_2.10-0.8.0-batch.jar /root/.local/share/coala-bears/ScalaLintBear/scalastyle.jar && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

# Entrypoint script
ADD docker-coala.sh /usr/local/bin/
CMD ["/usr/local/bin/docker-coala.sh"]
