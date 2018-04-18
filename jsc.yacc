%{
    #include "COMMON.h"
    #define YYSTYPE char*
    extern FILE* yyin;
    extern FILE* yyout;
    FILE* threeadd;

    int yylex(void);
    void yyerror(const char *);

    int yydebug=1;
%}

%token num NULLType BOOL BREAK CASE CHAR CLASS CONST COMMENT CONTINUE DEFAULT DELETE DO DOUBLE ELSE FLOAT FOR FUNCTION GOTO IF IMPORT IN INSTANCEOF INT LONG NEW RETURN STATIC SUPER SYNCHRONIZED THIS VAR VOID WHILE WITH NEWLINE ID string EOFile ADD MUL DIV EQ SUB INC DEC MODU EQADD EQSUB EQDIV EQMUL COMP TYPECOMP NOTEQ LT GT GTEQ LTEQ AND OR NOT RIGHTSHIFT LEFTSHIFT 

%left '*' '/'
%left '+' '-' ','
%define parse.error verbose

%%
program
    : eof 
    | sourceElements {
        fprintf(threeadd, "%s\n", "x = 43  \n\
function fun \n\
BEGIN 30  \n\
z = 1 - 2  \n\
end function  \n\
y = 1  \n\
L1: if TRUE goto L2  \n\
goto L3  \n\
L2: i = 0  \n\
goto L1  \n\
L3: if TRUE goto L4  \n\
L4: a = TRUE \
");} eof 
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
    | COMMENT
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
    : EQ singleExpression
    ;

emptyStatement
    : SemiColon
    ;

expressionStatement
    : expressionSequence
    ;

ifStatement
    : IF OpenParen singleExpression CloseParen statement eos {/*fprintf(threeadd, "%s", $3);*/}
    | IF OpenParen expressionSequence CloseParen statement ELSE statement 
    ;

iterationStatement
    : DO statement WHILE OpenParen expressionSequence CloseParen eos                                                 
    | WHILE OpenParen singleExpression CloseParen statement                                                
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
    | singleExpression eos { $$ = $1; }
    ;

singleExpression
    : functionCall
    | singleExpression OpenBracket expressionSequence CloseBracket
    | singleExpression Dot identifierName
    | singleExpression arguments
    | singleExpression singleArithmetic
    | DELETE singleExpression eos
    | VOID singleExpression eos
    | singleArithmetic singleExpression eos { /*$$ = $1 $2;*/ }
    | unaryOps singleExpression eos {//$$ = $1 $2; 
                                        }
    | singleExpression arithmeticOps singleExpression eos {/*printf("%s\n", $2);*/ }
    | singleExpression relop singleExpression eos { /*$$ = $1 $2 $3;*/ }
    | singleExpression IN singleExpression eos
    | singleExpression INSTANCEOF singleExpression eos
    | singleExpression QuestionMark singleExpression Colon singleExpression eos
    | singleExpression assignmentOperator singleExpression eos
    | THIS
    | Identifier
    | literal {$$ = $1;}
    | OpenParen expressionSequence CloseParen
    ;

literal
    : NullLiteral {$$ = $1;}
    | BooleanLiteral
    | StringLiteral
    | numericLiteral {$$ = $1;}
    ;

StringLiteral
    : string
    ;

numericLiteral
    : num  {$$ = $1; /*fprintf(threeadd, "%c\n", $1);*/}
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
    : NULLType { $$ = "NULL"; }
    ;

BooleanLiteral
    : BOOL  { $$ = $1; }
    ;

Identifier
    : ID
    ;

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
    | SUPER
    | CONST
    | IMPORT
    | STATIC
    ;

singleArithmetic
    : INC   { $$ = $1; }
    | DEC   { $$ = $1; }
    ;

unaryOps
    : ADD   { $$ = $1; }
    | SUB   { $$ = $1; }
    | NOT   { $$ = $1; }
    ;

arithmeticOps
    : unaryOps
    | MUL   { $$ = $1; }
    | DIV   { $$ = $1; }
    | MODU   { $$ = $1; }
    ;

relop
    : RIGHTSHIFT  { $$ = $1;
                    printf("%s", $1); }
    | LEFTSHIFT   { $$ = $1; }
    | LT          { $$ = $1;
                    printf(" yooo %s", $1); }
    | GT   { $$ = $1; }
    | LTEQ   { $$ = $1; }
    | GTEQ   { $$ = $1; }
    | COMP  { $$ = $1; }
    | NOTEQ   { $$ = $1; }
    | TYPECOMP   { $$ = $1; }
    | AND   { $$ = $1; }
    | OR   { $$ = $1; }
;

assignmentOperator
    : EQMUL  { $$ = $1; }
    | EQDIV  { $$ = $1; }
    | EQADD  { $$ = $1; }
    | EQSUB  { $$ = $1; }
    | EQ     { fprintf(threeadd, "%s", $1);  }   
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
    threeadd = fopen("threeAddr.txt", "w");

    SymTable = (struct SymTabCell*) malloc(maxSize * sizeof(struct NODE));
    init_array();
	yyparse();
    fprintf(yyout, "%s", "\n");
    display();
    return 0;
}

void yyerror(s)
    const char *s;
{
    printf("%s\n", s);
}
