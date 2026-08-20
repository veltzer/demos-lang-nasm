#!/usr/bin/env python

""" Assemble each .asm with nasm and link it with ld, mirroring the source
tree under out/ (out/<dir>/<name>.o and .elf), reproducing the Makefile:
nasm -f elf64 -o out/x.o x.asm ; ld -o out/x.elf out/x.o. """

import os
import subprocess
import sys


def build_one(source):
    """ Assemble and link a single .asm source, return the exit code. """
    stem = os.path.splitext(source)[0]
    obj = os.path.join("out", stem + ".o")
    elf = os.path.join("out", stem + ".elf")
    os.makedirs(os.path.dirname(obj), exist_ok=True)
    ret = subprocess.call(["nasm", "-f", "elf64", "-o", obj, source])
    if ret != 0:
        return ret
    return subprocess.call(["ld", "-o", elf, obj])


def main():
    """ main entry point """
    for source in sys.argv[1:]:
        ret = build_one(source)
        if ret != 0:
            sys.exit(ret)


if __name__ == "__main__":
    main()
