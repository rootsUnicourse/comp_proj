typedef enum {SCL=1, VEC} varType;

struct {
	char *name;      // Variable name
	varType typ;     // Variable type (SCL or VEC)
	int size;        // Vector size (only for VEC type)
} SymTable[100]; 