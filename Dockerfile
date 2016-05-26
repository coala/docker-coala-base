FROM nfnty/arch-npm
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com

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

RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json

RUN pip install --no-cache-dir coala-bears

RUN npm install
ENV PATH $PATH:/node_modules/.bin
