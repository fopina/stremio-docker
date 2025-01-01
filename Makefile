serverjs:
	docker build -t x -f Dockerfile.server.js .
	docker run --rm --entrypoint '' x cat server.js > server.js
