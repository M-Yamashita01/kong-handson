FROM golang:1.16-alpine

WORKDIR /opt/user-api

COPY . .

RUN go build -o app main.go

CMD ["/opt/user-api/app"]