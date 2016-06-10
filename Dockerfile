FROM opensuse:tumbleweed
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com

RUN zypper update --no-confirm && zypper install --no-confirm \
  git \
  go \
  indent \
  libclang \
  mono \
  npm \
  php \
  python3 \
  python3-pip \
  python3-setuptools \
  ruby \
  texlive-chktex \
  wget

RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json

RUN pip install --no-cache-dir coala-bears

RUN npm install
ENV PATH $PATH:/node_modules/.bin
