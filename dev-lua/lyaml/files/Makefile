all:
	$(LUA) build-aux/luke package=$(package) version=$(version) LUA_INCDIR="$(LUA_INCDIR)" LYAML_DIR="$(LYAML_DIR)"
doc:
	ldoc -c build-aux/config.ld.in .
