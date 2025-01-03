IMAGE := ghcr.io/fopina/stremio-server
PATCH_VERSION := 0

serverjs:
	docker build -t $(IMAGE):serverjs --build-arg VERSION=$(shell make version) --target patched_serverjs .
	docker run --rm --entrypoint '' $(IMAGE):serverjs cat server.js > server.js

serverjs:
	docker build -t $(IMAGE):serverjs --build-arg VERSION=$(shell make version) --target serverjs .
	docker run --rm --entrypoint '' $(IMAGE):serverjs cat server.js > server.clean.js

test:
	docker build -t $(IMAGE):local --build-arg VERSION=$(shell make version) .
	docker run --rm -p 11470:11470 $(IMAGE):local

testup:
	docker build -t $(IMAGE):testup --target notused .
	docker run --rm -p 11470:11470 $(IMAGE):testup

version:
	@cat Dockerfile | grep ^FROM | grep 'stremio/server:' | cut -d ':' -f2 | cut -d ' ' -f1

pversion:
	@echo $(shell make version)-$(PATCH_VERSION)

image:
	@echo $(IMAGE)
