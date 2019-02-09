FROM crystallang/crystal:0.27.0
LABEL maintainer "maiha <maiha@wota.jp>"

# [to comile curl]
#   autoconf automake libtool
# [dependant libraries]
#   libcurl4-openssl-dev libidn2-0-dev libunistring-dev

RUN apt-get update -qq && apt-get install -y --no-install-recommends libcurl4-openssl-dev libidn2-0-dev libunistring-dev autoconf automake libtool
COPY build /usr/local/bin

CMD ["crystal", "--version"]
