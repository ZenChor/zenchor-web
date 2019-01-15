test:
	yarn install
	npx shadow-cljs compile ci-tests
	npx karma start --single-run
	lein do clean, test-refresh :run-once # clean is needed in case AOT stuff is around

shell:
	nix-shell

deps:
	yarn install
	lein install

watch-build:
	npx shadow-cljs server

repl:
	lein repl

.PHONY: test
