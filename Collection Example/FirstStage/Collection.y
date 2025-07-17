%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
%}

%union {char *str;}         /* Yacc definitions */
%token <str> t_STRING t_ID
%token t_COLLECTION_CMD


%%
/* descriptions of expected inputs     corresponding actions (in C) */
SENTENCE : t_STRING			//Place Holder

%%                     /* C code */


int main (void) {
	return yyparse ( );
}

