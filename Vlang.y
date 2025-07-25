%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "symTab.h"

extern char* yytext;
static int idx=0;

// Helper Functions
void yyerror (char *s);
int yylex();

char* CopyStr(char* str);
void insert(char* varName, varType typ, int size);
varType getTyp(char* var);
int getSize(char* var);

// Code Generation Functions
void GenerateSclDef(char* var);
void GenerateVecDef(char* var, int size);
void GenerateSclAssign(char* var, char* expr);
void GenerateVecAssign(char* var, char* expr);
void GeneratePrint(char* prompt, char* elements);
void GenerateIf(char* condition);
void GenerateLoop(char* count);
void GenerateBlockStart();
void GenerateBlockEnd();

// Expression Generation Functions
char* GenerateExprOp(char* left, char op, char* right);
char* GenerateIndexOp(char* left, char* right);
char* DetermineExprType(char* expr);
char* GenerateSclOp(char* left, char op, char* right);
char* GenerateVecOp(char* left, char op, char* right);
char* GenerateVecScalarOp(char* vec, char op, char* scl);
char* GenerateDotProduct(char* left, char* right);
char* GenerateVecIndex(char* vec, char* index);
char* GenerateVecLiteral(char* elements);
char* CreateTempVar();

static int tempVarCount = 0;

%}

%union {
    char *str;
    int ival;
}

%token <str> t_ID t_STRING
%token <ival> t_NUM
%token t_SCL t_VEC t_IF t_LOOP t_PRINT t_DOT

%type <str> expression vector_literal element_list
%type <str> variable print_elements

%left '+' '-'
%left '*' '/'
%left t_DOT
%left ':'
%left '(' ')'

%%

program: statement_list
    | '{' statement_list '}'
    ;

statement_list: statement
    | statement_list statement
    ;

statement: variable_declaration ';'
    | assignment ';'
    | print_statement ';'
    | if_statement
    | loop_statement
    ;

variable_declaration: t_SCL t_ID {
        GenerateSclDef($2);
        insert($2, SCL, 0);
    }
    | t_VEC t_ID '{' t_NUM '}' {
        GenerateVecDef($2, $4);
        insert($2, VEC, $4);
    }
    ;

assignment: t_ID '=' expression {
        if (getTyp($1) == SCL) {
            GenerateSclAssign($1, $3);
        } else if (getTyp($1) == VEC) {
            GenerateVecAssign($1, $3);
        } else {
            yyerror("Undefined variable");
        }
    }
    ;

expression: t_NUM {
        char* temp = malloc(20);
        sprintf(temp, "%d", $1);
        $$ = temp;
    }
    | t_ID {
        $$ = CopyStr($1);
    }
    | vector_literal { $$ = $1; }
    | expression '+' expression {
        $$ = GenerateExprOp($1, '+', $3);
    }
    | expression '-' expression {
        $$ = GenerateExprOp($1, '-', $3);
    }
    | expression '*' expression {
        $$ = GenerateExprOp($1, '*', $3);
    }
    | expression '/' expression {
        $$ = GenerateExprOp($1, '/', $3);
    }
    | expression t_DOT expression {
        $$ = GenerateDotProduct($1, $3);
    }
    | expression ':' expression {
        $$ = GenerateIndexOp($1, $3);
    }
    | '(' expression ')' {
        $$ = $2;
    }
    ;

vector_literal: '[' element_list ']' {
        $$ = GenerateVecLiteral($2);
    }
    | '[' ']' {
        $$ = GenerateVecLiteral("");
    }
    ;

element_list: expression {
        $$ = CopyStr($1);
    }
    | element_list ',' expression {
        char* temp = malloc(strlen($1) + strlen($3) + 3);
        sprintf(temp, "%s, %s", $1, $3);
        $$ = temp;
    }
    ;

print_statement: t_PRINT t_STRING ':' print_elements {
        GeneratePrint($2, $4);
    }
    ;

print_elements: expression {
        $$ = CopyStr($1);
    }
    | print_elements ',' expression {
        char* temp = malloc(strlen($1) + strlen($3) + 3);
        sprintf(temp, "%s, %s", $1, $3);
        $$ = temp;
    }
    ;

if_statement: t_IF expression block {
        GenerateIf($2);
    }
    ;

loop_statement: t_LOOP expression block {
        GenerateLoop($2);
    }
    ;

block: '{' {GenerateBlockStart();} statement_list '}' {GenerateBlockEnd();}
    ;

variable: t_ID { $$ = CopyStr($1); }
    ;

%%

// Helper Functions Implementation

char* CopyStr(char* str) {
    char* new = malloc(strlen(str) + 1);
    strcpy(new, str);
    return new;
}

void insert(char* varName, varType typ, int size) {
    SymTable[idx].name = malloc(strlen(varName) + 1);
    strcpy(SymTable[idx].name, varName);
    SymTable[idx].typ = typ;
    SymTable[idx].size = size;
    printf("// DEB: Insert \"%s\" type:%d size:%d\n", varName, typ, size);
    ++idx;
}

varType getTyp(char* var) {
    for (int i = 0; i < idx; ++i) {
        if (strcmp(SymTable[i].name, var) == 0) {
            return SymTable[i].typ;
        }
    }
    return 0;
}

