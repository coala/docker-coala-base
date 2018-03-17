FROM opensuse:tumbleweed
MAINTAINER The coala developers - coala-devel@googlegroups.com

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

ADD packages.txt .

RUN \
  zypper addlock \
    postfix \
    'julia < 0.6' 'julia >= 0.7' julia-compat \
    && \
  # Remove unnecessary repos to avoid refreshes
  zypper removerepo 'NON-OSS' && \
  # Package dependencies
  echo 'Running zypper install ...' && \
  (time zypper -vv --no-gpg-checks --non-interactive $(sed -e 's/#.*$//' -e '/^$/d' packages.txt) > /tmp/zypper.out \
    || (cat /tmp/zypper.out && false)) \
    && \
  grep -E '(new packages to install|^Retrieving: )' /tmp/zypper.out && \
  time rpm -e -f --nodeps -v $(sed -e 's/#.*$//' -e '/^$/d' unused-packages.txt) \
    && \
  # Disable nltk downloader
  printf 'def download(*args): pass\ndownload_shell = download\n' \
    > /usr/lib/python3.6/site-packages/nltk/downloader.py && \
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

# rocker TAG {{ .image }}_suse

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
  rm -rf ~/.julia/.cache && \
  (cd ~/.julia/v0.* && \
   rm -rf \
     .cache \
     METADATA \
     .git \
     */test \
     */docs \
  ) && \
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
RUN \
  cd /tmp && \
  curl -fsSL -o /tmp/install.orig \
    https://raw.githubusercontent.com/sleekbyte/tailor/master/script/install.sh && \
  sed 's/read -r CONTINUE < \/dev\/tty/CONTINUE=y/' install.orig > install.sh && \
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

# rocker TAG {{ .image }}
