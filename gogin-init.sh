#!/bin/bash

set -e

# Project name and module path
PROJECT_NAME="propagations-api"
MODULE_PATH="github.com/yourname/${PROJECT_NAME}"

echo "Creating project: $PROJECT_NAME"

# Create root directory
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Initialize go module
go mod init $MODULE_PATH

# Create folders
mkdir -p cmd/server
mkdir -p internal/{handlers,routes,config}

# Create main.go
cat > cmd/server/main.go <<EOF
package main

import (
	"github.com/gin-gonic/gin"
	"${MODULE_PATH}/internal/routes"
	"${MODULE_PATH}/internal/config"
)

func main() {
	cfg := config.LoadConfig()

	r := gin.Default()
	routes.RegisterRoutes(r)
	r.Run(":" + cfg.Port)
}
EOF

# Create router.go
cat > internal/routes/router.go <<EOF
package routes

import (
	"github.com/gin-gonic/gin"
	"${MODULE_PATH}/internal/handlers"
)

func RegisterRoutes(r *gin.Engine) {
	r.GET("/ping", handlers.Ping)
}
EOF

# Create ping.go handler
cat > internal/handlers/ping.go <<EOF
package handlers

import (
	"net/http"
	"github.com/gin-gonic/gin"
)

func Ping(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "pong",
	})
}
EOF

# Create config.go
cat > internal/config/config.go <<EOF
package config

import (
	"log"
	"os"
)

type Config struct {
	Port string
}

func LoadConfig() Config {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	return Config{
		Port: port,
	}
}
EOF

# Create Dockerfile
cat > Dockerfile <<EOF
# ---------- Stage 1: Builder ----------
FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /app/bin/app ./cmd/server

# ---------- Stage 2: Runtime ----------
FROM alpine:3.20

RUN apk --no-cache add ca-certificates
RUN adduser -D -g '' appuser

WORKDIR /app
COPY --from=builder /app/bin/app .
USER appuser

EXPOSE 8080
ENTRYPOINT ["./app"]
EOF

# Create docker-compose.yml
cat > docker-compose.yml <<EOF
version: "3.8"

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: builder
    volumes:
      - .:/app
    ports:
      - "8080:8080"
    command: >
      sh -c "go install github.com/cosmtrek/air@latest &&
             air"
    environment:
      - AIR_ENV=dev
EOF

# Create air.toml
cat > air.toml <<EOF
root = "."
tmp_dir = "tmp"

[build]
  cmd = "go build -o ./tmp/main ./cmd/server"
  bin = "tmp/main"
  delay = 200
  include_ext = ["go"]
  exclude_dir = ["tmp", "vendor"]
  log = "stdout"
  send_interrupt = true

[log]
  time = true
EOF

# Create .gitignore
cat > .gitignore <<EOF
bin/
tmp/
*.log
vendor/
EOF

# Download any missing deps
go mod tidy

# Create .gitignore
cat > .gitignore <<EOF
# Binaries
bin/
tmp/
*.exe
*.dll
*.so
*.dylib

# Output of build tools
*.out

# Vendor dependencies
vendor/

# Logs
*.log

# IDE/editor files
.vscode/
.idea/
*.swp

# Go test cache
*.test

# OS files
.DS_Store
Thumbs.db
EOF

# Create .gitattributes
cat > .gitattributes <<EOF
# Normalize text files to LF on all OS
* text=auto eol=lf

# Go source files
*.go text

# Shell scripts
*.sh text eol=lf

# YAML, TOML, JSON configs
*.yml text
*.yaml text
*.toml text
*.json text

# Docker and ignore files
Dockerfile text
.dockerignore text
.gitignore text
.gitattributes text
EOF


echo "✅ Project scaffolded successfully in ./$PROJECT_NAME"

