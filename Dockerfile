FROM golang:latest as builder
COPY ./cmd /hello/cmd
COPY ./go.mod /hello/
COPY ./go.sum /hello/
WORKDIR /hello/
ENV GOPROXY="https://goproxy.cn"
ENV CGO_ENABLED=0
RUN go mod tidy && go mod verify
RUN go build -o /build/hello ./cmd/main.go

FROM alpine:latest
WORKDIR /
LABEL version="1.00" name="hello"
COPY --from=builder /build/hello /usr/bin/hello
EXPOSE 8080
ENTRYPOINT ["hello"]

