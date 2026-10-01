# Adder

A small compiler written in Rust that turns Adder programs into x86-64 assembly.
Adder supports 32-bit integers and three operations: `add1`, `sub1`, and `negate`.

## Language

```
<expr> :=
  | <number>
  | (add1 <expr>)
  | (sub1 <expr>)
  | (negate <expr>)
```

| Program               | Result |
|-----------------------|--------|
| `4`                   | `4`    |
| `(add1 (sub1 5))`     | `5`    |
| `(negate (add1 3))`   | `-4`   |

## Requirements

- [Rust and Cargo](https://www.rust-lang.org/tools/install)
- [NASM](https://www.nasm.us/)
- An x86-64 Linux environment (or WSL on Windows)

On macOS, change `-f elf64` to `-f macho64` in the `Makefile`. On Apple Silicon,
also run `rustup target install x86_64-apple-darwin` and pass
`--target=x86_64-apple-darwin` to `rustc`.

## Usage

Compile and run a program in one step:

```
$ cat test/example3.snek
(negate (add1 3))
$ make test/example3.run
$ ./test/example3.run
-4
```

Run the full test suite:

```
$ ./run_tests.sh
```

## How it works

1. `src/main.rs` parses the `.snek` file into an s-expression (using the `sexp` crate).
2. It converts that into an `Expr` AST, then generates assembly that leaves the result in `rax`.
3. `nasm` assembles the output, `ar` packages it into a library, and `rustc` links it with
   `runtime/start.rs`, which calls `our_code_starts_here` and prints the result.

## Project layout

```
src/main.rs      parser and code generator
runtime/start.rs Rust runner that calls the generated code
test/            *.snek programs and *.expected outputs
Makefile         compile, assemble and link rules
run_tests.sh     runs every test and compares output
```

## Known limitations

Invalid syntax or numbers outside the `i32` range cause a panic rather than a friendly error.
