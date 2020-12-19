.PHONY: all api http

all: api http

api:
	./gen.sh api

http:
	./gen.sh http

