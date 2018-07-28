# krho
WIP formal executable semantics of Rholang.

TODO:
- [ ] Tests
- [ ] Basic Parsing
- [ ] Pandoc version
- [ ] Primitives
- [ ] Matching logic
- [ ] Communication
- [ ] Crypto primives
- [ ] Complexity Metering

## Requirements:
[K5](https://github.com/kframework/k)

Kompile rholang definitions with
```sh
kompile rho.k --backend java
```
Needs proper testing process, right now just
```sh
krun tests/HelloWorld.rho
```
