MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
ifeq ($(word 1,$(subst ., ,$(MAKE_VERSION))),4)
.SHELLFLAGS := -eu -o pipefail -c
endif
.DEFAULT_GOAL := zip
.ONESHELL:

TAG := $(shell grep version info.plist -A1 | tail -1  | grep -oP '[\d\.]*')
MINOR_NEXT := $(subst v,,$(lastword $(shell semver -n)))
PATCH_NEXT := $(subst v,,$(lastword $(shell semver -n)))

zip:
	git archive  --format zip HEAD > alfred-qrencode.alfredworkflow

validate:
	xmllint info.plist

patch:
	sed -i "" 's/$(TAG)/$(PATCH_NEXT)/' info.plist
	git add info.plist
	git commit -m 'Bumped version to $(PATCH_NEXT)'
	semver -p

minor:
	sed -i "" 's/$(TAG)/$(MINOR_NEXT)/' info.plist
	git add info.plist
	git commit -m 'Bumped version to $(MINOR_NEXT)'
	semver -m

.PHONY: help
help: ## Show this help.
	@grep '.*:.*##' Makefile | grep -v grep  | sort | sed 's/:.* ##/:/g' | column -t -s:
