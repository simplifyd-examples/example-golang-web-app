FROM golang:1.17 as builder

# Move to working directory /build
WORKDIR /build

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Copy and download dependency using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy the code into the container
COPY . .

# Build the application
RUN go build -o main .

FROM scratch as final

COPY --from=builder /build/main /go/bin/

ENTRYPOINT ["/go/bin/main"]

EXPOSE 9999
