FROM opensuse:tumbleweed
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com

RUN zypper update --no-confirm && zypper install --no-confirm \
  cppcheck \
  espeak \
  dbus-1-python3 \
  git \
  go \
  hlint \
  indent \
  julia \
  libclang \
  m4 \
  mono \
  npm \
  perl \
  perl-Perl-Critic \
  php \
  python3 \
  python3-gobject \
  python3-pip \
  python3-setuptools \
  R-base \
  ruby \
  texlive-chktex \
  verilator \
  wget

# GO setup
RUN source /etc/profile.d/go.sh \
  && go get -u github.com/golang/lint/golint \
  && go get -u golang.org/x/tools/cmd/goimports \
  && go get -u sourcegraph.com/sqs/goreturns \
  && go get -u golang.org/x/tools/cmd/gotype \
  && go get -u github.com/kisielk/errcheck

RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json

RUN pip install --no-cache-dir coala-bears

RUN npm install
ENV PATH $PATH:/node_modules/.bin
