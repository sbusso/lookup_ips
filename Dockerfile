FROM golang:1.10.3 AS build-env
MAINTAINER Stephane Busso <stephane.busso@gmail.com>
WORKDIR /src
COPY lookup_ips.go .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o lookup_ips

FROM scratch
WORKDIR /root/
COPY --from=build-env /src/lookup_ips .
EXPOSE 9000
CMD ["./lookup_ips"]