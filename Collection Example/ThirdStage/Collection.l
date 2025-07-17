%{
#include "Collection.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
\{                      {return '{';}
\}                      {return '}';}
collection              {return t_COLLECTION_CMD;}
output                  {return t_OUTPUT_CMD;}
\"[^\"]*\"              {return t_STRING;}
[a-zA-Z][a-zA-Z0-9]*    {return t_ID;}
[+=;,]           	    {return yytext[0];}
[ \t\n]                 {}
.                       {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}
