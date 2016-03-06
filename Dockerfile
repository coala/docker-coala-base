FROM nfnty/arch-npm
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com

RUN pacman -Syu ruby php clang indent mono python python-pip python-setuptools git go wget --noconfirm

RUN wget https://raw.githubusercontent.com/coala-analyzer/coala/master/Goopfile
RUN wget https://raw.githubusercontent.com/coala-analyzer/coala/master/package.json

RUN pip install --no-cache-dir coala-bears coala --pre

ENV GOPATH $HOME/Go
ENV PATH $PATH:$GOPATH/bin:$GOROOT/bin
RUN go get -u github.com/karmakaze/goop
RUN goop install

RUN npm install
ENV PATH $PATH:/node_modules/.bin
