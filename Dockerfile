FROM registry.access.redhat.com/ubi7/ubi:7.9-601

#base updates
RUN set -eux; \
    yum install -y \
    ant \
    asciidoc \
    bzip2-devel \
    curl wget \
    cyrus-sasl-devel \
    cyrus-sasl-gssapi \
    cyrus-sasl-plain \
    gcc \
    gcc-c++ \
    gettext \
    git \
    gmp-devel \
    java-1.8.0-openjdk-devel \
    krb5-devel \
    krb5-libs \
    krb5-workstation \
    libffi-devel \
    libtidy \
    libxml2-devel \
    libxslt-devel \
    make \
    maven \
    mysql-devel \
    nc \
    ncurses-devel \
    nmap-ncat \
    openldap-devel \
    openssl \
    openssl-devel \
    postgresql \
    postgresql-libs \
    python-devel \
    python-setuptools \
    readline-devel \
    sqlite-devel \
    sudo \
    swig \
    tar \
    which \
    xmlsec1 \
    xmlsec1-openssl \
    zlib-devel

#python pip and node
RUN set -eux; \
    curl -o get-pip.py https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python get-pip.py && \
    curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum update -y && \
    yum install -y nodejs && \
    npm i -g npm


#huehuehue install and user add
RUN set -eux; \
    wget https://github.com/cloudera/hue/archive/refs/tags/release-4.10.0.tar.gz && \
    tar -xf release-4.10.0.tar.gz && \
    mkdir /usr/share/hue && \
    chown 777 -R /usr/share/hue && \
    cd hue-release-4.10.0 && \
    PREFIX=/usr/share make install && \
    rm -rf /usr/share/hue/desktop/conf && \
    useradd -ms /bin/bash hue && chown -R hue /usr/share/hue

WORKDIR /usr/share/hue

# huehuehue extra # Install DB connectors
RUN set -eux; \
    ./build/env/bin/pip install \
    supervisor \
    psycopg2-binary \
    redis==2.10.6 \
    django_redis \
    # flower \
    # SparkSql show tables
    git+https://github.com/gethue/PyHive \
    # pyhive \
    ksql \
    pydruid \
    pybigquery \
    elasticsearch-dbapi==0.2.3 \
    pyasn1==0.4.1 \
    # View some parquet files
    # python-snappy==0.5.4 \
    gevent \
    # Needed for Jaeger
    threadloop \
    thrift-sasl==0.2.1

COPY entrypoint.sh .

EXPOSE 8888

CMD ["./entrypont.sh"]