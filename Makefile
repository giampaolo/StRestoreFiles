PYTHON = python3
ARGS =

# Install
# =======

clean:  ## Remove all build files.
	@rm -rfv `find . \
		-type d -name __pycache__ \
		-o -type f -name \*.bak \
		-o -type f -name \*.orig \
		-o -type f -name \*.pyc \
		-o -type f -name \*.pyd \
		-o -type f -name \*.pyo \
		-o -type f -name \*.rej \
		-o -type f -name \*.so \
		-o -type f -name \*.~`
	@rm -rfv \
		*.core \
		*.egg-info \
		.coverage \
		.failed-tests.txt \
		.pytest_cache \
		.ruff_cache/ \
		build/ \
		dist/ \
		docs/_build/ \
		htmlcov/ \
		wheelhouse

# Linters
# =======

ruff:  ## Run ruff linter.
	@git ls-files '*.py' | xargs ruff check --output-format=concise
	@git ls-files '*.py' | xargs ruff format --check

dprint:
	dprint check --list-different

lint-all:  ## Run all linters
	${MAKE} ruff
	${MAKE} dprint

# Fixers
# ======

fix-ruff:
	@git ls-files '*.py' | xargs ruff check --fix --output-format=concise
	@git ls-files '*.py' | xargs ruff format

fix-dprint:
	@dprint fmt

fix-all:
	${MAKE} fix-ruff
	${MAKE} fix-dprint

# Tests
# =====

test:  ## Run tests
	$(PYTHON) -m pytest $(ARGS)

test-lastfailed:
	$(PYTHON) -m pytest --last-failed $(ARGS)

help: ## Display callable targets.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
