# TOFIX

Findings from a code scan on 2026-10-04.

## High

- `src/exercises/find_largest_element/solution.asm:13`, `:21`, `:24` - the array is `dd` (32-bit) but it is read with 64-bit `mov rax, [rdi]` / `cmp [rdi], rax`, and the loop runs `rcx = 5` times starting from the second element (`:14-15`), so it also reads past the array end; assembled and run, it prints `84490542446` instead of `15`. Use `movsxd rax, dword [rdi]` / `cmp dword [rdi], eax` and start `rcx` at 4. In addition the digits are written to the buffer least-significant first and printed in that order (`:37-52`, the comment at `:47` claims a reverse that never happens), so even a correct maximum like `15` prints as `51`; fill the buffer from the end instead.
- `src/examples/cat_sendfile.asm:28` - after `sendfile` succeeds the program executes `jmp $`, an infinite loop, instead of falling through to `exit`; running it on a file prints the content and then hangs forever. Replace `jmp $` with `jmp end` (and set `r8` to 0 for a clean exit code).
- `tera.snippets/main.md.tera:9-12` (rendered into `README.md:27-32`) - the run instructions say `make` and `./src/hello_world.elf`, but the Makefile is gone and the generator writes binaries under `out/` (`rsconstruct.toml:58-64`). Change to `rsconstruct build` and the real output path.

## Medium

- `src/exercises/find_largest_element/exercise.md` - the file is empty (0 bytes); write the exercise statement as `src/exercises/factorial/exercise.md` does.
- `src/exercises/find_largest_element/solution_old.asm` - a superseded copy of the solution; it is built by the generator and counted as an extra exercise in the README (`README.md:25` says 3 exercises, there are 2). Delete it.
- `src/examples/ping.asm:84-101` - when the reply is good the code prints "good" and then falls through into `failure:` and also prints "bad", and both paths end in `jmp $` (`:101`), an infinite loop, so `exit` at `:104-108` is unreachable (and would use an uninitialized `r8`). Add `jmp end` after the "good" write, replace `jmp $` with a jump to the exit, and set `rdi` explicitly.
- `src/examples/pwd.asm:17-21` - writes a fixed 256 bytes, so the output is the path followed by NUL padding and no newline. The `getcwd` syscall returns the length (including the NUL) in `rax`; write `rax - 1` bytes and then a newline.

## Low

- `rsconstruct.toml:41` and `rsconstruct.toml:45` - `ruff` and `mypy` scan `src` (only `.asm`/`.md`) and `config` (only `.lua`); the only Python is in `scripts/`, so list just `["scripts"]`.
- `pyproject.toml:10` - `pytest` is in the dev group but there are no tests and no pytest processor; drop it.
- `config/project.lua:4` - keyword typos `"assmembly"`, `"assmembler"` -> `"assembly"`, `"assembler"`.
- `src/examples/hello_world.asm:18` - the `; exit(7)` comment sits before the `write` syscall it does not describe; move it below line 19.
- `src/examples/cat_read_write.asm:8-11` - the 4096-byte zero buffer is placed in `.data`, bloating the binary; use `section .bss` with `resb 4096`.
