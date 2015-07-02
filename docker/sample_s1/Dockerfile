# Copyright (C) 2015 Toshinori Sato (@overlast)
#
#       https://github.com/overlast/word-vector-web-api
#
# Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
RUN mkdir -p /var/cache/nginx/cache

# word2vec-msgpack-rpc-server
RUN curl http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm -o /root/tmp/epel-release-6-8.noarch.rpm
RUN yum -y install epel-release
RUN yum --enablerepo=epel -y install jansson jansson-devel
RUN git clone https://github.com/overlast/word2vec-msgpack-rpc-server /root/git/word2vec-msgpack-rpc-server
RUN cd /root/git/word2vec-msgpack-rpc-server; waf configure; waf build; waf install

# mecab
#RUN curl -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" -o /root/tmp/mecab-0.996.tar.gz
#RUN cd /root/tmp/; tar xfvz mecab-0.996.tar.gz
#RUN cd /root/tmp/mecab-0.996; ./configure; make; make check; make install
#RUN /sbin/ldconfig

# mecab-ipadic
#RUN curl -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" -o /root/tmp/mecab-ipadic-2.7.0-20070801.tar.gz
#RUN cd /root/tmp/;tar xfvz mecab-ipadic-2.7.0-20070801.tar.gz
#RUN cd /root/tmp/mecab-ipadic-2.7.0-20070801; ./configure --with-charset=utf8; make; make install

# commands
RUN yum -y install patch which xz file

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

ENTRYPOINT /root/git/word-vector-web-api/libexec/boot-word-vector-web-api-sample-1-slave.sh
