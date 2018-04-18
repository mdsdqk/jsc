%{
    #include "y.tab.h"
    #include "COMMON.h"
    #define YYSTYPE char*
    extern FILE* threeadd;
    
    void upper(char *);
%}

KEYWORD var|function|if|import|in|enum|instanceof|int|long|return|short|static|super|switch|synchronized|this|typeof|void|while|with 

DIGIT [[:digit:]]

LETTER [[:alpha:]]

SIGN \+|\-

EXP \e|\E

ID (\$|\_|{LETTER})[[:alnum:]]*

WHITESPACE ([ ]|[\t])+

NEWLINE \r|\r\n|\n

SINGLE_LINE_COMM \/\/.*[\n]
MULTI_LINE_COMM  \/\*[^\*\/]*\*\/[\n]
COMMENT {SINGLE_LINE_COMM}|{MULTI_LINE_COMM}

BOOL (TRUE|false|true|FALSE)

SINGLE_QUOTE_STR (\')[^\'](\')
DOUBLE_QUOTE_STR (\")[^\"](\")
STRING {SINGLE_QUOTE_STR}|{DOUBLE_QUOTE_STR}

INT {SIGN}?{DIGIT}+

FLOAT ({DIGIT}+\.{DIGIT}*)|(\.{DIGIT}+)|({DIGIT}+{EXP}{SIGN}{DIGIT}+)

SEPERATOR \{|\}|\(|\)|\[|\]|\;|\,

OPERATOR \+|\*|\/|\=|\-|\+\+|\-\-|\%|\+\=|\-\=|\/\=|\*\=|\%\=|\=\=|\=\=\=|\!\=|\!\=\=|\<|\>|\>\=|\<\=|\&\&|\|\||\!|\&|\||\~|\^|\>\>|\<\<

NULL (null|NULL)

%%

{NEWLINE} {
    charNum = 1;
    lineNum++;

    return NEWLINE;
}

{BOOL} {
    //insert(presentScope, yytext, "LITERAL", "BOOLEAN", lineNum, charNum, yytext);
    //printf("%s , BOOLEAN\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return BOOL;
}

{NULL} {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    //printf("%s , NULL\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return NULLType;
}

{COMMENT} {
    //printf("comment, %s\n", yytext);
    //fprintf(yyout, "%s", "\b");
    charNum += yyleng;
    int i;
    for (i = 0; i < yyleng; i++){
        if(yytext[i] == '\n'){
            charNum = 1;
            lineNum++;
        }
    }

    return COMMENT;
}

do {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return DO;
}
function  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return FUNCTION;
}
if  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return IF;
}
var  {
    //insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return VAR;
}
import  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return IMPORT;
}
in  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return IN;
}
int  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return INT;
}
long  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return LONG;
}
return  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return RETURN;
}
static  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return STATIC;
}
void  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return VOID;
}
while  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return WHILE;
}
with  {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return WITH;
}

{ID} {
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    insert(presentScope, yytext, "IDENTIFIER", "ID", lineNum, charNum, "NULL");
    //printf("%s, IDENTIFIER\n", yytext);
    return ID;
}

\+ {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return ADD;
}
\* {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return MUL;
}
\/ {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return DIV;
}
\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return EQ;
}
\- {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return SUB;
}
\+\+ {
    yylval = *(yytext);
    charNum += yyleng;
    return INC;
}
\-\- {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return DEC;
}
\% {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return MODU;
}
\+\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return EQADD;
}
\-\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return EQSUB;
}
\/\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return EQDIV;
}
\*\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return EQMUL;
}
\=\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return COMP;
}
\=\=\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return TYPECOMP;
}
\!\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return NOTEQ;
}
\< {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return LT;
}
\> {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return GT;
}
\>\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return GTEQ;
}
\<\= {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return LTEQ;
}
\&\& {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return AND;
}
\|\| {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return OR;
}
\! {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return NOT;
}
\>\> {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return RIGHTSHIFT;
}
\<\< {
    yylval = *(yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    return LEFTSHIFT;
}

{INT} {
    //fprintf(threeadd, "%s , INTEGER\n", yytext);
    //fprintf(yyout, "%s", yytext);
    ECHO;
    charNum += yyleng;
    yylval = atoi(yytext);
    return num;
}

{FLOAT} {
    //printf("%s , FLOAT\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return num;
}


{STRING} {
    //insert(presentScope, yytext, "LITERAL", "STRING", lineNum, charNum, yytext);
    //printf("%s , STRING\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return string;
}

{SEPERATOR} {
    //insert(yytext, "SEPERATOR", "NULL");
    //printf("%s , SEPERATOR\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    if (yytext[0] == '{') {
        presentScope++;
    }

    if (yytext[0] == '}') {
        presentScope--;
    }

    return *yytext;
}

{WHITESPACE} {
    //printf("whitespace %s\n", yytext);
    fprintf(yyout, "%s"," ");
    charNum += yyleng;

    //return WHITESPACE;
}

<<EOF>> {return EOFile;}

. {
    perror("Error! No pattern found\n");
    charNum += yyleng;
}
%%
