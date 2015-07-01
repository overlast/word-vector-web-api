FROM centos:centos6
MAINTAINER Toshinori Sato <@overlast>

RUN yum -y update
RUN yum -y clean all
RUN yum -y install gcc  gcc-c++ automake libtool git tar openssl openssl-devel

# local ldconfig
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/local.conf
RUN echo "/usr/local/lib64" >> /etc/ld.so.conf.d/local.conf
RUN /sbin/ldconfig

# git files
RUN mkdir /root/git

# msgpack-c
RUN git clone https://github.com/msgpack/msgpack-c.git /root/git/msgpack-c
RUN cd /root/git/msgpack-c; git checkout refs/tags/cpp-0.5.9; ./bootstrap; ./configure; make; make install;
RUN /sbin/ldconfig

# mpio
RUN yum -y install ruby
RUN git clone https://github.com/frsyuki/mpio.git /root/git/mpio
RUN cd  /root/git/mpio; sed  -i -e "s/ -rmpl / -r.\/mpl /g" ./preprocess; ./bootstrap; ./configure; make; make install;
RUN /sbin/ldconfig

# msgpack-rpc-cpp
RUN git clone https://github.com/msgpack-rpc/msgpack-rpc-cpp.git /root/git/msgpack-rpc-cpp
RUN cd  /root/git/msgpack-rpc-cpp; ./bootstrap; ./configure; make; make install
RUN /sbin/ldconfig

# temporary directory
RUN mkdir /root/tmp

# waf
RUN curl https://waf.io/waf-1.8.11 -o /root/tmp/waf; cp /root/tmp/waf /usr/local/bin/waf
RUN chmod 755 /usr/local/bin/waf

#  msgpack-rpc-c
RUN git clone https://github.com/overlast/msgpack-rpc-c.git /root/git/msgpack-rpc-c
RUN cd /root/git/msgpack-rpc-c; waf configure; waf build; waf install
RUN /sbin/ldconfig


# nginx-with-msgpack-rpc-module
RUN yum -y install pcre-devel
RUN git clone https://github.com/openresty/echo-nginx-module.git /root/git/echo-nginx-module
RUN git clone https://github.com/overlast/nginx-msgpack-rpc-module.git /root/git/nginx-msgpack-rpc-module
RUN curl http://nginx.org/download/nginx-1.8.0.tar.gz -o /root/tmp/nginx-1.8.0.tar.gz
RUN cd /root/tmp; tar xfvz ./nginx-1.8.0.tar.gz
RUN cd /root/tmp/nginx-1.8.0; ./configure --add-module=/root/git/echo-nginx-module --add-module=/root/git/nginx-msgpack-rpc-module --prefix=/usr/local/nginx-with-msgpack-rpc-module; /root/git/nginx-msgpack-rpc-module/bin/fix_makefile.pl /root/tmp/nginx-1.8.0/objs/Makefile; make; make install
RUN /sbin/ldconfig

# word2vec-msgpack-rpc-server
RUN curl http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm -o /root/tmp/epel-release-6-8.noarch.rpm
RUN yum -y install epel-release
RUN yum --enablerepo=epel -y install jansson jansson-devel
RUN git clone https://github.com/overlast/word2vec-msgpack-rpc-server /root/git/word2vec-msgpack-rpc-server
RUN cd /root/git/word2vec-msgpack-rpc-server; waf configure; waf build; waf install

# mecab
RUN curl -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" -o /root/tmp/mecab-0.996.tar.gz
RUN cd /root/tmp/; tar xfvz mecab-0.996.tar.gz
RUN cd /root/tmp/mecab-0.996; ./configure; make; make check; make install
RUN /sbin/ldconfig

# mecab-ipadic
RUN curl -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" -o /root/tmp/mecab-ipadic-2.7.0-20070801.tar.gz
RUN cd /root/tmp/;tar xfvz mecab-ipadic-2.7.0-20070801.tar.gz
RUN cd /root/tmp/mecab-ipadic-2.7.0-20070801; ./configure --with-charset=utf8; make; make install

# mecab-ipadic-neologd
RUN yum -y install patch which xz file
#RUN git clone https://github.com/neologd/mecab-ipadic-neologd.git /root/git/mecab-ipadic-neologd
#RUN cd  /root/git/mecab-ipadic-neologd; ./bin/install-mecab-ipadic-neologd -n -y -u

# word-vector-web-api
RUN git clone https://github.com/overlast/word-vector-web-api /root/git/word-vector-web-api
RUN ln -s /root/git/word-vector-web-api/www /usr/local/nginx-with-msgpack-rpc-module/www

# word2vec on word-vector-web-api
RUN yum -y install svn
RUN svn checkout http://word2vec.googlecode.com/svn/trunk/ /root/git/word-vector-web-api/word2vec
RUN patch /root/git/word-vector-web-api/word2vec/word2vec.c < /root/git/word-vector-web-api/patch/word2vec.rev42.local.patch;
RUN sed -i -e "s/-OFast/-O3/g" /root/git/word-vector-web-api/word2vec/makefile;
RUN cd /root/git/word-vector-web-api/word2vec/; make

EXPOSE 22670
EXPOSE 22671
EXPOSE 22672
EXPOSE 22673
EXPOSE 22674
EXPOSE 22675
EXPOSE 22676
EXPOSE 22677
EXPOSE 22678
EXPOSE 22679
EXPOSE 22680

CMD /usr/local/bin/word2vec-msgpack-rpc-server -m /var/tmp/sample-word-vector-web-api/jawiki.20150602.neologd.bin -p 22676  > /dev/null 2>&1 &
CMD mkdir -p /var/cache/nginx/cache
CMD /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c /root/git/word-vector-web-api/conf/sample-word-vector-web-api-slave1.conf
CMD /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c /root/git/word-vector-web-api/conf/sample-word-vector-web-api-master-solo.conf
