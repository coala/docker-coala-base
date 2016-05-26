FROM nfnty/arch-npm
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com


###############################################################################
# PACKAGE DEPENDENCIES
###############################################################################

RUN pacman -Syu \
  clang\
  cppcheck \
  espeak \
  git \
  go \
  hlint \
  indent\
  julia \
  luarocks \
  m4 \
  mono \
  perl \
  php \
  python \
  python-dbus \
  python-gobject \
  python-pip \
  python-setuptools \
  r \
  ruby \
  texlive-bin \
  wget \
  --noconfirm
  
###############################################################################
# AUR DEPENDENCIES
###############################################################################

# we need opam, perl-critic, verilator

# package (sub) dependencies
RUN pacman -Syu \
  base-devel \
  bison \
  boost \
  cmake \
  ocaml \
  perl-class-inspector \
  perl-clone \
  perl-config-tiny \
  perl-email-address \
  perl-exception-class \
  perl-file-remove \
  perl-file-sharedir \
  perl-file-which \
  perl-io-string \
  perl-list-moreutils \
  perl-module-build \
  perl-module-pluggable \
  perl-module-runtime \
  perl-params-util \
  perl-readonly \
  perl-role-tiny \
  perl-sub-exporter \
  perl-test-deep \
  perl-test-fatal \
  perl-test-pod \
  perl-test-pod-coverage \
  perl-tidy \
  re2c \
  scons \
  --noconfirm
  
# create build user and group 
RUN groupadd -r build
RUN useradd -r -g build build
RUN mkdir /tmp/build

# ensure permissions
RUN chown -R build:build /tmp/build && \
    chmod -R 771 /tmp/build

# opam and its dependencies, DO NOT CHANGE ORDER! 
#************************************************

# build opam dependency (clasp)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/clasp.git
WORKDIR /tmp/build/clasp
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/clasp
RUN pacman --noconfirm -U *.tar.xz

# build opam dependency (gringo)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/gringo.git
WORKDIR /tmp/build/gringo
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/gringo
RUN pacman --noconfirm -U *.tar.xz

# build opam dependency (aspcud)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/aspcud.git
WORKDIR /tmp/build/aspcud
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/aspcud
RUN pacman --noconfirm -U *.tar.xz

# build (opam)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/opam.git
WORKDIR /tmp/build/opam
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/opam
RUN pacman --noconfirm -U *.tar.xz


# perl-critic and its dependencies, DO NOT CHANGE ORDER!
# ******************************************************

# build perl-critic dependency (perl-string-format)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-string-format.git
WORKDIR /tmp/build/perl-string-format
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-string-format
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-file-sharedir-install)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-file-sharedir-install.git
WORKDIR /tmp/build/perl-file-sharedir-install
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-file-sharedir-install
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-lingua-en-inflect)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-lingua-en-inflect.git
WORKDIR /tmp/build/perl-lingua-en-inflect
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-lingua-en-inflect
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-path-tiny)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-path-tiny.git
WORKDIR /tmp/build/perl-path-tiny
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-path-tiny
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-class-tiny)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-class-tiny.git
WORKDIR /tmp/build/perl-class-tiny
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-class-tiny
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-file-homedir)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-file-homedir.git
WORKDIR /tmp/build/perl-file-homedir
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-file-homedir
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-path-isdev)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-path-isdev.git
WORKDIR /tmp/build/perl-path-isdev
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-path-isdev
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-path-finddev)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-path-finddev.git
WORKDIR /tmp/build/perl-path-finddev
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-path-finddev
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-file-sharedir-projectdistdir)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-file-sharedir-projectdistdir.git
WORKDIR /tmp/build/perl-file-sharedir-projectdistdir
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-file-sharedir-projectdistdir
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-pod-spell)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-pod-spell.git
WORKDIR /tmp/build/perl-pod-spell
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-pod-spell
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-readonly-xs)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-readonly-xs.git
WORKDIR /tmp/build/perl-readonly-xs
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-readonly-xs
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-hook-lexwrap)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-hook-lexwrap.git
WORKDIR /tmp/build/perl-hook-lexwrap
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-hook-lexwrap
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-test-subcalls)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-test-subcalls.git
WORKDIR /tmp/build/perl-test-subcalls
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-test-subcalls
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-test-object)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-test-object.git
WORKDIR /tmp/build/perl-test-object
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-test-object
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-task-weaken)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-task-weaken.git
WORKDIR /tmp/build/perl-task-weaken
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-task-weaken
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-ppi)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-ppi.git
WORKDIR /tmp/build/perl-ppi
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-ppi
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-b-keywords)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-b-keywords.git
WORKDIR /tmp/build/perl-b-keywords
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-b-keywords
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-ppix-utilities)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-ppix-utilities.git
WORKDIR /tmp/build/perl-ppix-utilities
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-ppix-utilities
RUN pacman --noconfirm -U *.tar.xz

