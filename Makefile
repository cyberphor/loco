# ---------------------------------------------------------
# Default Target
# ---------------------------------------------------------

# Set the default goal.
.DEFAULT_GOAL := build

# Set the app name.
APP_NAME := loco
APP_VERSION := v0.1.0

# ---------------------------------------------------------
# QA
# ---------------------------------------------------------

.PHONY: qa/format qa/lint qa
.SILENT: qa/format qa/lint qa

# Execute formatter.
qa/format: 
	@echo "[*] Executing formatter on $(APP_NAME) source code..."
	go fmt ./...

# Execute linter.
qa/lint: 
	@echo "[*] Executing linter on $(APP_NAME) source code..."
	golangci-lint run --fix

# Execute all quality assurance tools.
qa: qa/format qa/lint

# ---------------------------------------------------------
# Test
# ---------------------------------------------------------

.PHONY: test 
.SILENT: test 

# Execute unit tests with test coverage.
test: 
	@echo "[*] Testing $(APP_NAME) with coverage report..."
	go test -p 1 -v -cover -coverprofile=coverage.out ./...

# ---------------------------------------------------------
# Build
# ---------------------------------------------------------

.PHONY: build
.SILENT: build

build: qa test
	@echo "[*] Building $(APP_NAME)..."
	go build -ldflags="-s -w" -o $(APP_NAME) main.go
