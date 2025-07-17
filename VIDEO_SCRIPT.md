# Video Script: Vlang Compiler Demonstration

## Pre-Recording Setup
- Open terminal in the submission folder
- Have all files ready
- Clear terminal for clean recording

---

## Script (Estimated 3-4 minutes)

### **Opening (10 seconds)**
*"Hello! I'm demonstrating my Vlang compiler project for the Compilation Methods course. This compiler transpiles Vlang programs to C code."*

### **1. Show Project Structure (20 seconds)**
```cmd
ls
# or dir on Windows
```
*"Here are the submission files: The LEX file for lexical analysis, YACC file for parsing, the Makefile for building, our compiler executable, and example programs."*

### **2. Build Process Demonstration (45 seconds)**
```cmd
# Show the build process
bison -d Vlang.y
```
*"First, I'll generate the parser with Bison from the YACC grammar file."*

```cmd
flex Vlang.l
```
*"Next, I generate the lexer with Flex from the LEX file."*

```cmd
gcc lex.yy.c Vlang.tab.c TestVlang.c runtime.c -o vlang.exe
```
*"Now I compile all components together to create the Vlang compiler executable."*

### **3. Show Example Program (30 seconds)**
```cmd
type advanced_test.vl
# or cat advanced_test.vl on Mac/Linux
```
*"Here's our example Vlang program. It demonstrates scalar variables, vectors, arithmetic operations, vector literals, dot products, and print statements."*

### **4. Compile Vlang to C (30 seconds)**
```cmd
Get-Content advanced_test.vl | .\vlang.exe > demo_output.c
# or ./vlang < advanced_test.vl > demo_output.c on Mac/Linux
```
*"Now I'll compile the Vlang program to C code using our compiler."*

```cmd
type demo_output.c
# Show the first 15-20 lines
```
*"Here's the generated C code. Notice how Vlang constructs are translated to C function calls and proper variable declarations."*

### **5. Compile C to Executable (25 seconds)**
```cmd
gcc demo_output.c runtime.c -o demo_program.exe
```
*"Next, I compile the generated C code with our runtime library to create the final executable."*

### **6. Run the Program (40 seconds)**
```cmd
.\demo_program.exe
```
*"Finally, let's run the program and see the output:"*

**Expected Output:**
```
a + b * 2 =16
v1 =[5, 10, 15, 20]
v2 =[1, 2, 3, 4]
v1 + v2 =[6, 12, 18, 24]
v1 - v2 =[4, 8, 12, 16]
v1 * 2 =[10, 20, 30, 40]
v2 + 5 =[6, 7, 8, 9]
v1 @ v2 (dot product) =150
v1[0] =5
v2[3] =4
(a + b) * 2 =26
(v1 + v2) * 3 =[18, 36, 54, 72]
```

*"Perfect! The output shows scalar arithmetic with operator precedence, vector operations like addition and subtraction, vector-scalar operations, dot products, and vector indexing all working correctly."*

### **7. Closing (20 seconds)**
*"This demonstrates the complete compilation pipeline: Vlang source code → C code → executable program. The compiler successfully handles complex mathematical expressions, vectors, and produces correct output. Thank you!"*

---

## Recording Tips

1. **Speak clearly and at moderate pace**
2. **Show commands before typing them**
3. **Highlight key features as they appear**
4. **If something goes wrong, mention it's normal in development**
5. **Keep terminal text large enough to read**
6. **Test the entire flow before recording**

## Alternative Commands (if using Mac/Linux)
- Replace `type` with `cat`
- Replace `Get-Content file | .\vlang.exe` with `./vlang < file`
- Replace `.exe` extensions as needed
- Replace `dir` with `ls`

---

## Key Points to Emphasize
- ✅ Complete build process from source
- ✅ Lexical and syntactic analysis
- ✅ Code generation to C
- ✅ Runtime system integration
- ✅ Complex language features working
- ✅ Proper operator precedence
- ✅ Vector operations and indexing 