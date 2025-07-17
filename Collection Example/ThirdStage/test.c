#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *RT_addStrToCollection(char *collection, char *tok)
{
	collection = realloc(collection, strlen(collection) + strlen(tok) + 2);
	strcat(collection, "@");
	strcat(collection, tok);

	return collection;
}

char *RT_unifyCollections(char *var, char *coll)
{
	// char *lOp = malloc(strlen(var) + 1);
	// strcpy(lOp, var);
	char *newColl;
	if (var == NULL)
	{
		newColl = malloc(1);
		*newColl = '\0';
	}
	else
	{
		newColl = malloc(strlen(var) + 1);
		strcpy(newColl, var);
	}

	char *rOp = malloc(strlen(coll) + 1);
	strcpy(rOp, coll);
	char *token;
	token = strtok(rOp + 1, "@");
	do
	{
		if (token && (strstr(newColl, token) == NULL))
			newColl = RT_addStrToCollection(newColl, token);
		token = strtok(NULL, "@");
	} while (token);
	free(rOp);

	return newColl;
}

int main()
{
	
}