%{
    #include "y.tab.h"
    #include "COMMON.h"
    #define YYSTYPE char*
    
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
    insert(presentScope, yytext, "LITERAL", "BOOLEAN", lineNum, charNum, yytext);
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

{KEYWORD} {
    //insert(presentScope, yytext, "KEYWORD", yytext, lineNum, charNum, "NULL");
    
    upper(yytext);
    //printf("%s , KEYWORD\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return *(yytext);
}

{ID} {
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;
    insert(presentScope, yytext, "IDENTIFIER", "ID", lineNum, charNum, "NULL");
    //printf("%s, IDENTIFIER\n", yytext);
    return ID;
}

{OPERATOR} {
    //insert(yytext, "OPERATOR", "NULL");
    //printf("%s , OPERATOR\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return *yytext;
}

{INT} {
    insert(presentScope, yytext, "LITERAL", "INTEGER", lineNum, charNum, yytext);
    //printf("%s , INTEGER\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return num;
}

{FLOAT} {
    insert(presentScope, yytext, "LITERAL", "FLOAT", lineNum, charNum, yytext);
    //printf("%s , FLOAT\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return num;
}


{STRING} {
    insert(presentScope, yytext, "LITERAL", "STRING", lineNum, charNum, yytext);
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

    return WHITESPACE;
}

<<EOF>> {return EOFile;}

. {
    perror("Error! No pattern found\n");
    charNum += yyleng;
}
%%
