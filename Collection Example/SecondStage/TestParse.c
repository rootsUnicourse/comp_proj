#include <stdio.h>
#include "Collection.tab.h"

extern int yylex();
extern int yylineno;
extern char* yytext;
extern int yyparse(void);

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

int main(void)
{
    // fprintf(stdout, "#include <stdio.h>\n");
    // fprintf(stdout, "#include <stdlib.h>\n");
    // fprintf(stdout, "#include <string.h>\n\n");
    // fprintf(stdout, "int main()\n");
    // fprintf(stdout, "{\n");

    yyparse();

    // fprintf(stdout, "}\n");

}
