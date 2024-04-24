# Declare which targets(task) don't need to generate target-file.
.PHONY: help

##

help: ## Know all commands.
	@echo "Ready For Help..."

gen: ## Generate the *.g.dart
	dart run build_runner build

.PHONY: ffigen
ffigen:
	dart run ffigen --config ffigen.yaml

rm/debug:
	pwsh.exe -Command 'Remove-Item build/windows/x64/runner/Debug/http_server.dll'

cp/debug:
	pwsh.exe -Command 'Get-ChildItem -Path include/ -Filter "*.dll"  | Copy-Item -Destination build/windows/x64/runner/Debug -Force'

build/windows:
	flutter build windows && pwsh.exe -Command 'Get-ChildItem -Path include/ -Filter "*.dll"  | Copy-Item -Destination build/windows/x64/runner/Release -Force'

build/apk:
	flutter build apk