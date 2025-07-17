%{
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "symTab.h"

extern char* yytext;
static int idx=0;

//	===	CompileTime Helper Functions	=============================================
void yyerror (char *s);
int yylex();

char* CopyStr(char* str);
char* AddStrToList(char* list, char* str);
void insert(char* varName, varType typ);
varType getTyp(char* var);
void GenerateColDef(char* colVar);					//collection variable definition
void GenerateColAssign(char* var, char* coll);
void GenerateColOut(char* Prompt, char* coll);		//collection Output statement
void GenerateColUnify(char* varResultName, char* varName, char* coll);


char* RT_unifyCollections(char* var, char* coll);
char* RT_addStrToCollection(char* collection, char* str);

%}

%union {char *str;}         /* Yacc definitions */
%token <str> t_STRING t_ID
%token t_COLLECTION_CMD t_OUTPUT_CMD
%type <str> STRING_LIST
%type <str> VAR COLLECTION


%%
/* descriptions of expected inputs     corresponding actions (in C) */
Prog :				SENTENCE
	|				Prog SENTENCE
SENTENCE :			t_COLLECTION_CMD VAR ';'				{GenerateColDef($2);}
	|				VAR '=' COLLECTION ';'					{GenerateColAssign($1,$3);}
	|				t_OUTPUT_CMD t_STRING {$2=CopyStr(yytext);} COLLECTION ';'			{GenerateColOut($2, $4);}
	|				VAR '=' VAR '+' COLLECTION ';'			{GenerateColUnify($1, $3, $5);}
COLLECTION :		VAR										{$$=CopyStr($1);}
	|				'{' '}'									{$$ = "@";}
	|				'{' STRING_LIST '}'						{$$ = $2;}
VAR :				t_ID									{$$ = CopyStr(yytext)}
STRING_LIST :		STRING_LIST ',' t_STRING				{$$ = AddStrToList($1, yytext);}
	|				t_STRING								{$$ = CopyStr(yytext);}

%%
//	===	YACC Helper Functions	============================

char* CopyStr(char* str)
{
    char *new, *p;

    if (str[0] == '\"') {               //Literal
		str[0] = '@';
        new = malloc(strlen(str));
        if ((p = strchr(str+1, '\"')))
            *p = '\0';
        strcpy(new, str);
        printf("\t// DEB: *Copy %s\n", str);	//DEBUG
    }
    else {
        new = malloc(strlen(str)+1);    //Variable Name
        strcpy(new, str);
        printf("\t// DEB: *Copy %s\n", str);	//DEBUG
    }

    return new;
}

char* AddStrToList(char* list, char* str)
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
	SymTable[idx].name = malloc(strlen(varName)+1);
	strcpy(SymTable[idx].name, varName);
    SymTable[idx].typ = typ;
	printf("\t// DEB: *Insert \"%s\" in to symtab; typ:%d\n", varName, typ); //DEBUG
	++idx;
}

varType getTyp(char* var)							//Symbol Table GET variable type
{
    for (int i=0 ; i<idx ; ++i)
        if (strcmp(SymTable[i].name, var)==0)
            return SymTable[i].typ;
    return 0;										//0 if it doesn't exist
}

//	===	Code Generation Functions	===========================================

void GenerateColDef(char* colVar)					//collection variable definition
{
	fprintf(stdout, "char* %s=NULL;\n", colVar);
	insert(colVar, Collection);
}

void GenerateColAssign(char* var, char* coll)
{
	char msg[32];
	
	if (getTyp(var)!=Collection) {								//lvalue must be a collection
		sprintf(msg, "%s not defined as a collection", var);
		yyerror(msg);
	}

	if ((coll[0]!='@') && getTyp(coll)!=Collection) {			//if rvalue is a variable, it must be a collection
		sprintf(msg, "%s not defined as a collection", coll);
		yyerror(msg);
	}

	fprintf(stdout, "{\n");
	fprintf(stdout, "int len;\n");

	if (coll[0]=='@')
		fprintf(stdout, "len = strlen(\"%s\");\n", coll);
	else
		fprintf(stdout, "len = strlen(%s);\n", coll);

	fprintf(stdout, "if (%s == NULL) %s=malloc(len+1);\n", var, var);
	fprintf(stdout, "else 	%s=realloc(%s, len+1);\n", var, var);

	if (coll[0]=='@')
		fprintf(stdout, "strcpy(%s,\"%s\");\n", var, coll);
	else
		fprintf(stdout, "strcpy(%s, %s);\n", var, coll);

	fprintf(stdout, "}\n");
}

void GenerateColOut(char* Prompt, char* coll)		//collection Output statement
{
	char msg[32];

	if ((coll[0]!='@') && getTyp(coll)!=Collection) {			//if collection to output is a variable - must be a collection
		sprintf(msg, "%s not defined as a collection", coll);
		yyerror(msg);
	}

	fprintf(stdout, "printf(\"%s \");\n", Prompt+1);	//Command to print Prompt string

	fprintf(stdout, "printf(\"{\");\n");				//Command to start collection output block

	if (coll[0] == '@') { //Literal
		char* temp = malloc(strlen(coll)+1);
		strcpy(temp, coll);
		char *token;
		token = strtok(temp+1, "@");	//First Token
		char* comma="";
		do {
			if (token) fprintf(stdout, "printf(\"%s%s\");\n", comma, token);
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
		fprintf(stdout, "\tif (token) printf(\"%%s%%s\", comma, token);\n");
		fprintf(stdout, "\tcomma=\", \";\n");
		fprintf(stdout, "\ttoken = strtok(NULL, \"@\");\n");
		fprintf(stdout, "} while (token);\n");
    	fprintf(stdout, "free(temp);\n");
        fprintf(stdout, "}\n");
	}

    fprintf(stdout, "printf(\"}\\n\");\n");		//Command to end collection output block
}

void GenerateColUnify(char* varResultName, char* varName, char* coll)
{
	char msg[32];

	if (getTyp(varResultName)!=Collection) {	//lvalue must be an existing collection variable
		sprintf(msg, "%s not defined as a collection", varResultName);
		yyerror(msg);
	}

	if (getTyp(varName)!=Collection) {			//1st operand must be a collection variable
		sprintf(msg, "%s not defined as a collection", varName);
		yyerror(msg);
	}

	if ((coll[0]!='@') && getTyp(coll)!=Collection) {			//if 2nd operand is a variable - must be a collection
		sprintf(msg, "%s not defined as a collection", coll);
		yyerror(msg);
	}

	//fprintf(stdout, "{\n");
	if (coll[0]=='@')
		fprintf(stdout, "%s = RT_unifyCollections(%s, \"%s\");\n", varResultName, varName, coll);
	else
		fprintf(stdout, "%s = RT_unifyCollections(%s, %s);\n", varResultName, varName, coll);

	//fprintf(stdout, "int len = strlen(unified);\n");

	//fprintf(stdout, "if (%s == NULL)	%s=malloc(len+1);\n", varResultName, varResultName);
	//fprintf(stdout, "else	%s = realloc(%s, strlen(%s)+len+1);\n", varResultName, varResultName, varResultName);

	//fprintf(stdout, "strcpy(%s, unified);\n", varResultName);
	//fprintf(stdout, "}\n");
}

void yyerror(char *s)
{
	fprintf(stderr, "%s ... bye\n", s);
	exit(1);
}

