#!/usr/bin/env python

""" Assemble one .asm with nasm (-f elf64) and link it with ld, reproducing the
Makefile: nasm -f elf64 -o x.o x.asm ; ld -o x.elf x.o. The generator invokes
this as nasm_link.py <input.asm> <output.elf>; the .o goes next to the elf. """

import os
import subprocess
import sys


def main():
    """ main entry point """
    source, elf = sys.argv[1], sys.argv[2]
    obj = os.path.splitext(elf)[0] + ".o"
    os.makedirs(os.path.dirname(elf), exist_ok=True)
    ret = subprocess.call(["nasm", "-f", "elf64", "-o", obj, source])
    if ret != 0:
        sys.exit(ret)
    sys.exit(subprocess.call(["ld", "-o", elf, obj]))


if __name__ == "__main__":
    main()
