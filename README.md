# greninja

Tiny utility to generate `.ninja` build files programmatically.

## why

* learning ninja fundamentals
* avoid writing raw Ninja syntax
* generate builds using code

---

## example

```d
import greninja.writer;

void main() {
    auto w = new Writer("build.ninja");

    w.rule("cc", "g++ -c $in -o $out");
    w.rule("link", "g++ $in -o $out");

    w.build("main.o", "cc", "main.cpp");
    w.build("util.o", "cc", "util.cpp");

    w.build("app", "link", ["main.o", "util.o"]);

    w.default(["app"]);

    w.close();
}
```

Generated:

```ninja
rule cc
  command = g++ -c $in -o $out

rule link
  command = g++ $in -o $out

build main.o: cc main.cpp
build util.o: cc util.cpp

build app: link main.o util.o

default app
```

---

## run

```bash
dub run
ninja
```

---

## features

* rule generation
* build graph (`|` implicit, `||` order-only)
* path escaping
* supports string or string[] inputs
* simple and minimal API

---

## example project

```
example/
 ├── build.d
 ├── dub.sdl
 ├── main.cpp
 └── util.cpp
```

run:

```bash
cd example
dub run
ninja
```
