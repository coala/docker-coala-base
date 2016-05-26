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


RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json

RUN pip install --no-cache-dir coala-bears

RUN npm install
ENV PATH $PATH:/node_modules/.bin
