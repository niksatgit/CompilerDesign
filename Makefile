LEX = lex
YACC = yacc -d
CC = gcc -g
SOURCES = y.tab.c \
	lex.yy.c 

Compdsgn-1: scanner_cmm.l parser_cmm.y
	$(YACC) parser_cmm.y
	$(LEX) scanner_cmm.l
	$(CC) -o $@ $(SOURCES) -ll -lm

clean: 
	rm -f *.o Compdsgn-1 y.tab.c y.tab.h lex.yy.c
