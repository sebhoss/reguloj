MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

TIMESTAMPED_VERSION := $(shell /bin/date "+%Y.%m.%d-%H%M%S")
CURRENT_DATE := $(shell /bin/date "+%Y-%m-%d")
USERNAME := $(shell id -u -n)
USERID := $(shell id -u)
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'targets'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

.PHONY: all
all: help

.PHONY: help
help: ##@other Show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

.PHONY: install
install: ##@hacking Install all artifacts into local repository
	mvn clean install

.PHONY: verify
verify: ##@hacking Verify all modules
	mvn verify

.PHONY: site
site: ##@hacking Build website
	hugo --minify --i18n-warnings --path-warnings --source docs

.PHONY: site-serve
site-serve: ##@hacking Build and watch website
	hugo server --minify --i18n-warnings --path-warnings --source docs --watch

.PHONY: build-env
build-env: ##@hacking Open a new shell in a predefined build environment
	ilo @build/shell

.PHONY: build-once
build-once: ##@hacking Build the entire project once in a predefined build environment
	ilo @build/once

.PHONY: sign-waiver
sign-waiver: ##@contributing Sign the WAIVER
	minisign -Sm AUTHORS/WAIVER
	mv AUTHORS/WAIVER.minisig AUTHORS/WAIVER.${USERNAME}.minisig
	git add AUTHORS/WAIVER.${USERNAME}.minisign
	git commit -m 'sign waiver' --gpg-sign
