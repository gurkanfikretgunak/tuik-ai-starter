FROM golang:1.22 AS build
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /api ./cmd/api
FROM gcr.io/distroless/static
COPY --from=build /api /api
CMD ["/api"]
