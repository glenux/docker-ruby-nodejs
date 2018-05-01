FROM ruby:2.4
MAINTAINER Glenn Y. Rolland <glenn.rolland@datatransition.net>
# vim: set ts=4 sw=4 et:

ARG BUNDLE_BITBUCKET__ORG
ENV APP_ENV=production
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y apt-transport-https lsb-release && \
    wget https://deb.nodesource.com/gpgkey/nodesource.gpg.key -O- \
        | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node_8.x jessie main' \
        > /etc/apt/sources.list.d/nodesource.list && \
    echo 'deb-src https://deb.nodesource.com/node_8.x jessie main' \
        >> /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y git hunspell hunspell-fr libffi-dev curl \
         locales unzip nodejs graphviz && \
    rm -fr /var/lib/apt/lists/*

# RUN mv /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf.real && \
#     echo '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf.real -q $*' > /usr/bin/wkhtmltopdf && \
#     chmod +x /usr/bin/wkhtmltopdf

# RUN wget https://github.com/hoedown/hoedown/archive/master.zip && \
#      unzip master.zip && \
#     cd hoedown-master && \
#     make && \
#     cd .. && \
#     rm -rf hoedown-master.zip hoedown-master && \
#     \
#     wget https://github.com/walle/mdpdf/releases/download/1.0.0/mdpdf-1.0.0.tar.gz && \
#     tar zxvf mdpdf-1.0.0.tar.gz && \
#     rm -rf mdpdf-1.0.0.zip && \
#     mv mdpdf-1.0.0 /usr/local/mdpdf && \
#     ln -s /usr/local/mdpdf/mdpdf /usr/local/bin/mdpdf

RUN mkdir -p /app && \
    useradd user --home-dir /app && \
    chown -v -R user:user /app

USER root
COPY . /app
RUN chown -v -R user:user /app

USER user
WORKDIR /app


EXPOSE 5000
CMD ./bin/setup && bundle exec foreman start
