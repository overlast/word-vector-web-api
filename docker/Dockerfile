FROM centos:centos6
MAINTAINER Toshinori Sato <@overlast>

RUN yum -y update
RUN yum -y install gcc  gcc-c++ automake libtool git tar openssl openssl-devel

# local ldconfig
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/local.conf
RUN echo "/usr/local/lib64" >> /etc/ld.so.conf.d/local.conf
RUN /sbin/ldconfig

# git files
RUN mkdir /root/git

# msgpack-c
RUN git clone https://github.com/msgpack/msgpack-c.git /root/git/msgpack-c
RUN cd /root/git/msgpack-c
RUN git checkout refs/tags/cpp-0.5.9
RUN ./bootstrap
RUN  ./configure
RUN  make
RUN  make install
RUN /sbin/ldconfig

# mpio
RUN yum -y install ruby
RUN git clone https://github.com/frsyuki/mpio.git
RUN cd  /root/git/mpio
RUN sed  -i -e "s/ -rmpl / -r.\/mpl /g" ./preprocess
RUN ./bootstrap
RUN ./configure
RUN make
RUN make install
RUN /sbin/ldconfig

# msgpack-rpc-cpp
RUN git clone https://github.com/msgpack-rpc/msgpack-rpc-cpp.git /root/git/msgpack-rpc-cpp
RUN cd  /root/git/msgpack-rpc-cpp
RUN ./bootstrap
RUN ./configure
RUN make
RUN make install
RUN /sbin/ldconfig

# waf
RUN curl https://waf.io/waf-1.8.11 -o waf
RUN mv /usr/local/bin/waf
RUN chmod 755 /usr/local/bin/waf

#  msgpack-rpc-c
RUN git clone https://github.com/overlast/msgpack-rpc-c.git /root/git/msgpack-rpc-c
RUN  cd /root/git/msgpack-rpc-c
RUN  waf configure
 RUN waf build
  RUN waf install
RUN /sbin/ldconfig

# temporary directory
RUN mkdir /root/tmp

# nginx-with-msgpack-rpc-module
RUN curl http://nginx.org/download/nginx-1.8.0.tar.gz -o /root/tmp/nginx-1.8.0.tar.gz
RUN cd /root/tmp
RUN tar xfvz ./nginx-1.8.0.tar.gz
RUN cd nginx-1.8.0
RUN git clone https://github.com/openresty/echo-nginx-module.git /root/git/echo-nginx-module
RUN git clone https://github.com/overlast/nginx-msgpack-rpc-module.git /root/git/nginx-msgpack-rpc-module
RUN  ./configure --add-module=/root/git/echo-nginx-module --add-module=/root/git/nginx-msgpack-rpc-module --prefix=/usr/local/nginx-with-msgpack-rpc-module
RUN /root/git/nginx-msgpack-rpc-module/bin/fix_makefile.pl ./objs/Makefile
RUN make
RUN make install
RUN /sbin/ldconfig

# word2vec-msgpack-rpc-server
RUN yum -y install jansson jansson-devel
RUN git clone https://github.com/overlast/word2vec-msgpack-rpc-server /root/git/word2vec-msgpack-rpc-server
RUN cd /root/git/word2vec-msgpack-rpc-server
RUN  waf configure
 RUN waf build
  RUN waf install

# mecab
RUN curl -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" -o /root/tmp/mecab-0.996.tar.gz
RUN cd /root/tmp/
RUN tar xfvz mecab-0.996.tar.gz
RUN cd mecab-0.996
RUN ./configure
RUN make
RUN make check
RUN make install
RUN /sbin/ldconfig

# mecab-ipadic
RUN curl -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" -o /root/tmp/mecab-ipadic-2.7.0-20070801.tar.gz
RUN cd /root/tmp/
RUN tar xfvz mecab-ipadic-2.7.0-20070801.tar.gz
RUN cd mecab-ipadic-2.7.0-20070801
RUN ./configure --with-charset=utf8
RUN make
RUN make install


# mecab-ipadic-neologd
RUN yum -y install patch
RUN git clone https://github.com/neologd/mecab-ipadic-neologd.git /root/git/mecab-ipadic-neologd
RUN cd  /root/git/mecab-ipadic-neologd
RUN ./bin/install-mecab-ipadic-neologd -n -y -u

# word-vector-web-api
RUN git clone https://github.com/overlast/word-vector-web-api /root/git/word-vector-web-api
RUN cd /root/git/word-vector-web-api
RUN ln -s /root/git/word-vector-web-api/www /usr/local/nginx-with-msgpack-rpc-module/www

# word2vec on word-vector-web-api
RUN yum -y install svn
RUN svn checkout http://word2vec.googlecode.com/svn/trunk/ word2vec
RUN  patch ./word2vec/word2vec.c < patch/word2vec.rev42.local.patch
RUN  sed -i -e "s/-OFast/-O3/g" ./word2vec/makefile
RUN cd ./word2vec

# model directory
RUN cd /root/git/word-vector-web-api/
RUN mkdir model

# sample model downloader
RUN  yum install -y go hg
RUN git clone https://github.com/prasmussen/gdrive.git /root/git/gdrive
RUN  cd /root/git/gdrive
RUN export GOPATH=$HOME/go
RUN go get github.com/prasmussen/gdrive/cli
RUN go get github.com/voxelbrain/goptions
RUN go get code.google.com/p/goauth2/oauth
RUN go build drive.go
