typedef enum {Collection=1, Set} varType;

struct {
	char *name;
	varType typ;
} SymTable[100];
