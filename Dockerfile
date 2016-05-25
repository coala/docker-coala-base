FROM nfnty/arch-npm
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com

RUN pacman -Syu \
  clang \
  git \
  go \
  indent \
  mono \
  php \
  python \
  python-pip \
  python-setuptools \
  ruby \
  texlive-bin \
  wget \
  --noconfirm

RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json

RUN pip install --no-cache-dir coala-bears

RUN npm install
ENV PATH $PATH:/node_modules/.bin
