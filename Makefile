version := $(shell git describe --tags --always --dirty --abbrev=0)
commit := $(shell git rev-parse --short HEAD)
goos := $(shell go env GOHOSTOS)
goarch := $(shell go env GOHOSTARCH)
goversion := $(shell go version)
buildtime := $(shell date -u '+%Y-%m-%d %H:%M:%S')

format:
	gofmt -w -s .

lint:
	golangci-lint run

test:
	go test -v

build: format
	CGO_ENABLED=0 GOOS=${goos} GOARCH=${goarch} go build -v -o botfriend -ldflags "-X="github.com/oleksandr-san/botfriend/cmd.appVersion=$(version)" -X="github.com/oleksandr-san/botfriend/cmd.appCommit=$(commit)""

clean:
	rm -f botfriend

rebuild:
	clean
	build

all:
	clean
	build