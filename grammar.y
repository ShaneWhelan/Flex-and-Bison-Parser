%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

struct variables {
    int idenLength;
    char *idenName;
    struct variables *next;
};

void addIdentifer(int length, char *name);
void printIdentifierList();
void isDeclared(char *idenToCheck);
void validIntAssignment(int a, char *b);
void validIdentifierAssignment(char *a, char *b);
%}

%union {
    int length;
    char *strval;
}

%token T_BEGIN
%token T_END
%token <length> T_INT
%token T_MOVE
%token T_ADD
%token T_TO
%token T_READ
%token T_COMMA
%token T_FULLSTOP
%token T_PRINT
%token T_FOR
%token T_OPAREN
%token T_CPAREN
%token T_STARTFOR
%token T_ENDFOR
%token T_LESSTHAN
%token T_GREATERTHAN
%token T_QMARK
%token T_PLUS
%token T_ASSIGNMENT
%token <length> T_NUMBER
%token T_STRING
%token <strval> T_IDENTIFIER

%%

language: begin declarations statments end;

declarations: /* empty */
    | declarations declaration;

declaration: T_INT T_IDENTIFIER T_FULLSTOP {addIdentifer($1, $2);} ;


statments: /* empty */
    | statments statment;

statment: print-statement 
    | read-statement
    | forloop-statement 
    | move-statement T_FULLSTOP
    | add-statement T_FULLSTOP;

begin: T_BEGIN T_FULLSTOP {};

print-statement: T_PRINT string-statements T_IDENTIFIER T_FULLSTOP {isDeclared($3);}
    | T_PRINT string-statements T_STRING T_FULLSTOP
;

string-statements: /*empty */
    | string-statements string-statement;

string-statement: T_STRING T_COMMA
    | T_IDENTIFIER T_COMMA {isDeclared($1);} ;

read-statement: T_READ read-identifiers T_IDENTIFIER T_FULLSTOP {isDeclared($3);};

read-identifiers: /* empty */
    | read-identifiers read-identifier;

read-identifier: T_IDENTIFIER T_COMMA {isDeclared($1);} ;

forloop-statement: T_FOR
    T_OPAREN 
    assignment-statement T_FULLSTOP
    comparison-statement
    assignment-statement
    T_CPAREN
    startfor-statement
    statments
    endfor-statement { /*CHECK FOR OTHER TYPES OF COMPARISON */};

startfor-statement: T_STARTFOR T_FULLSTOP {} ;

endfor-statement: T_ENDFOR T_FULLSTOP {} ;

assignment-statement: move-statement
    | add-statement;

move-statement: T_MOVE T_NUMBER T_TO T_IDENTIFIER {isDeclared($4); validIntAssignment($2, $4);}
    | T_MOVE T_IDENTIFIER T_TO T_IDENTIFIER {isDeclared($2); isDeclared($4); validIdentifierAssignment($2, $4);}
    ;

add-statement: T_ADD T_NUMBER T_TO T_IDENTIFIER {isDeclared($4); validIntAssignment($2, $4);}
    | T_ADD T_IDENTIFIER T_TO T_IDENTIFIER {isDeclared($2); isDeclared($4); validIdentifierAssignment($2, $4);}
    ;

comparison-statement: num-or-identifier T_LESSTHAN num-or-identifier T_FULLSTOP
    | num-or-identifier T_GREATERTHAN num-or-identifier T_FULLSTOP
    ;

num-or-identifier: T_IDENTIFIER {isDeclared($1);}
    | T_NUMBER;

end: T_END T_FULLSTOP {};

%%

extern int yylineno;
struct variables *firstVar;
int isWellFormed = 1;

main(int argc, char *argv[]) {
    extern FILE *yyin;

    firstVar = malloc(sizeof(struct variables));
    if(!firstVar) {
        fputs("Memory not allocated for list\n", stderr);
        abort();
    }
    firstVar->idenLength = 0;
    firstVar->next = 0;

    if(argc >= 1) {
        yyin = fopen(argv[1], "r");
        
        if(yyin == NULL) {
            fprintf(stderr, "Can't open input file\n");
            return -1;
        }
        yyparse();  
    }

    if(isWellFormed == 1) {
        printf("Well Formed\n\n");
    }else {
        printf("Not Well Formed\n\n");
    }
}

int yywrap() {
    return 1; // No more files return 1
}

void addIdentifer(int length, char *name) {
    struct variables *traverseNode = firstVar;
    if(traverseNode->idenLength != 0) {
        while(traverseNode->next != 0) {
            if(strcmp(traverseNode->idenName, name) == 0) {
                char errorMsg[150];
                sprintf(errorMsg, "Variabe %s is declared already", name);
                yyerror(errorMsg);
            }
            traverseNode = traverseNode->next;
        }
    }

    traverseNode = firstVar;
    if(traverseNode->idenLength != 0) {
        while(traverseNode->next != 0) {
            traverseNode = traverseNode->next;
        }
    }

    traverseNode->idenLength = length;
    traverseNode->idenName = name;
    traverseNode->next = malloc(sizeof(struct variables));
    traverseNode = traverseNode->next;
    traverseNode->idenLength = 0;
    traverseNode->next = 0;
}

int getIdentifierLength(char *name) {
    struct variables *traverseNode = firstVar;

    if(traverseNode->idenLength != 0) {
        while(traverseNode->next != 0) {
            if(strcmp(traverseNode->idenName, name) == 0) { 
                return traverseNode->idenLength;
            }
            traverseNode = traverseNode->next;
        }
    }
    return 0;
}

int getIntLength(int i) {
    int l = 1;
    while(i > 9) { 
        l++; 
        i /= 10; 
    }
    return l;
}

/*
int checkVariableAddition(int destination, int source) {
    int result = destination + source;
    if(getIntLength(result) > getIntLength(destination)) {
        char errorMsg[150];
        sprintf(errorMsg, "The int %d will increase size to length which is longer than declared length.", destination);
        yyerror(errorMsg);
    }
}
*/
void printIdentifierList(){
    struct variables *traverseNode = firstVar;
    if(traverseNode->idenLength != 0) {
        printf("%d %s\n", traverseNode->idenLength, traverseNode->idenName);
        while(traverseNode->next != 0) {
            traverseNode = traverseNode->next;
            printf("%d %s\n", traverseNode->idenLength, traverseNode->idenName);
        }
    }
}

void isDeclared(char *idenToCheck) {
    if(getIdentifierLength(idenToCheck) == 0) {
        char errorMsg[150];
        sprintf(errorMsg, "The identifier %s has not been declared yet.", idenToCheck);
        yyerror(errorMsg);
    }
}

void validIntAssignment(int a, char *b) {
    if(getIntLength(a) > getIdentifierLength(b)) {
        char errorMsg[150];
        sprintf(errorMsg, "The number %d is larger than the declared capacity of %d for the variable %s", a, getIdentifierLength(b) ,b);
        yyerror(errorMsg);
    }
}

void validIdentifierAssignment(char *a, char *b) {
    if(getIdentifierLength(a) > getIdentifierLength(b)) {
        char errorMsg[150];
        sprintf(errorMsg, "The variable %s has a declared capacity of %d, the variable %s has a smaller capacity of %d", a, getIdentifierLength(a) , b, getIdentifierLength(b));
        yyerror(errorMsg);
    }
}

yyerror(const char *str) {
    printf("line: %d, error: %s\n\n", yylineno, str);
    isWellFormed = 0;
}