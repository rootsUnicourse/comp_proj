# Vlang Compiler

A compiler for the Vlang programming language that transpiles to C/C++.

## Language Features

Vlang supports:
- **Data Types**: `scl` (scalar integers) and `vec` (vectors)
- **Operators**: `+`, `-`, `*`, `/`, `@` (dot product), `:` (indexing)
- **Control Structures**: `if` conditionals and `loop` statements
- **Vector Operations**: Element-wise operations, indexing, and dot products
- **Print Statements**: Formatted output with prompts

## Installation Prerequisites

### 1. Install Bison (Required)
1. Download and run `bison-2.4.1-setup.exe`
2. Overwrite `bison.exe` in `C:\Program Files (x86)\GnuWin32\bin` with the included `bison.exe`
3. Add `C:\Program Files (x86)\GnuWin32\bin` to your system PATH

### 2. Install Flex (Required)
Flex should be included with the GnuWin32 installation.

### 3. Install GCC (Required)
Install MinGW-w64 or use TDM-GCC for Windows.

## Project Structure

```
comp_proj/
├── Vlang.l          # LEX file (tokenizer)
├── Vlang.y          # YACC file (parser & code generator)
├── symTab.h         # Symbol table definitions
├── TestVlang.c      # Test driver
├── runtime.h        # Runtime function declarations
├── runtime.c        # Runtime function implementations
├── Makefile         # Build configuration (for make)
├── build.bat        # Windows build script
├── example.vl       # Example Vlang program
└── README.md        # This file
```

## Building the Compiler

### Option 1: Using batch file (Recommended for Windows)
```cmd
build.bat
```

### Option 2: Manual compilation
```cmd
# Generate parser
bison -d Vlang.y

# Generate lexer
flex Vlang.l

# Compile compiler
gcc lex.yy.c Vlang.tab.c TestVlang.c runtime.c -o vlang.exe

# Compile example
vlang.exe < example.vl > example.c
gcc example.c runtime.c -o example.exe
```

## Usage

1. **Write a Vlang program** (e.g., `program.vl`)
2. **Compile to C**: `vlang.exe < program.vl > program.c`
3. **Compile C to executable**: `gcc program.c runtime.c -o program.exe`
4. **Run**: `program.exe`

## Example Program

```vlang
{
scl x;
vec v{4};
x = 5;
v = [1, 2, 3, 4];
v = v * x;
print "Result": v;
}
```

## Language Syntax

### Variable Declaration
```vlang
scl variable_name;        // Scalar integer
vec vector_name{size};    // Vector of specified size
```

### Assignment
```vlang
x = 10;                   // Scalar assignment
v = [1, 2, 3];           // Vector literal assignment
v = 5;                   // Assign scalar to all vector elements
```

### Operators
```vlang
// Arithmetic
x = a + b;               // Addition
x = a - b;               // Subtraction
x = a * b;               // Multiplication
x = a / b;               // Division

// Vector operations
v3 = v1 + v2;           // Element-wise addition
v3 = v1 * 5;            // Scalar multiplication
x = v1 @ v2;            // Dot product
x = v[2];               // Vector indexing (v:2)
```

### Control Flow
```vlang
if condition {
    // statements
}

loop count {
    // statements
}
```

### Print Statement
```vlang
print "Message": variable1, variable2;
```

## Generated Files

- `vlang.exe` - The Vlang compiler
- `example.c` - Generated C code from example.vl
- `example.exe` - Compiled executable
- `lex.yy.c` - Generated lexer
- `Vlang.tab.c` / `Vlang.tab.h` - Generated parser

## Troubleshooting

1. **"bison not recognized"**: Ensure bison is installed and in PATH
2. **"flex not recognized"**: Install flex or ensure it's in PATH
3. **"gcc not recognized"**: Install MinGW-w64 or TDM-GCC
4. **Compilation errors**: Check syntax in your Vlang program

## Project Requirements Met

1. ✅ LEX file (`Vlang.l`)
2. ✅ YACC file (`Vlang.y`)
3. ✅ Makefile for Windows environment
4. ✅ Compiler executable (`vlang.exe`)
5. ✅ Example source file (`example.vl`)
6. ✅ Generated C/C++ file (`example.c`)
7. ✅ Final executable (`example.exe`)
8. ✅ Build and test process documented

## Video Demonstration Steps

1. Run `build.bat` to build the compiler
2. Show the generated `vlang.exe`
3. Compile `example.vl` to C: `vlang.exe < example.vl > example.c`
4. Show the generated `example.c` file
5. Compile C to executable: `gcc example.c runtime.c -o example.exe`
6. Run the final executable: `example.exe` 