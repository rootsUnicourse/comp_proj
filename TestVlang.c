#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yyparse(void);

int main(void)
{
    // Generate C code header
    fprintf(stdout, "#include <stdio.h>\n");
    fprintf(stdout, "#include <stdlib.h>\n");
    fprintf(stdout, "#include <string.h>\n");
    fprintf(stdout, "#include \"runtime.h\"\n\n");

    fprintf(stdout, "#define MAX_VEC_SIZE 100\n\n");

    fprintf(stdout, "int main()\n");
    fprintf(stdout, "{\n");

    // Parse the Vlang input and generate C code
    yyparse();

    fprintf(stdout, "return 0;\n");
    fprintf(stdout, "}\n");
    
    return 0;
} 