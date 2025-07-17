test.exe: lex.yy.c TestLex.c
	gcc lex.yy.c TestLex.c -o test.exe

lex.yy.c: Collection.tab.h collection.l
	flex Collection.l

Collection.tab.h: Collection.y
	bison -d Collection.y
	
clean: 
	del lex.yy.c Collection.tab.c Collection.tab.h test.exe