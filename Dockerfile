FROM golang:alpine as build

RUN apk add --no-cache git gcc musl-dev upx
RUN mkdir /app
COPY . /app/
RUN cd /app && go build -buildmode=pie "-asmflags=all='-trimpath=`pwd`'" -ldflags "-w -s -linkmode external -extldflags '-static' -X main.Version=$(git describe --tags `git rev-list --tags --max-count=1`)" -o nvdaRemoteServer .
RUN upx /app/nvdaRemoteServer

FROM scratch

COPY --from=build /app/nvdaRemoteServer /nvdaRemoteServer
COPY --from=build /app/cert.pem /cert.pem

EXPOSE 6837
CMD ["/nvdaRemoteServer", "-cert", "/cert.pem", "-key", "/cert.pem"]
