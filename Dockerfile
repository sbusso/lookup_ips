FROM golang:alpine AS build-env
MAINTAINER Stephane Busso <stephane.busso@gmail.com>
RUN apk update && apk add git && apk add ca-certificates
RUN adduser -D -g '' appuser
WORKDIR /src
COPY lookup_ips.go .
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o lookup_ips

FROM scratch
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build-env /etc/passwd /etc/passwd
WORKDIR /root/
COPY --from=build-env /src/lookup_ips .
USER appuser
EXPOSE 9000
CMD ["./lookup_ips"]