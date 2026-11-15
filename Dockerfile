# syntax=docker/dockerfile:1.7
#
# Multi-stage build for the ancient-dynasties-api Go service.
# Final image is a distroless static base, only the binary inside.

# ---- build stage -----------------------------------------------------------
FROM golang:1.26-alpine AS build

WORKDIR /src

# Cache module downloads across source changes.
COPY go.mod go.sum ./
RUN go mod download

# Bring in the rest of the source.
COPY cmd ./cmd
COPY internal ./internal

# Static build so the binary runs on a distroless base with no libc.
# -s -w strips debug info and shrinks the binary.
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /out/api ./cmd/api

# ---- runtime stage ---------------------------------------------------------
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=build /out/api /api

EXPOSE 8080
USER nonroot:nonroot

ENTRYPOINT ["/api"]
