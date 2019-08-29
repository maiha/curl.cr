SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c

export LC_ALL=C
export UID = $(shell id -u)
export GID = $(shell id -g)
export CURL_VERSION = 7_65_3

.PHONY : crurl

all: build

build:
	shards build

.PHONY : spec
spec:
	crystal spec -v --fail-fast

dynamic-crurl:
	crystal build samples/crurl.cr

######################################################################
### static build

libcurl.a:
	docker-compose run --rm static
	sha256sum libcurl.a

rebuild-docker:
	docker-compose build --no-cache static

static: libcurl.a
	docker-compose run --rm static shards build --link-flags "-static /v/libcurl.a" 2>&1
	LC_ALL=C file bin/crurl | grep 'statically'

######################################################################
### generate

.PHONY : symbols
symbols:
	@crystal gen/symbols.cr

.PHONY : const
const:
	@crystal gen/const.cr
	@crystal gen/doc.cr doc/const > doc/const.md

.PHONY : easy
easy:
	@crystal gen/easy.cr
	@crystal gen/doc.cr doc/easy > doc/easy.md

.PHONY : multi
multi:
	@crystal gen/multi.cr
	@crystal gen/doc.cr doc/multi > doc/multi.md

.PHONY : gen
gen: symbols const easy multi

######################################################################
### CI

.PHONY : ci
ci: check_version_mismatch const easy spec static

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
