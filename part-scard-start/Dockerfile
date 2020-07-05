# part-scard-start
FROM golang:latest AS Go-build

WORKDIR /go/src/scard-server
COPY main.go .
RUN go install -v .

RUN mkdir -p /copydir/usr/local/bin/
RUN cp /go/bin/scard-server /copydir/usr/local/bin/

# dockerhubでビルド後必要な部分のみ利用出来るようにする
FROM scratch

COPY --from=Go-build /copydir /copydir
