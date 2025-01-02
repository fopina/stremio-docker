IMAGE := ghcr.io/fopina/stremio-server
PATCH_VERSION := 0

serverjs:
	docker build -t $(IMAGE):serverjs --build-arg VERSION=$(shell make version) --target serverjs .
	docker run --rm --entrypoint '' $(IMAGE):serverjs cat server.js > server.js

test:
	docker build -t $(IMAGE):local --build-arg VERSION=$(shell make version) .
	docker run --rm -p 11470:11470 $(IMAGE):local

testup: serverjs
	docker run --rm -p 11470:11470 $(IMAGE):serverjs

version:
	@cat Dockerfile | grep ^FROM | grep 'stremio/server:' | cut -d ':' -f2 | cut -d ' ' -f1

pversion:
	@echo $(shell make version)-$(PATCH_VERSION)

image:
	@echo $(IMAGE)
