FROM --platform=$BUILDPLATFORM golang:1.15.8 as builder

RUN apt-get update && apt-get install ca-certificates

WORKDIR /src

ARG TARGETOS
ARG TARGETARCH
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM, target OS and arch is $TARGETOS/$TARGETARCH"

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# User numeric user so that kubernetes can assert that the user id isn't root (0).
# We are also using the root group (the 0 in 1000:0), it doesn't have any
# privileges, as opposed to the root user.
USER 1000:0
