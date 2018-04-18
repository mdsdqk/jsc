#include "COMMON.h"

int i;
int presentSize = 0;
int maxSize = 100;
float loadFactor = 0.0;
int presentScope = 0;
int bracks = 0;
int lineNum = 1;
int charNum = 1;  

void init_array()
{
	for (i = 0; i < maxSize; i++){
		SymTable[i].head = NULL;
		SymTable[i].tail = NULL;
	}

   // addKeywords();
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
/*
void addKeywords()
{
    insert(0,"var","KEYWORD",NULL,0,0,NULL);
    insert(0,"function","KEYWORD",NULL,0,0,NULL);
    insert(0,"goto","KEYWORD",NULL,0,0,NULL);
    insert(0,"if","KEYWORD",NULL,0,0,NULL);
    insert(0,"implements","KEYWORD",NULL,0,0,NULL);
    insert(0,"import","KEYWORD",NULL,0,0,NULL);
    insert(0,"in","KEYWORD",NULL,0,0,NULL);
    insert(0,"enum","KEYWORD",NULL,0,0,NULL);
    insert(0,"instanceof","KEYWORD",NULL,0,0,NULL);
    insert(0,"int","KEYWORD",NULL,0,0,NULL);
    insert(0,"interface","KEYWORD",NULL,0,0,NULL);
    insert(0,"long","KEYWORD",NULL,0,0,NULL);
    insert(0,"native","KEYWORD",NULL,0,0,NULL);
    insert(0,"new","KEYWORD",NULL,0,0,NULL);
    insert(0,"package","KEYWORD",NULL,0,0,NULL);
    insert(0,"private","KEYWORD",NULL,0,0,NULL);
    insert(0,"protected","KEYWORD",NULL,0,0,NULL);
    insert(0,"public","KEYWORD",NULL,0,0,NULL);
    insert(0,"return","KEYWORD",NULL,0,0,NULL);
    insert(0,"short","KEYWORD",NULL,0,0,NULL);
    insert(0,"static","KEYWORD",NULL,0,0,NULL);
    insert(0,"super","KEYWORD",NULL,0,0,NULL);
    insert(0,"switch","KEYWORD",NULL,0,0,NULL);
    insert(0,"synchronized","KEYWORD",NULL,0,0,NULL);
    insert(0,"this","KEYWORD",NULL,0,0,NULL);
    insert(0,"throw","KEYWORD",NULL,0,0,NULL);
    insert(0,"throws","KEYWORD",NULL,0,0,NULL);
    insert(0,"transient","KEYWORD",NULL,0,0,NULL);
    insert(0,"try","KEYWORD",NULL,0,0,NULL);
    insert(0,"typeof","KEYWORD",NULL,0,0,NULL);
    insert(0,"var","KEYWORD",NULL,0,0,NULL);
    insert(0,"void","KEYWORD",NULL,0,0,NULL);
    insert(0,"volatile","KEYWORD",NULL,0,0,NULL);
    insert(0,"while","KEYWORD",NULL,0,0,NULL);
    insert(0,"with","KEYWORD",NULL,0,0,NULL);
}*/
/*
char* isKeyword(char* id)
{
    char *s = id;

    if(find(SymTable, s) != 0){
        upper(s);
        return s;
    }

    return NULL;
}
*/

void upper(char* in)
{
    int i=0;
    while(in[i]){
        in[i] = toupper(in[i]);
        i++;
    }
}