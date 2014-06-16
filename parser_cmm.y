%{

#include<stdio.h>
#include<stdlib.h>

// Basic declarations
int yylex();
void yyerror(const char* s, ...);
extern FILE* yyin;

%}

%union {
    int intval;
    char* string;
}

/* tokens */
%token <intval> NUM
%token <string> IDENTIFIER
%token ASSIGN PLUS MINUS MULT DIV 
%token NOT EQ NEQ GEQ LEQ GT LT
%token LPAREN RPAREN LBRACE RBRACE LSQBRACE RSQBRACE DBQUOTE SQUOTE COMMA SEMICOLON 
%token AND OR
%token INT CHAR IF ELSE WHILE FOR RETURN SCAN PRINT PRINTS PRINTLN VAR LITERAL


/* Type association with union members */
%type <string> VarDecl


/* start symbol */
%start program

%%

program		: 	VarDeclList FuncDeclList								{ }
		;


VarDeclList	:	VarDeclList VarDecl								{ }
		|	 
		;	

VarDecl		: 	IdType IDENTIFIER SEMICOLON							{ printf("Variable Decl\n"); }
		| 	IdType IDENTIFIER ASSIGN NUM SEMICOLON						{ printf("Variable Decl and Assign\n"); } 	
		|	IdType IDENTIFIER LSQBRACE NUM RSQBRACE SEMICOLON				{ printf("Array decl\n"); }
		| 	IdType IDENTIFIER LSQBRACE NUM RSQBRACE ASSIGN LBRACE InitNumList RBRACE SEMICOLON	{ printf("Array Decl and init\n"); }
		;

FuncDeclList	:	FuncDeclList FuncDecl
		|	FuncDecl
		;
	
FuncDecl	:	IdType IDENTIFIER LPAREN ParamDeclListOrEmpty RPAREN Block
		;

ParamDeclListOrEmpty :	ParamDeclList
		     |	
		     ;

ParamDeclList	:	ParamDeclList COMMA ParamDecl
		| 	ParamDecl
		;
	
ParamDecl	:	IdType IDENTIFIER
		| 	IdType IDENTIFIER LSQBRACE RSQBRACE

Block		: 	LBRACE VarDeclList StmtList RBRACE						
		;


CompoundStmt	:	LBRACE StmtList RBRACE			{ printf("cmpnd stmt\n"); }
		|	LBRACE RBRACE				{ printf("cmpnd\n"); }
		;

ExprStmt 	:	Expr 					
		| 	AssignExpr
		;

SelectionStmt	: 	IF LPAREN Expr RPAREN Stmt		{ printf("if block\n"); }		
		| 	IF LPAREN Expr RPAREN Stmt ELSE Stmt	{ printf("if else block\n"); }	
		;	

IterationStmt	:	WHILE LPAREN Expr RPAREN Stmt		{ printf("while block\n"); }
		| 	FOR LPAREN ExprStmt ExprStmt RPAREN Stmt	{ printf("for1 block\n"); }
		| 	FOR LPAREN ExprStmt ExprStmt AssignExpr RPAREN Stmt { printf("for2 block\n"); }
		;	

JumpStmt	: 	RETURN Expr SEMICOLON
		;

IOStmt		:	SCAN LPAREN IDENTIFIER	RPAREN SEMICOLON	
		|	PRINT LPAREN Expr RPAREN SEMICOLON	
		|  	PRINTS LPAREN LITERAL RPAREN SEMICOLON
		| 	PRINTLN SEMICOLON
		;

StmtList 	:	Stmt
		| 	StmtList Stmt
		;

Stmt		: 	CompoundStmt
		|	ExprStmt
		|	SelectionStmt
		| 	IterationStmt
		| 	JumpStmt
		| 	IOStmt
		;

LogicalOp	:	OR | AND
		;

RelationalOp	: 	EQ | NEQ | LT | GT | LEQ | GEQ
		;

MulDivOp 	:	MULT | DIV
		;

AddSubOp	:	PLUS | MINUS
		;

MulDivExpr	:	MulDivExpr MulDivOp PrimaryExpr 
		|	PrimaryExpr
		;	

ArithUnaryExpr	:	ArithUnaryExpr AddSubOp MulDivExpr
		|	MulDivExpr
		;

ArithExpr	:	MINUS ArithUnaryExpr
		| 	ArithUnaryExpr
		;

RelopExpr	:	RelopExpr RelationalOp ArithExpr
		|	ArithExpr
		;

AssignExpr	:	IDENTIFIER ASSIGN ArithExpr SEMICOLON
		| 	IDENTIFIER LSQBRACE ArithExpr RSQBRACE ASSIGN ArithExpr SEMICOLON
		;

Expr		: 	Expr LogicalOp RelopExpr
		|	RelopExpr	
		| 	NOT RelopExpr
		;

ExprListOrEmpty :	ExprList
		|
		;

ExprList	:	ExprList COMMA Expr
		|	Expr
		;


PrimaryExpr	: 	IDENTIFIER
		| 	NUM
		|	LPAREN Expr RPAREN
		|	IDENTIFIER LPAREN ExprListOrEmpty RPAREN	
		|	IDENTIFIER LSQBRACE ArithExpr RSQBRACE
		;


InitNumList	: 	InitNumList COMMA InitNum
		| 	InitNum
		;

InitNum		:	SQUOTE NUM SQUOTE
		;

IdType		: 	INT
		| 	CHAR	
		;




%%

int main(int argc, char* argv[])
{
    FILE* fp = fopen(argv[1], "r");
    yyin = fp;

    // parse
    yyparse();
    fclose(fp);
    return 0;
}
