FROM crystallang/crystal:0.27.0

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev
RUN apt-get install -y --no-install-recommends libidn2-0-dev librtmp-dev

# unistring
RUN apt-get install -y --no-install-recommends libunistring-dev

# to compile libcurl
RUN apt-get install -y --no-install-recommends autoconf automake libtool



CMD ["crystal", "--version"]

