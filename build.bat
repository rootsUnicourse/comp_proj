@echo off
echo Building Vlang Compiler...

echo Step 1: Generating parser with bison...
bison -d Vlang.y
if %errorlevel% neq 0 (
    echo Error: bison failed. Make sure bison is installed and in PATH.
    pause
    exit /b 1
)

echo Step 2: Generating lexer with flex...
flex Vlang.l
if %errorlevel% neq 0 (
    echo Error: flex failed. Make sure flex is installed and in PATH.
    pause
    exit /b 1
)

echo Step 3: Compiling Vlang compiler...
gcc lex.yy.c Vlang.tab.c TestVlang.c runtime.c -o vlang.exe
if %errorlevel% neq 0 (
    echo Error: gcc compilation failed. Make sure gcc is installed and in PATH.
    pause
    exit /b 1
)

echo Step 4: Compiling example Vlang program to C...
vlang.exe < example.vl > example.c
if %errorlevel% neq 0 (
    echo Error: Vlang compilation failed.
    pause
    exit /b 1
)

echo Step 5: Compiling generated C code to executable...
gcc example.c runtime.c -o example.exe
if %errorlevel% neq 0 (
    echo Error: C compilation failed.
    pause
    exit /b 1
)

echo Step 6: Running the example program...
echo.
echo ============= Example Output =============
example.exe
echo ==========================================
echo.
echo Build completed successfully!
echo Generated files:
echo - vlang.exe (Vlang compiler)
echo - example.c (Generated C code)
echo - example.exe (Final executable)
pause 