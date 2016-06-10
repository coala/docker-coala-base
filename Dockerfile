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

# GO setup
RUN source /etc/profile.d/go.sh \
  && RUN go get -u github.com/golang/lint/golint \
  && RUN go get -u golang.org/x/tools/cmd/goimports \
  && RUN go get -u sourcegraph.com/sqs/goreturns \
  && RUN go get -u golang.org/x/tools/cmd/gotype \
  && RUN go get -u github.com/kisielk/errcheck

RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json

RUN pip install --no-cache-dir coala-bears

RUN npm install
ENV PATH $PATH:/node_modules/.bin
