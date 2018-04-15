%{
    
    
    #include <stdio.h>
    extern void init_array();
    extern int hashCode(char*);
    extern void insert(int, char*, char*, char*, int, int, char*);
    extern int find(struct NODE *,char*);
    extern void display();
    int yylex();
    void yyerror();
%}

%token num NULLType BOOL ABSTRACT BOOLEAN BREAK BYTE CASE CATCH CHAR CLASS CONST CONTINUE DEFAULT DELETE DO DOUBLE ELSE EXTENDS FINAL FINALLY FLOAT FOR FUNCTION GOTO IF IMPLEMENTS IMPORT IN INSTANCEOF INT INTERFACE LONG NATIVE NEW PACKAGE RETURN SHORT STATIC SUPER SYNCHRONIZED THIS TRANSIENT VAR VOID VOLATILE WHILE WITH NEWLINE ID string WHITESPACE EOFile

%left '*' '/'
%left '+' '-' ','

%%
program
    : eof 
    | sourceElements eof;
    ;

sourceElements
    : sourceElement
    | sourceElements sourceElement
    ;

sourceElement
    : statement
    | functionDeclaration
    ;

statement
    : block
    | variableStatement
    | emptyStatement
    | expressionStatement
    | ifStatement
    | iterationStatement
    | continueStatement
    | breakStatement
    | returnStatement
    | withStatement
    ;

block
    : OpenBrace CloseBrace
    | OpenBrace statementList CloseBrace
    ;

statementList
    : statement
    | statementList statement
    ;

variableStatement
    : VAR variableDeclarationList eos
    ;

variableDeclarationList
    : variableDeclaration
    | variableDeclarationList Comma variableDeclaration
    ;

variableDeclaration
    : Identifier 
    | Identifier initialiser
    ;

initialiser
    : '=' singleExpression
    ;

emptyStatement
    : SemiColon
    ;

expressionStatement
    : expressionSequence
    ;

ifStatement
    : IF OpenParen expressionSequence CloseParen statement eos
    | IF OpenParen expressionSequence CloseParen statement ELSE statement 
    ;

iterationStatement
    : DO statement WHILE OpenParen expressionSequence CloseParen eos                                                 
    | WHILE OpenParen expressionSequence CloseParen statement                                                        
    | FOR OpenParen  SemiColon  SemiColon  OpenParen statement
    | FOR OpenParen expressionSequence SemiColon  SemiColon  CloseParen statement
    | FOR OpenParen expressionSequence SemiColon expressionSequence SemiColon  CloseParen statement
    | FOR OpenParen  SemiColon expressionSequence SemiColon expressionSequence CloseParen statement
    | FOR OpenParen expressionSequence SemiColon expressionSequence SemiColon expressionSequence CloseParen statement
    ;

continueStatement
    : CONTINUE eos
    ;

breakStatement
    : BREAK eos
    ;

returnStatement
    : RETURN expressionSequence eos
    | RETURN eos;
    ;

withStatement
    : WITH OpenParen expressionSequence CloseParen statement
    ;


functionDeclaration
    : FUNCTION Identifier OpenParen CloseParen OpenBrace functionBody CloseBrace
    | FUNCTION Identifier OpenParen formalParameterList CloseParen OpenBrace functionBody CloseBrace
    ;

functionCall
    : FUNCTION OpenParen CloseParen OpenBrace functionBody CloseBrace 
    | FUNCTION OpenParen formalParameterList CloseParen OpenBrace functionBody CloseBrace
    ;

formalParameterList
    : Identifier
    | formalParameterList Comma Identifier
    ;

functionBody
    : sourceElements
    |
    ;

arguments
    : OpenParen CloseParen
    | OpenParen expressionSequence CloseParen
    ;
    
expressionSequence
    : expressionSequence Comma singleExpression eos
    | singleExpression eos
    ;

singleExpression
    : functionCall
    | singleExpression OpenBracket expressionSequence CloseBracket
    | singleExpression Dot identifierName
    | singleExpression arguments
    | singleExpression singleArithmetic
    | DELETE singleExpression eos
    | VOID singleExpression eos
    | singleArithmetic singleExpression eos
    | unaryOps singleExpression eos
    | singleExpression arithmeticOps singleExpression eos
    | singleExpression relop singleExpression eos
    | singleExpression IN singleExpression eos
    | singleExpression INSTANCEOF singleExpression eos
    | singleExpression QuestionMark singleExpression Colon singleExpression eos
    | singleExpression assignmentOperator singleExpression eos
    | THIS
    | Identifier
    | literal
    | OpenParen expressionSequence CloseParen
    ;

literal
    : NullLiteral
    | BooleanLiteral
    | StringLiteral
    | numericLiteral
    ;

StringLiteral
    : string
    ;

numericLiteral
    : num
    ;

reservedWord
    : keyword
    | futureReservedWord
    | NullLiteral
    | BooleanLiteral
    ;

keyword
    : BREAK
    | DO
    | INSTANCEOF
    | CASE
    | ELSE
    | NEW
    | VAR
    | FINALLY
    | RETURN
    | VOID
    | CONTINUE
    | FOR
    | WHILE
    | FUNCTION
    | THIS
    | WITH
    | DEFAULT
    | IF
    | DELETE
    | IN
    ;

NullLiteral
    : NULLType

BooleanLiteral
    : BOOL

Identifier
    : ID

eos
    : SemiColon
    | eof
    | NEWLINE
    | CloseBrace
    ;

eof
    : EOFile
    ;

identifierName
    : Identifier
    | reservedWord
    ;

futureReservedWord
    : CLASS
    | EXTENDS
    | SUPER
    | CONST
    | IMPORT
    | IMPLEMENTS
    | INTERFACE
    | PACKAGE
    | STATIC
    ;

singleArithmetic
    : "++"
    | "--"
    ;

unaryOps
    : '+'
    | '-'
    | '~'
    | '!'
    ;

arithmeticOps
    : unaryOps
    | '*'
    | '/'
    | '%'
    ;

relop
    : ">>"
    | "<<"
    | ">>>"
    | "<"
    | ">"
    | "<="
    | ">="
    | "=="
    | "!="
    | "==="
    | "!=="
    | "&"
    | "^"
    | "|"
    | "&&"
    | "||"

;

assignmentOperator
    : "*="
    | "/="
    | "%="
    | "+="
    | "-="
    | "<<="
    | ">>="
    | ">>>="
    | "&="
    | "^="
    | "|="
    ;

OpenBracket                
    : '['
;

CloseBracket               
    : ']'
;

OpenParen                  
    : '('
;

CloseParen                 
    : ')'
;

OpenBrace                  
    : '{'
;

CloseBrace                 
    : '}'
;

SemiColon                  
    : ';'
;

Comma                      
    : ','
;

QuestionMark               
    : '?'
;

Colon                      
    : ':'
;

Dot                        
    : '.'
;

%%

int main(int argc, char* argv[])
{
    yyin = fopen(argv[1], "r");
    yyout = fopen("lex_out.txt", "w");
    SymTable = (struct SymTabCell*) malloc(maxSize * sizeof(struct NODE));
    init_array();
	yyparse();
    fprintf(yyout, "%s", "\n");
    display();
    return 0;
}

void yyerror()
{
    printf("\nerror\n");
}
