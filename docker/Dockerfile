FROM crystallang/crystal:0.27.0
LABEL maintainer "maiha <maiha@wota.jp>"

# Static library dependencies are fragile, so specify the version exactly.
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  libcurl4-openssl-dev=7.47.0-1ubuntu2.12 \
  libidn2-0-dev=0.10-3 \
  libunistring-dev=0.9.3-5.2ubuntu1 \
  autoconf \
  automake \
  libtool

COPY build /usr/local/bin

CMD ["crystal", "--version"]
