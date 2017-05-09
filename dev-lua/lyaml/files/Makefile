all:
	$(LUA) build-aux/luke package=$(package) version=$(version) LUA_INCDIR="$(LUA_INCDIR)"
doc:
	ldoc -c build-aux/config.ld.in .
