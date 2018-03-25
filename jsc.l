%{
    #include <stdio.h>
%}

KEYWORD var|abstract|boolean|break|byte|case|catch|char|class|const|continue|default|delete|do|double|else|extends|final|finally|float|for|function|goto|if|implements|import|in|instanceof|int|interface|long|native|new|package|private|protected|public|return|short|static|super|switch|synchronized|this|throw|throws|transient|try|typeof|var|void|volatile|while|with 

DIGIT [[:digit:]]

LETTER [[:alpha:]]

SIGN \+|\-

EXP \e|\E

ID (\$|\_|{LETTER})[[:alnum:]]*

WHITESPACE ([ ]|[\t])+

SINGLE_LINE_COMM \/\/.*
MULTI_LINE_COMM  \/\*[^\*\/]*\*\/
COMMENT {SINGLE_LINE_COMM}|{MULTI_LINE_COMM}

BOOL (TRUE|false|true|FALSE)

SINGLE_QUOTE_STR (\')[^\'](\')
DOUBLE_QUOTE_STR (\")[^\"](\")
STRING {SINGLE_QUOTE_STR}|{DOUBLE_QUOTE_STR}

INT {SIGN}?{DIGIT}+

FLOAT ({DIGIT}+\.{DIGIT}*)|(\.{DIGIT}+)|({DIGIT}+{EXP}{SIGN}{DIGIT}+)

SEPERATOR \{|\}|\(|\)\|\[|\]|\;|\,

OPERATOR \+|\*|\/|\=|\-|\+\+|\-\-|\%|\+\=|\-\=|\/\=|\*\=|\%\=|\=\=|\=\=\=|\!\=|\!\=\=|\<|\>|\>\=|\<\=|\&\&|\|\||\!|\&|\||\~|\^|\>\>|\<\<

NULL (null)

%%

{BOOL} {
    printf("boolean, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}

{NULL} {
    printf("null, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}

{COMMENT} {
    printf("comment, %s\n", yytext);
    fprintf(yyout, "%s", "");
}

{KEYWORD} {
    printf("keyword, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}

{ID} {
    printf("identifier, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}

{OPERATOR} {
    printf("operator, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}

{INT} {
    printf("integer, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}

{FLOAT} {
    printf("float, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}


{STRING} {
    printf("string, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}

{SEPERATOR} {
    printf("seperator, %s\n", yytext);
    fprintf(yyout, "%s", yytext);
}

{WHITESPACE} {
    printf("whitespace %s\n", yytext);
    fprintf(yyout, "%s"," ");
}

. {;}
%%

int main(int argc, char* argv[])
{
    yyin = fopen(argv[1], "r");
    yyout = fopen("lex_out.txt", "w");
	yylex();
	yywrap();
    fprintf(yyout, "%s", "\n");

    return 0;
}