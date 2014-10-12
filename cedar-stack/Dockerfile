FROM ubuntu:10.04

ENV DEBIAN_FRONTEND noninteractive

# Initialize cedar stack
ADD ./cedar.sh /tmp/cedar.sh
RUN \
  /bin/bash /tmp/cedar.sh

RUN \
  apt-get upgrade -y

ADD ./postgresql.tar.gz /tmp
RUN \
  mkdir -p /app/vendor && \
  cd /tmp/postgresql-* && \
  ./configure --prefix=/app/vendor/pgsql --with-openssl

RUN \
  cd /tmp/postgresql-* && \
  make -C src/bin install-strip && \
  cp src/backend/utils/fmgroids.h src/include/utils/fmgroids.h && \
  make -C src/include install-strip && \
  make -C src/interfaces install-strip

RUN \
  cd /app/vendor/pgsql && \
  tar zcf /tmp/pgsql-cedar-stack.tar.gz .
