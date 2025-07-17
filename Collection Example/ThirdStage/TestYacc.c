#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yyparse(void);

int main(void)
{
    fprintf(stdout, "#include <stdio.h>\n");
    fprintf(stdout, "#include <stdlib.h>\n");
    fprintf(stdout, "#include <string.h>\n\n");

    fprintf(stdout, "int main()\n");
    fprintf(stdout, "{\n");

    yyparse();

    fprintf(stdout, "}\n");
    return 0;
}