int getSize(char* var) {
    for (int i = 0; i < idx; ++i) {
        if (strcmp(SymTable[i].name, var) == 0) {
            return SymTable[i].size;
        }
    }
    return 0;
}

char* CreateTempVar() {
    char* temp = malloc(20);
    sprintf(temp, "temp%d", tempVarCount++);
    fprintf(stdout, "int %s[MAX_VEC_SIZE];\n", temp);
    fprintf(stdout, "int %s_size = MAX_VEC_SIZE;\n", temp);
    return temp;
}

// Code Generation Functions

char* GenerateExprOp(char* left, char op, char* right) {
    // Determine operation type based on operands
    char* leftType = DetermineExprType(left);
    char* rightType = DetermineExprType(right);
    
    if (strcmp(leftType, "vector") == 0 && strcmp(rightType, "scalar") == 0) {
        return GenerateVecScalarOp(left, op, right);
    } else if (strcmp(leftType, "vector") == 0 && strcmp(rightType, "vector") == 0) {
        return GenerateVecOp(left, op, right);
    } else {
        return GenerateSclOp(left, op, right);
    }
}

char* GenerateIndexOp(char* left, char* right) {
    return GenerateVecIndex(left, right);
}

char* DetermineExprType(char* expr) {
    // Simple heuristic: check if it's a known vector variable
    // Numbers are scalars, temp variables are vectors, check symbol table for others
    if (isdigit(expr[0]) || (expr[0] == '(' && isdigit(expr[1]))) {
        return "scalar";
    }
    if (strncmp(expr, "temp", 4) == 0) {
        return "vector";
    }
    if (getTyp(expr) == VEC) {
        return "vector";
    }
    return "scalar";
}

void GenerateSclDef(char* var) {
    fprintf(stdout, "int %s;\n", var);
}

void GenerateVecDef(char* var, int size) {
    fprintf(stdout, "int %s[%d];\n", var, size);
    fprintf(stdout, "int %s_size = %d;\n", var, size);
}

void GenerateSclAssign(char* var, char* expr) {
    fprintf(stdout, "%s = %s;\n", var, expr);
}

void GenerateVecAssign(char* var, char* expr) {
    fprintf(stdout, "copy_vector(%s, %s, %s_size);\n", var, expr, var);
}

char* GenerateSclOp(char* left, char op, char* right) {
    char* temp = malloc(strlen(left) + strlen(right) + 10);
    sprintf(temp, "(%s %c %s)", left, op, right);
    return temp;
}

char* GenerateVecOp(char* left, char op, char* right) {
    char* temp = CreateTempVar();
    fprintf(stdout, "vector_%c_vector(%s, %s, %s, %s_size);\n", 
           op == '+' ? 'a' : op == '-' ? 's' : op == '*' ? 'm' : 'd',
           temp, left, right, left);
    return temp;
}

char* GenerateVecScalarOp(char* vec, char op, char* scl) {
    char* temp = CreateTempVar();
    fprintf(stdout, "vector_%c_scalar(%s, %s, %s, %s_size);\n",
           op == '+' ? 'a' : op == '-' ? 's' : op == '*' ? 'm' : 'd',
           temp, vec, scl, vec);
    return temp;
}

char* GenerateDotProduct(char* left, char* right) {
    char* temp = malloc(50);
    sprintf(temp, "dot_product(%s, %s, %s_size)", left, right, left);
    return temp;
}

char* GenerateVecIndex(char* vec, char* index) {
    char* temp = malloc(strlen(vec) + strlen(index) + 10);
    sprintf(temp, "%s[%s]", vec, index);
    return temp;
}

char* GenerateVecLiteral(char* elements) {
    char* temp = CreateTempVar();
    if (strlen(elements) > 0) {
        fprintf(stdout, "int temp_init_%d[] = {%s};\n", tempVarCount-1, elements);
        fprintf(stdout, "copy_array_to_vector(%s, temp_init_%d, sizeof(temp_init_%d)/sizeof(int));\n", temp, tempVarCount-1, tempVarCount-1);
    }
    return temp;
}

void GeneratePrint(char* prompt, char* elements) {
    fprintf(stdout, "printf(%s);\n", prompt);
    
    // Parse the elements (for now assume single element)
    if (strcmp(DetermineExprType(elements), "vector") == 0) {
        // Print vector elements
        fprintf(stdout, "print_vector(%s, %s_size);\n", elements, elements);
        fprintf(stdout, "printf(\"\\n\");\n");
    } else {
        // Print scalar value  
        fprintf(stdout, "printf(\"%%d\\n\", %s);\n", elements);
    }
}

void GenerateIf(char* condition) {
    fprintf(stdout, "if (%s != 0) {\n", condition);
}

void GenerateLoop(char* count) {
    fprintf(stdout, "for (int loop_i = 0; loop_i < %s; loop_i++) {\n", count);
}

void GenerateBlockStart() {
    fprintf(stdout, "{\n");
}

void GenerateBlockEnd() {
    fprintf(stdout, "}\n");
}

void yyerror(char *s) {
    fprintf(stderr, "%s ... bye\n", s);
    exit(1);
} 