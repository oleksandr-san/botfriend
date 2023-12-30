APP := botfriend
REGISTRY := gcr.io/mlkube
VERSION := $(shell git describe --tags --always --abbrev=0)
COMMIT := $(shell git rev-parse --short HEAD)
# goos := $(shell go env GOHOSTOS)
# goarch := $(shell go env GOHOSTARCH)
TARGETOS=linux
TARGETARCH=amd64
TAG := ${VERSION}-${COMMIT}-${TARGETOS}-${TARGETARCH}

get:
	go get

format:
	gofmt -w -s .

lint:
	golangci-lint run

test:
	go test -v

build: get format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o botfriend -ldflags "-X="github.com/oleksandr-san/botfriend/cmd.appVersion=${VERSION}" -X="github.com/oleksandr-san/botfriend/cmd.appCommit=${COMMIT}""

image:
	docker build . -t ${REGISTRY}/${APP}:${TAG}  --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push-image:
	docker push ${REGISTRY}/${APP}:${TAG}

clean:
	rm -f botfriend
	docker rmi ${REGISTRY}/${APP}:${TAG}

rebuild:
	clean
	build

all:
	clean
	build