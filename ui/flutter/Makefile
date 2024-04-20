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