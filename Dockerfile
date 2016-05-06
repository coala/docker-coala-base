FROM nfnty/arch-npm
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com

RUN pacman -Syu ruby php clang indent mono python python-pip python-setuptools git go wget --noconfirm

RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json

RUN pip install --no-cache-dir coala-bears

RUN npm install

ENV GOPATH $HOME/Go
ENV PATH $PATH:$GOPATH/bin:$GOROOT/bin
ENV PATH $PATH:/node_modules/.bin
