<%!
    import pydmt.helpers.git
%>${"##"} Number of examples

Currently there are ${pydmt.helpers.git.count_files("src/*.asm")} examples in this repo.

# How to run examples from this repository?

	$ make
	$ ./src/hello_world.elf
