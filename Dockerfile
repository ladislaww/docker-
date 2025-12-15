FROM golang:1.24-alpine 
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download 

COPY *.go ./
COPY tracker.db ./


RUN apk add --no-cache sqlite \
 && sqlite3 tracker.db "CREATE TABLE IF NOT EXISTS parcel (number INTEGER PRIMARY KEY AUTOINCREMENT, client INTEGER, status TEXT, address TEXT, created_at TEXT);"

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app
CMD ["./app"]