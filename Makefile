.PHONY: start
start:
	@GO111MODULE=off go run cmd/gws/main.go -port=8080 -path=/postreceive -command='echo "hello world"' -secret=mysecret

.PHONY: curl
curl:
	@curl "http://localhost:8080/postreceive" -H 'X-Hub-Signature: sha1=33f9d709782f62b8b4a0178586c65ab098a39fe2'

.PHONY: release
release:
	@rm -rf dist
	@goreleaser

.PHONY: test
test:
	@echo 'todo'

docker:
	docker run -p 3000:3000 hopprotocol/webhook-server

# Build docker target
docker-build:
	docker build -f Dockerfile -t hopprotocol/webhook-server .

# Tag docker image
docker-tag:
	$(eval REV=$(shell git rev-parse HEAD | cut -c1-7))
	docker tag hopprotocol/webhook-server:latest hopprotocol/webhook-server:latest
	docker tag hopprotocol/webhook-server:latest hopprotocol/webhook-server:$(REV)

# Push to registry
docker-push:
	$(eval REV=$(shell git rev-parse HEAD | cut -c1-7))
	docker push hopprotocol/webhook-server:latest
	docker push hopprotocol/webhook-server:$(REV)

# Build docker image and push to registry
docker-build-and-push: docker-build docker-tag docker-push
