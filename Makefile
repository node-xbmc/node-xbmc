build:
	cake build

watch:
	cake watch

doc:
	cake doc

test: build
	npm test

release: test
	npm publish
