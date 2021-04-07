FROM golang:alpine as build

RUN apk add --no-cache git gcc musl-dev upx
RUN mkdir /app
COPY . /app/
RUN cd /app && go build -buildmode=pie "-asmflags=all='-trimpath=`pwd`'" -ldflags "-w -s -linkmode external -extldflags '-static' -X main.Version=`git describe --abbrev=0`" -o nvdaRemoteServer .
RUN upx /app/nvdaRemoteServer

FROM scratch

COPY --from=build /app/nvdaRemoteServer /nvdaRemoteServer

EXPOSE 6837
CMD ["/nvdaRemoteServer"]
