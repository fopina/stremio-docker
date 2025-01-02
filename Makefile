IMAGE := ghcr.io/fopina/stremio-docker
PATCH_VERSION := 0

serverjs:
	docker build -t $(IMAGE):serverjs -f Dockerfile.server.js .
	docker run --rm --entrypoint '' $(IMAGE):serverjs cat server.js > server.js

test:
	docker build -t $(IMAGE):local .
	docker run --rm -p 11470:11470 $(IMAGE):local

testup: serverjs
	docker run --rm -p 11470:11470 $(IMAGE):serverjs

version:
	@cat Dockerfile.server.js | grep ^FROM | cut -d ':' -f2

pversion:
	@echo $(shell make version)-$(PATCH_VERSION)