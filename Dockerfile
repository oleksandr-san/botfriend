FROM quay.io/projectquay/golang:1.21 as builder

WORKDIR /go/src/app/
COPY . .
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/botfriend .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./botfriend" ]
