.PHONY: default fmt clean checks test build

export GO111MODULE=on

GOFILES := $(shell git ls-files '*.go' | grep -v '^vendor/')

TAG_NAME := $(shell git tag -l --contains HEAD)
SHA := $(shell git rev-parse --short HEAD)
VERSION := $(if $(TAG_NAME),$(TAG_NAME),$(SHA))
BUILD_DATE := $(shell date -u '+%Y-%m-%d_%I:%M:%S%p')

default: clean checks test build

test: clean
	go test -v -cover ./...

clean:
	rm -f cover.out

build: clean
	@echo Version: $(VERSION) $(BUILD_DATE)
	go build -v -ldflags '-X "main.version=${VERSION}" -X "main.commit=${SHA}" -X "main.date=${BUILD_DATE}"'

checks:
	golangci-lint run

fmt:
	@gofmt -s -l -w $(GOFILES)
