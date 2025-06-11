# Multi-stage Dockerfile for openstack-network-exporter Go app based on Alpine

# Build stage
FROM golang:1.22-alpine AS builder

RUN apk add --no-cache make git gcc musl-dev

WORKDIR /app

COPY . .

# Build the Go app binary with version info
RUN make

# Final stage
FROM alpine:latest

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/openstack-network-exporter .

COPY ./etc/openstack-network-exporter.yaml /etc/openstack-network-exporter.yaml

RUN chown appuser:appgroup openstack-network-exporter

USER root

EXPOSE 1981

ENTRYPOINT ["./openstack-network-exporter"]
