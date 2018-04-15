#include <stdio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>


struct NODE* get_element(struct NODE*, char*);
void rehash();
void init_array();
int hashCode(char*);
void insert(int, char*, char*, char*, int, int, char*);
int find(struct NODE *,char*);
void display();

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
int presentScope = 0;
int bracks = 0;
int lineNum = 1;
int charNum = 1;   