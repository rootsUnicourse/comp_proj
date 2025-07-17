parse.exe: lex.yy.c TestParse.c Collection.tab.c 
	gcc lex.yy.c  Collection.tab.c TestParse.c -o parse.exe

lex.yy.c: Collection.tab.c collection.l
	flex Collection.l

Collection.tab.c: Collection.y
	bison -d Collection.y
	
clean: 
	del lex.yy.c Collection.tab.c Collection.tab.h test.exe parse.exe

test.exe: test.c
	gcc test.c -o test.exe