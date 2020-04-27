.POSIX:
.PHONY: test dependencies build lint clean dist all-in-one

all-in-one:
	mix do deps.get, deps.compile, format, credo, compile

dist: clean dependencies lint build

clean:
	rm -rf _build deps

lint:
	# https://hexdocs.pm/dialyzex/readme.html
	# https://hexdocs.pm/credo/Credo.html
	# shows the debug info from dialyzer
	env MIX_DEBUG=1 mix do format, credo --strict, dialyzer

build:
	mix compile

dependencies:
	mix do deps.unlock --all, deps.update --all
	mix hex.outdated
	mix hex.docs fetch

test:
	mix test --trace --no-deps-check
