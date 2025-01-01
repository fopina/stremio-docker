IMAGE := ghcr.io/fopina/stremio-docker

serverjs:
	docker build -t $(IMAGE):serverjs -f Dockerfile.server.js .
	docker run --rm --entrypoint '' $(IMAGE):serverjs cat server.js > server.js

test:
	docker build -t $(IMAGE):local .
	docker run --rm -p 11470:11470 $(IMAGE):local
