# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

# ==================================================================================== #
# PRODUCTION
# ==================================================================================== #

.PHONY: build dll
build/dll:
	go build -tags nosqlite -ldflags="-w -s" -buildmode=c-shared -o ui/flutter/include/http_server.dll github.com/crossevol/go_flutter_counter/bind/desktop

build/apk:
	gomobile bind -tags nosqlite -ldflags="-w -s" -o ui/flutter/android/app/libs/HttpServer.aar -target=android -androidapi 19 -javapkg="com.crossevol" github.com/crossevol/go_flutter_counter/bind/mobile

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## tidy: format code and tidy modfile
.PHONY: tidy
tidy:
	go fmt ./...
	go mod tidy -v

## audit: run quality control checks
.PHONY: audit
audit:
	go mod verify
	go vet ./...
	go run honnef.co/go/tools/cmd/staticcheck@latest -checks=all,-ST1000,-U1000 ./...
	go run golang.org/x/vuln/cmd/govulncheck@latest ./...
	go test -race -buildvcs -vet=off ./...


# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## test: run all tests
.PHONY: test
test:
	go test -v -race -buildvcs ./...

## test/cover: run all tests and display coverage
.PHONY: test/cover
test/cover:
	go test -v -race -buildvcs -coverprofile=/tmp/coverage.out ./...
	go tool cover -html=/tmp/coverage.out

## build: build the cmd/api application
.PHONY: build
build:
	go build -o=/tmp/bin/api ./cmd/api
	
## run: run the cmd/api application
.PHONY: run
run: build
	/tmp/bin/api

## run/live: run the application with reloading on file changes
.PHONY: run/live
run/live:
	go run github.com/cosmtrek/air@v1.43.0 \
		--build.cmd "make build" --build.bin "/tmp/bin/api" --build.delay "100" \
		--build.exclude_dir "" \
		--build.include_ext "go, tpl, tmpl, html, css, scss, js, ts, sql, jpeg, jpg, gif, png, bmp, svg, webp, ico" \
		--misc.clean_on_exit "true"


# ==================================================================================== #
# SQL MIGRATIONS
# ==================================================================================== #

## migrations/new name=$1: create a new database migration
.PHONY: migrations/new
migrations/new:
	go run -tags 'sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest create -seq -ext=.sql -dir=./assets/migrations ${name}

## migrations/up: apply all up database migrations
.PHONY: migrations/up
migrations/up:
	go run -tags 'sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest -path=./assets/migrations -database="sqlite3://db.sqlite" up

## migrations/down: apply all down database migrations
.PHONY: migrations/down
migrations/down:
	go run -tags 'sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest -path=./assets/migrations -database="sqlite3://db.sqlite" down

## migrations/goto version=$1: migrate to a specific version number
.PHONY: migrations/goto
migrations/goto:
	go run -tags 'sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest -path=./assets/migrations -database="sqlite3://db.sqlite" goto ${version}

## migrations/force version=$1: force database migration
.PHONY: migrations/force
migrations/force:
	go run -tags 'sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest -path=./assets/migrations -database="sqlite3://db.sqlite" force ${version}

## migrations/drop : Drop everything inside database
.PHONY: migrations/drop
migrations/drop:
	go run -tags 'sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest -path=./assets/migrations -database="sqlite3://db.sqlite" drop


## migrations/version: print the current in-use migration version
.PHONY: migrations/version
migrations/version:
	go run -tags 'sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest -path=./assets/migrations -database="sqlite3://db.sqlite" version

