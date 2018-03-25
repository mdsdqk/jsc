#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//implement rehashing!!!

struct NODE* get_element(struct NODE*, char*);
void rehash();
void init_array();
int hashCode(char*, int);
void insert(char*, char*, char*);
int find(struct NODE *,char*);

//structure for each symbol table entry
struct NODE{
    char name[64];
    char type[32];
    char attribute[32];
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

int hashCode(char key[64], int max)
{
  int xlength = strlen(key);

  int sum;
  for (sum=0, i=0; i < xlength; i++)
    sum += key[i];
  return sum % max;
}

void insert(char name[64], char type[32], char attr[32])
{
    //create new item
    struct NODE *item = (struct NODE*) malloc(sizeof(struct NODE));
	strcpy(item -> name, name);
    strcpy(item -> type, type);
	strcpy(item -> attribute, attr);
    item->next = NULL;

    //get index
    int index = hashCode(name, maxSize);

    //get list at found index
    struct NODE* list = (struct NODE*) SymTable[index].head;

    //Check if index-ed location is empty
    if (list == NULL) {
        //no element, assign it to new item

		printf("Inserting %s(name), %s(type) and %s(attribute) \n", name, type, attr);
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

int main()
{
    return 0;
}