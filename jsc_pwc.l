%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <malloc.h>
    #include "y.tab.h"
    //implement rehashing!!!

    struct NODE* get_element(struct NODE*, char*);
    void rehash();
    void init_array();
    int hashCode(char*);
    void insert(int, char*, char*, char*, int, int, char*);
    int find(struct NODE *,char*);
    void display();
    void yyerror(char *)

    //structure for each symbol table entry
    struct NODE{
        int scope;
        char name[64];
        char type[32];
        char attribute[32];
        int line;
        int charnum;
        char value[64];
        struct NODE* next;
    };

    //structure for each cell of Symbol Table
    struct SymTabCell{
        struct NODE* head;
        struct NODE* tail;
    };

    struct SymTabCell* SymTable;

    int presentSize = 0;
    int maxSize = 100;
    float loadFactor = 0.0;
    int i;
    int presentScope = 0;
    int bracks = 0;
    int lineNum = 1;
    int charNum = 1;   
%}

KEYWORD var|function|goto|if|implements|import|in|enum|instanceof|int|interface|long|native|new|package|private|protected|public|return|short|static|super|switch|synchronized|this|throw|throws|transient|try|typeof|var|void|volatile|while|with 

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

    return ("NEWLINE");
}

{BOOL} {
    insert(presentScope, yytext, "LITERAL", "BOOLEAN", lineNum, charNum, yytext);
    printf("%s , BOOLEAN\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return ("BOOL");
}

{NULL} {
    insert(presentScope, yytext, "LITERAL", "NULL", lineNum, charNum, yytext);
    printf("%s , NULL\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return ("NULLType");
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

    return ("COMMENT");
}

{KEYWORD} {
    insert(presentScope, yytext, "KEYWORD", yytext, lineNum, charNum, "NULL");
    printf("%s , KEYWORD\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return (upper(yytext));
}

{ID} {
    insert(presentScope, yytext, "IDENTIFIER", "ID", lineNum, charNum, "NULL");
    printf("%s , IDENTIFIER\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return ("ID");
}

{OPERATOR} {
    //insert(yytext, "OPERATOR", "NULL");
    printf("%s , OPERATOR\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return (yytext);
}

{INT} {
    insert(presentScope, yytext, "LITERAL", "INTEGER", lineNum, charNum, yytext);
    printf("%s , INTEGER\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return ("num");
}

{FLOAT} {
    insert(presentScope, yytext, "LITERAL", "FLOAT", lineNum, charNum, yytext);
    printf("%s , FLOAT\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return ("num");
}


{STRING} {
    insert(presentScope, yytext, "LITERAL", "STRING", lineNum, charNum, yytext);
    printf("%s , STRING\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    return ("string");
}

{SEPERATOR} {
    //insert(yytext, "SEPERATOR", "NULL");
    printf("%s , SEPERATOR\n", yytext);
    fprintf(yyout, "%s", yytext);
    charNum += yyleng;

    if (yytext[0] == '{') {
        presentScope++;
    }

    if (yytext[0] == '}') {
        presentScope--;
    }

    return ("SEPERATOR");
}

{WHITESPACE} {
    //printf("whitespace %s\n", yytext);
    fprintf(yyout, "%s"," ");
    charNum += yyleng;

    return ("WHITESPACE");
}

<<EOF>> {return ("EOFile");}

. {
    printf("Error! No pattern found\n");
    charNum += yyleng;
}
%%

char* upper(char* in)
{
    int i=0;
    while(in[i]){
        putchar (toupper(in[i]));
    }

    return in;
}

void init_array()
{
	for (i = 0; i < maxSize; i++){
		SymTable[i].head = NULL;
		SymTable[i].tail = NULL;
	}
}

int hashCode(char key[64])
{
  int xlength = strlen(key) - 1;

  int sum;
  for(sum=0, i=0; i < xlength; i++){
    sum += key[i];
    //printf("sum, %d", sum);
  }
  return (sum % maxSize);
}

void insert(int scope, char name[64], char type[32], char attr[32], int line, int ch, char value[64])
{
    //create new item
    struct NODE *item = (struct NODE*) malloc(sizeof(struct NODE));
    item -> scope = scope;
	strcpy(item -> name, name);
    strcpy(item -> type, type);
	strcpy(item -> attribute, attr);
    item -> line = line;
    item -> charnum = ch;
    strcpy(item -> value , value);
    item -> next = NULL;

    //get index
    int index = hashCode(name);
    //printf("index, %d\n", index);
    //get list at found index
    struct NODE* list = (struct NODE*) SymTable[index].head;

    //Check if index-ed location is empty
    if (list == NULL) {
        //no element, assign it to new item

		//printf("Inserting %s(name), %s(type) and %s(attribute) \n", name, type, attr);
		SymTable[index].head = item;
		SymTable[index].tail = item;
		presentSize++;
	}

    else {
        //element already present here, check if same item exists
        int find_index = find(list, name);

        if (find_index == -1){
			//Key not found in existing linked list
            //Adding the key at the end of the linked list

		    //printf("Inserting %s(name), %s(type) and %s(attribute) \n", name, type, attr);

			SymTable[index].tail->next = item;
			SymTable[index].tail = item;
			presentSize++;
        }
    /* this code is not yet required - start */
        else{
            //Key already present in linked list
            //check if key is keyword

            struct NODE* temp = SymTable[index].head;

            for(i = 0; i < find_index; i++){
                temp = temp -> next;
            }
            if(temp -> type == "KEYWORD") {}
                //nothing :/
            
            else {}   
                //nothing yet :/
    /* code not reqd - end */
		}
    }
}

int find(struct NODE *list, char key[64])
{
	int retval = 0;
    struct NODE *temp = list;

	while (temp != NULL){
		if (temp->name == key){
            //return index of chain
			return retval;      
		}

  		temp = temp->next;
		retval++;
	}

    //no such element
	return -1;
}

/* To display the contents of Symbol Table */

void display()
{
	int i = 0;

	for (i = 0; i < maxSize; i++) {
		
        struct NODE *temp = SymTable[i].head;

		if (temp == NULL){
			//printf("Symbol Table[%d] has no elements\n", i);
		}
        else{
			printf("\nSymbol Table[%d] has elements-: \n", i);
			while (temp != NULL){
				printf("scope= %d  name= %s  type= %s  attribute= %s  lineNum= %d  charNum= %d  value=%s \n", temp -> scope, temp->name, temp->type, temp->attribute, temp->line, temp->charnum, temp->value);
				temp = temp->next;
			}
			printf("\n");
		}
	}
}