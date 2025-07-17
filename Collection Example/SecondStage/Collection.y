%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "symTab.h"

extern char* yytext;

//	===	YACC Helper Functions	============================

static char* CopyStr(char* str)
{
    char *new, *p;

    if (str[0] == '\"') {               //Literal
		str[0] = '@';
        new = malloc(strlen(str));
        if ((p = strchr(str+1, '\"')))
            *p = '\0';
        strcpy(new, str);
        printf("\t// DEB: *Copy %s\n", str);	//*DEBUG
    }
    else {
        new = malloc(strlen(str)+1);    //Variable Name
        strcpy(new, str);
        printf("\t// DEB: *Copy %s\n", str);	//*DEBUG
    }

    return new;
}

char* AddStrToList(char* list, char* str)				//adds <str> - a literal token
{
    char *p;
    char *new = realloc(list, strlen(list)+strlen(str));
    strcat(new, "@");
    if ((p = strchr(str+1, '\"')))
        *p = '\0';
    strcat(new, str+1);
	printf("\t// DEB: *NewStrList:%s\n", new);	//DEBUG
	return new;
}

void insert(char* varName, varType typ)				//Symbol Table PUT token <type, lexeme>
{
	static int idx=0;
	
	SymTable[idx].name = malloc(strlen(varName)+1);
	strcpy(SymTable[idx].name, varName);
    SymTable[idx].typ = typ;
	printf("\t// DEB: *Insert \"%s\" in to symtab; typ:%d\n", varName, typ); //DEBUG
	++idx;
}

//	===	Code Generation Functions	===========================================

void GenerateColDef(char* colVar)					//collection variable definition
{
	fprintf(stdout, "char* %s=NULL;\n", colVar);
	insert(colVar, Collection);
}

void GenerateColAssign(char* var, char* coll)		//Assignment Statement
{
	if (coll[0]=='@')												//Collection Literal
		fprintf(stdout, "%s = \"%s\";\n", var, coll);
	else {															//Collection Variable
		fprintf(stdout, "%s = malloc(strlen(%s)+1);\n", var, coll);
		fprintf(stdout, "strcpy(%s, %s);\n", var, coll);
	}
}

void GenerateColOut(char* Prompt, char* coll)		//collection Output statement
{
	fprintf(stdout, "printf(\"%s \");\n", Prompt+1);	//Command to print Prompt string

	fprintf(stdout, "printf(\"{\");\n");				//Command to start collection output block

	if (coll[0] == '@') { //Literal
		char* temp = malloc(strlen(coll)+1);
		strcpy(temp, coll);
		char *token;
		token = strtok(temp+1, "@");	//First Token
		char* comma="";
		do {
			if (token) fprintf(stdout, "printf(\"%s\\\"%s\\\"\");\n", comma, token);
			comma=", ";
			token = strtok(NULL, "@");
		} while (token);
    	free(temp);
	}
	else {	//Variable
        fprintf(stdout, "{\n");
		fprintf(stdout, "char* temp = malloc(strlen(%s)+1);\n", coll);
		fprintf(stdout, "strcpy(temp, %s);\n", coll);
		fprintf(stdout, "char *token;\n");
		fprintf(stdout, "token = strtok(temp+1, \"@\");\n");
		fprintf(stdout, "char* comma=\"\";\n");
		fprintf(stdout, "do {\n");
		fprintf(stdout, "\tif (token) printf(\"%%s\\\"%%s\\\"\", comma, token);\n");
		fprintf(stdout, "\tcomma=\", \";\n");
		fprintf(stdout, "\ttoken = strtok(NULL, \"@\");\n");
		fprintf(stdout, "} while (token);\n");
    	fprintf(stdout, "free(temp);\n");
        fprintf(stdout, "}\n");
	}

    fprintf(stdout, "printf(\"}\\n\");\n");		//Command to end collection output block
}

%}

%union {char *str;}         /* Yacc definitions */
%token <str> t_STRING t_ID
%token t_COLLECTION_CMD t_OUTPUT_CMD
%type <str> STRING_LIST
%type <str> VAR COLLECTION


%%
/* descriptions of expected inputs     corresponding actions (in C) */
SENTENCE :			t_COLLECTION_CMD VAR ';'				{GenerateColDef($2);}
	|				VAR '=' COLLECTION ';'					{GenerateColAssign($1,$3);}
	|				t_OUTPUT_CMD t_STRING {$2=CopyStr(yytext);} COLLECTION ';'			{GenerateColOut($2, $4);}
COLLECTION :		VAR										{$$=CopyStr($1);}
	|				'{' '}'									{$$ = "@";}
	|				'{' STRING_LIST '}'						{$$ = $2;}
VAR :				t_ID									{$$ = CopyStr(yytext)}
STRING_LIST :		STRING_LIST ',' t_STRING				{$$ = AddStrToList($1, yytext);}
	|				t_STRING								{$$ = CopyStr(yytext);}
