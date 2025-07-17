# Makefile for Vlang Compiler (Windows)
# Prerequisites: bison and flex installed

# Compiler executable
vlang.exe: lex.yy.c Vlang.tab.c TestVlang.c runtime.c
	gcc lex.yy.c Vlang.tab.c TestVlang.c runtime.c -o vlang.exe

# Generate lexer
lex.yy.c: Vlang.tab.c Vlang.l
	flex Vlang.l

# Generate parser
Vlang.tab.c: Vlang.y
	bison -d Vlang.y

# Compile example program to C
example.c: example.vl vlang.exe
	vlang.exe < example.vl > example.c

# Compile generated C code
example.exe: example.c runtime.c
	gcc example.c runtime.c -o example.exe

# Test the complete pipeline
test: example.exe
	example.exe

# Clean generated files
clean:
	del lex.yy.c Vlang.tab.c Vlang.tab.h vlang.exe example.c example.exe

# Help
help:
	@echo "Vlang Compiler Makefile"
	@echo "Available targets:"
	@echo "  vlang.exe    - Build the Vlang compiler"
	@echo "  example.c    - Compile example.vl to C code"
	@echo "  example.exe  - Compile generated C to executable"
	@echo "  test         - Run the complete compilation pipeline"
	@echo "  clean        - Remove all generated files"
	@echo "  help         - Show this help message"

.PHONY: test clean help 