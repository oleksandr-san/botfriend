FROM quay.io/projectquay/golang:1.21 as builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /go/src/app/
COPY . .
RUN make build TARGETARCH=${TARGETARCH} TARGETOS=${TARGETOS}

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/botfriend .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./botfriend", "bot" ]
