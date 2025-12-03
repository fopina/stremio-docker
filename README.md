# stremio-docker

This is (yet another) image of stremio server. Why?
* [Stremio/server-docker](https://github.com/Stremio/server-docker) builds a huge image
* `server.js` is not opensource yet some patches can be useful (not very clear how to request changes nor how to contribute them)

Alpine-based dockerfile based off [tsaridas/stremio-docker](https://github.com/tsaridas/stremio-docker)


## Patches

All patches to `server.js` applied are in [patches](patches), each created with (always using vanilla as comparison):
```
diff -u server.clean.js server.js
```

1. https://github.com/fopina/stremio-docker/pull/6 to solve https://github.com/Stremio/stremio-bugs/issues/1975

