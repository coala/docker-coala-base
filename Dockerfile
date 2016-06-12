FROM opensuse:tumbleweed
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com

RUN zypper addrepo -f \
  http://download.opensuse.org/repositories/devel:/languages:/lua/openSUSE_Factory/ \
  devel:languages:lua

RUN zypper --no-gpg-checks update --no-confirm && zypper install --no-confirm \
  cppcheck \
  curl \
  espeak \
  dbus-1-python3 \
  git \
  go \
  hlint \
  indent \
  julia \
  libclang \
  lua \
  lua-devel \
  luarocks \
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
  unzip \
  verilator \
  wget

# Coala setup and python deps
RUN pip install --upgrade pip
RUN mkdir /tmp/coala
WORKDIR /tmp/coala
ADD coala-requirements.txt coala-deps.txt
RUN pip install -r coala-deps.txt
ADD coala-test-requirements.txt coala-test-deps.txt
RUN pip install -r coala-test-deps.txt
# this will install coala as it is a dependency of coala-bears
ADD coala-bears-requirements.txt bears-deps.txt
RUN pip install -r bears-deps.txt
ADD coala-bears-test-requirements.txt bears-test-deps.txt
RUN pip install -r bears-test-deps.txt

# this will install coala-bears
RUN pip install --no-cache-dir coala-bears
WORKDIR /

# GO setup
RUN source /etc/profile.d/go.sh \
  && go get -u github.com/golang/lint/golint \
  && go get -u golang.org/x/tools/cmd/goimports \
  && go get -u sourcegraph.com/sqs/goreturns \
  && go get -u golang.org/x/tools/cmd/gotype \
  && go get -u github.com/kisielk/errcheck
  
# Julia setup
RUN julia -e "Pkg.add(\"Lint\")"

# Lua commands
RUN luarocks install luacheck

# NPM setup
RUN wget https://raw.githubusercontent.com/coala-analyzer/coala-bears/master/package.json
RUN npm install
ENV PATH $PATH:/node_modules/.bin

# R setup
RUN mkdir -p ~/.RLibrary
RUN echo '.libPaths( c( "~/.RLibrary", .libPaths()) )' >> .Rprofile
RUN echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' >> .Rprofile
RUN R -e "install.packages('lintr', dependencies=TRUE, quiet=TRUE, verbose=FALSE)"
