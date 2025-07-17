%{
#include "Vlang.tab.h"
#include <stdlib.h>
#include <string.h>
void yyerror (char *s);
int yylex();

char* my_strdup(const char* s) {
    char* new_str = malloc(strlen(s) + 1);
    if (new_str) strcpy(new_str, s);
    return new_str;
}
%}

%%
"scl"                   {return t_SCL;}
"vec"                   {return t_VEC;}
"if"                    {return t_IF;}
"loop"                  {return t_LOOP;}
"print"                 {return t_PRINT;}
[0-9]+                  {yylval.ival = atoi(yytext); return t_NUM;}
\"[^\"]*\"              {yylval.str = my_strdup(yytext); return t_STRING;}
[a-zA-Z_][a-zA-Z0-9_]*  {yylval.str = my_strdup(yytext); return t_ID;}
"@"                     {return t_DOT;}
"+"                     {return '+';}
"-"                     {return '-';}
"*"                     {return '*';}
"/"                     {return '/';}
"="                     {return '=';}
":"                     {return ':';}
";"                     {return ';';}
","                     {return ',';}
"("                     {return '(';}
")"                     {return ')';}
"{"                     {return '{';}
"}"                     {return '}';}
"["                     {return '[';}
"]"                     {return ']';}
"<"                     {return '<';}
">"                     {return '>';}
[ \t\n]+                { /* ignore whitespace */ }
"//"[^\n]*              { /* ignore single-line comments */ }
.                       {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;} 