# build perl-critic dependency (perl-ppix-regexp)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-ppix-regexp.git
WORKDIR /tmp/build/perl-ppix-regexp
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-ppix-regexp
RUN pacman --noconfirm -U *.tar.xz

# build (perl-critic)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/perl-critic.git
WORKDIR /tmp/build/perl-critic
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/perl-critic
RUN pacman --noconfirm -U *.tar.xz


# verilator and no dependencies, gotta love that!
# ***********************************************

# build (verilator)
USER build 
WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/verilator.git
WORKDIR /tmp/build/verilator
RUN makepkg --noconfirm
USER root 
WORKDIR /tmp/build/verilator
RUN pacman --noconfirm -U *.tar.xz

###############################################################################
# PYTHON DEPENDENCIES
###############################################################################

RUN mkdir /tmp/python
WORKDIR /tmp/python
ADD coala-requirements.txt coala-deps.txt
RUN pip install -r coala-deps.txt
ADD coala-test-requirements.txt coala-test-deps.txt
RUN pip install -r coala-test-deps.txt
# this will install coala as it is a dependency of coala-bears
ADD coala-bears-requirements.txt bears-deps.txt
RUN pip install -r bears-deps.txt
ADD coala-bears-test-requirements.txt bears-text-deps.txt
RUN pip install -r bears-test-deps.txt

# this will install coala-bears
RUN pip install --no-cache-dir coala-bears
WORKDIR /

###############################################################################
# OTHER DEPENDENCIES
###############################################################################

# add nltk data
ADD https://github.com/coala-analyzer/coala/blob/master/.misc/deps.nltk.sh deps.nltk.sh
RUN /bin/bash deps.nltk.sh

# NPM commands (/opt/alex clashes with npm deps; package.json deps will be installed)
RUN rm -rf /opt/alex
RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json
RUN npm install
ENV PATH $PATH:/node_modules/.bin

# R commands
RUN mkdir -p ~/.RLibrary
RUN echo '.libPaths( c( "~/.RLibrary", .libPaths()) )' >> .Rprofile
RUN echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' >> .Rprofile
RUN R -e "install.packages('lintr', dependencies=TRUE, quiet=TRUE, verbose=FALSE)"

# GO commands
RUN go get -u github.com/golang/lint/golint
RUN go get -u golang.org/x/tools/cmd/goimports
RUN go get -u sourcegraph.com/sqs/goreturns
RUN go get -u golang.org/x/tools/cmd/gotype
RUN go get -u github.com/kisielk/errcheck 

# Ruby commands
RUN bundle install

# Dart Lint commands
RUN if ! dartanalyzer -v &> /dev/null ; then wget -nc -O ~/dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/sdk/dartsdk-linux-x64-release.zip; unzip -n ~/dart-sdk.zip -d ~/;fi

# VHDL Bakalint Installation
RUN wget "http://downloads.sourceforge.net/project/fpgalibre/bakalint/0.4.0/bakalint-0.4.0.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ffpgalibre%2Ffiles%2Fbakalint%2F0.4.0%2F&ts=1461844926&use_mirror=netcologne" -O ~/bl.tar.gz
RUN tar xf ~/bl.tar.gz -C ~/

# Julia commands
RUN julia -e "Pkg.add(\"Lint\")"

# Lua commands
RUN sudo luarocks install luacheck --deps-mode=none

# Infer commands
RUN if [ ! -e ~/infer-linux64-v0.7.0/infer/bin ]; then wget -nc -O ~/infer.tar.xz https://github.com/facebook/infer/releases/download/v0.7.0/infer-linux64-v0.7.0.tar.xz; tar xf ~/infer.tar.xz -C ~/; cd ~/infer-linux64-v0.7.0; opam init --y; opam update; opam pin add --yes --no-action infer .; opam install --deps-only --yes infer; ./build-infer.sh java; fi

# PMD commands
RUN if [ ! -e ~/pmd-bin-5.4.1/bin ]; then wget -nc -O ~/pmd.zip https://github.com/pmd/pmd/releases/download/pmd_releases%2F5.4.1/pmd-bin-5.4.1.zip; unzip ~/pmd.zip -d ~/; fi

# Tailor (Swift) commands
RUN curl -fsSL https://tailor.sh/install.sh | sed 's/read -r CONTINUE < \/dev\/tty/CONTINUE=y/' > install.sh
RUN sudo bash install.sh
