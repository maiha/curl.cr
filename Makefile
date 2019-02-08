SHELL=/bin/bash

NATIVE_DIR        = .lib/x86_64-linux-gnu
STATIC_LINK_FLAGS := --link-flags "-static /v/$(NATIVE_DIR)/libcurl.a"

#STATIC_LINK_FLAGS = --link-flags "-static -lcurl -lssl"

.SHELLFLAGS = -o pipefail -c

export LC_ALL=C
export LD_LIBRARY_PATH=$(NATIVE_DIR)

all:
	shards build

static:
	docker-compose run --rm builder crystal build -o bin/curl samples/curl.cr ${STATIC_LINK_FLAGS} 2>&1

xxx:
	docker-compose run --rm builder bash -c 'cd samples && make > log 2>&1'

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
	diff -w -c <(grep version: README.md) <(grep ^version: shard.yml)

######################################################################
### auto versioning for development

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
