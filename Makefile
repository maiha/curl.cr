SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c

export LC_ALL=C
export UID = $(shell id -u)
export GID = $(shell id -g)

.PHONY : crurl

all: build

build:
	shards build

libcurl.a:
	docker-compose run --rm static

rebuild-docker:
	docker-compose build --no-cache static

static: libcurl.a
	docker-compose run --rm static shards build --link-flags "-static /v/libcurl.a" 2>&1
	LC_ALL=C file bin/crurl | grep 'statically'

src/curl/const.cr: gen/lib_curl_const.h
	@touch $@
	@echo "## Automatically generated from $^" >> $@
	@echo "module Curl::Const" >> $@
	@cat $^ | grep -v '^# ' | sed -e 's|/\*|#|' -e 's|\*/$$||' -e 's/^#define \s*\([A-Z0-9_][A-Z0-9_]*\s*\)\(.*\)/\1= \2/' -e 's/^/  /' -e 's/(unsigned long)//' >> $@
	@echo "end" >> $@

.PHONY : test
test: check_version_mismatch spec

.PHONY : spec
spec:
	crystal spec -v --fail-fast

.PHONY : check_version_mismatch
check_version_mismatch: shard.yml README.md
	diff -w -c <(grep '    version:' README.md) <(grep ^version: shard.yml)

######################################################################
### commit versions for shard owner

VERSION=
CURRENT_VERSION=$(shell git tag -l | sort -V | tail -1)
GUESSED_VERSION=$(shell git tag -l | sort -V | tail -1 | awk 'BEGIN { FS="." } { $$3++; } { printf "%d.%d.%d", $$1, $$2, $$3 }')

.PHONY : version
version:
	@if [ "$(VERSION)" = "" ]; then \
	  echo "ERROR: specify VERSION as bellow. (current: $(CURRENT_VERSION))";\
	  echo "  make version VERSION=$(GUESSED_VERSION)";\
	else \
	  sed -i -e 's/^version: .*/version: $(VERSION)/' shard.yml ;\
	  sed -i -e 's/^    version: [0-9]\+\.[0-9]\+\.[0-9]\+/    version: $(VERSION)/' README.md ;\
	  echo git commit -a -m "'$(COMMIT_MESSAGE)'" ;\
	  git commit -a -m 'version: $(VERSION)' ;\
	  git tag "v$(VERSION)" ;\
	fi

.PHONY : bump
bump:
	make version VERSION=$(GUESSED_VERSION) -s
