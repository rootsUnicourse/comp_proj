#include <stdio.h>
#include "Collection.tab.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

int main(void)
{
    int tokenCode;
    while(tokenCode=yylex()) {
        printf("Token:%s code:%d", yytext, tokenCode);
        if (tokenCode<256) printf(" ... (%c)", tokenCode);
        printf("\n");
    }

    printf("\nThe End...\n");
}
