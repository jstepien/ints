# ints

Real¹ integers for JavaScript.
Unbounded, exact and trustworthy.

[Grab a release.][rel]
[Follow me on Twitter.][t]
[Have your mind blown.][ps]

[rel]: https://github.com/jstepien/ints/releases
[t]: https://twitter.com/janstepien

## Interface

The whole interface is exposed through the `ints` object.
All functions expect their arguments to be ints unless stated otherwise.

### `ints.add(a, b)`

Returns a sum of `a` and `b`.

### `ints.sub(a, b)`

Returns a difference of `a` and `b`.

### `ints.mul(a, b)`

Returns a product of `a` and `b`.

### `ints.eq(a, b)`

Returns `true` if `a` is equal to `b` and `false` otherwise.

### `ints.lt(a, b)`

Returns `true` if `a` is lesser than `b` and `false` otherwise.

### `ints.zero`

Constant `0`.

### `ints.one`

Constant `1`.

### `ints.parse(str)`

Returns an int by parsing string `str`.
The argument has to be expressed in base 2, e.g. `"1101"`.

### `ints.format(int)`

Returns a string with the given int represented in base 2.
The returned value can be `parseInt`ed into a JavaScript number.

### `ints.unsafeToInt(num)`

Returns an int approximately representing the given JavaScript number.

### `ints.unsafeToNumber(int)`

Returns a JavaScript number approximating the given int.

## Building

Install [Purescript][ps].
Make sure that [Closure Compiler][cc]'s `compiler.jar` is available in `$PWD`.
Then execute

    git submodule init
    git submodule update
    make

Run tests by opening `test.html` in a web browser.

[cc]: https://github.com/google/closure-compiler
[ps]: https://github.com/purescript/purescript

## Coming soon!

  - Comparison operators,
  - Division.

## License

    Copyright (c) 2014 Jan Stępień

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without
    restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or
    sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

---

¹ That is _genuine_; not as the set containing _π_.
