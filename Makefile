MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
ifeq ($(word 1,$(subst ., ,$(MAKE_VERSION))),4)
.SHELLFLAGS := -eu -o pipefail -c
endif
.DEFAULT_GOAL := zip
.ONESHELL:

TAG := $(shell grep version info.plist -A1 | tail -1  | grep -oP '[\d\.]*')
MINOR_NEXT := $(subst v,,$(lastword $(shell semver -n)))

zip:
	git archive  --format zip HEAD > qrencode.alfredworkflow

validate:
	xmllint info.plist

minor:
	sed -i "" 's/$(TAG)/$(MINOR_NEXT)/' info.plist

.PHONY: help
help: ## Show this help.
	@grep '.*:.*##' Makefile | grep -v grep  | sort | sed 's/:.* ##/:/g' | column -t -s:
