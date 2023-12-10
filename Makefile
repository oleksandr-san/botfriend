APP := botfriend
REGISTRY := gcr.io/mlkube
VERSION := $(shell git describe --tags --always --abbrev=0)
COMMIT := $(shell git rev-parse --short HEAD)
# goos := $(shell go env GOHOSTOS)
# goarch := $(shell go env GOHOSTARCH)
TARGETOS=linux
TARGETARCH=amd64

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

build-linux-amd64:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o botfriend -ldflags "-X="github.com/oleksandr-san/botfriend/cmd.appVersion=${VERSION}" -X="github.com/oleksandr-san/botfriend/cmd.appCommit=${COMMIT}

build-linux-arm:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -v -o botfriend -ldflags "-X="github.com/oleksandr-san/botfriend/cmd.appVersion=${VERSION}" -X="github.com/oleksandr-san/botfriend/cmd.appCommit=${COMMIT}

build-linux-arm64:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o botfriend -ldflags "-X="github.com/oleksandr-san/botfriend/cmd.appVersion=${VERSION}" -X="github.com/oleksandr-san/botfriend/cmd.appCommit=${COMMIT}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}  --build-arg TARGETARCH=${TARGETARCH}

push-image:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -f botfriend
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${COMMIT}-${TARGETARCH}

rebuild:
	clean
	build

all:
	clean
	build