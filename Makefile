version := v1.0.2
commit := $(shell git rev-parse --short HEAD)
goos := $(shell go env GOHOSTOS)
goarch := $(shell go env GOHOSTARCH)
goversion := $(shell go version)
buildtime := $(shell date -u '+%Y-%m-%d %H:%M:%S')

build:
	go build -ldflags "-X="github.com/oleksandr-san/botfriend/cmd.appVersion=$(version)" -X="github.com/oleksandr-san/botfriend/cmd.appCommit=$(commit)""

clean:
	rm -f botfriend

rebuild:
	clean
	build

all:
	clean
	build