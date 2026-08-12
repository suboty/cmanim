.DEFAULT_GOAL := help

MANIM_BASE=TTY_COMPATIBLE=0 COLUMNS=240 poetry run manim

install:
	poetry add manim=="0.19.0"
	poetry install --no-root

run-test:
	PYTHONPATH=$(shell pwd)/src $(MANIM_BASE) \
		--disable_caching -pqh tests/test.py TestScene
	rm -r media

run-test-gif:
	# FULL_HD
	PYTHONPATH=$(shell pwd)/src $(MANIM_BASE) \
		--disable_caching -qh --format=gif \
		--output_file TestScene.gif --fps=10 tests/test.py TestScene
	mkdir -p docs
	mv media/videos/test/1080p10/TestScene.gif docs/TestScene.gif
	# SHORTS
	rm -r media
	PYTHONPATH=$(shell pwd)/src $(MANIM_BASE) \
		--disable_caching -qh --format=gif \
		--output_file TestSceneShorts.gif --fps=10 tests/test.py TestSceneShorts
	mkdir -p docs
	mv media/videos/test/1920p10/TestSceneShorts.gif docs/TestSceneShorts.gif
	rm -r media

build:
	poetry build
	poetry install

publish:
	poetry publish

release: build publish

clean:
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/
	rm -rf .ruff_cache/
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true

check:
	poetry check

help:
	@echo "Available commands:"
	@echo ""
	@echo "  make install 		- Install project dependencies (manim and required packages)"
	@echo "  make run-test		- Run test scene in preview mode (720p, low quality)"
	@echo "  make run-test-gif	- Generate GIF animations from test scenes (Full HD + Shorts) to docs/"
	@echo "  make build			- Build the library distribution (wheel + source)"
	@echo "  make publish		- Publish the library to PyPI (requires login)"
	@echo "  make release		- Build and publish the library in one command (build + publish)"
	@echo "  make clean			- Remove temporary files, caches, and build artifacts"
	@echo "  make check			- Validate pyproject.toml and dependencies"
	@echo "  make help			- Show this help message"
	@echo ""