%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


    typedef struct node {
   	 char *token;
   	 struct node *left;
   	 struct node *right;
    } node;
    node* mknode(char* token, node *left, node *right);
    void Printtree(node *tree);
    void printTabs(int n);
    int yylex();
    extern int yylineno;
    extern char *yytext;
    int yyerror(char *e);
    int printlevel = 0;
    extern char* yytext;
%}

%union {
    struct node *node;
    char *string;
}

%token <string> WHILE DO IF ELSE FOR COMMENT
%token <string> RETURN ARGS
%token <string> BOOL STRING PTRCHAR CHAR INT DOUBLE FLOATLTL PTRINT PTRDOUBLE PTRFLOAT
%token <string> OPRAND OPRADDRESS OPREQL OPRASSIGNMENT OPROR LENGTH OPRGREATEREQL OPRGREATER OPRLESSEQL OPRLESS OPRNOTEQL OPRNOT OPRTO
%token <string> OPRDIVISION OPRPLUS OPRMINUS OPRMULTI VARIABLE INTLTL DECIMAL
%token <string> REALLTL ONECHAR NULLTOKEN REAL FLOAT MY_NULL STRINGLTL
%token <string> MAIN VOID PUBLIC PRIVATE STATIC IDENTIFIER SEMICOLON COMMA OPENPAREN CLOSEPAREN OPENBRACKET CLOSEBRACKET OPENBRACE CLOSEBRACE
%token <string> HEX TRUEBOOL FALSEBOOL COLON

%left OPRPLUS OPRMINUS
%left OPRMULTI OPRDIVISION
%left OPREQL OPRNOTEQL OPRLESS OPRLESSEQL OPRGREATER OPRGREATEREQL OPROR OPRAND
%right OPRNOT

%type <node> Whole
%type <node> program
%type <node> main
//%type <node> funcs_declars
%type <node> state
%type <node> procedures
%type <node> procedure
%type <node> func_access
%type <node> func_body
%type <node> declars
%type <node> declar
%type <node> stringVar
%type <node> stringVars
%type <node> stringVar1
%type <node> identifiers
%type <node> identifier
%type <node> oneidentifier
%type <node> arguments
%type <node> params
%type <node> more_params
%type <node> args
%type <node> type
%type <node> ret
%type <node> stmnts
%type <node> stmnt
%type <node> call_func
%type <node> assign
%type <node> forExp
%type <node> update
%type <node> exps
%type <node> arithmeticExp
%type <node> exp
%type <node> cmnt
%%

Whole: cmnt program { Printtree($2); printf("syntax valid\n"); };

program: procedures { $$ = mknode("CODE", $1, NULL); };

cmnt: COMMENT cmnt { $$ = mknode("COMMENT", mknode($1, NULL, NULL), $2); }
    | { $$ = NULL; };

main: PUBLIC type MAIN OPENPAREN CLOSEPAREN COLON state OPENBRACE func_body CLOSEBRACE {
    $$ = mknode("public", mknode("Main", mknode("", $7, NULL), NULL), mknode("body", NULL, $9));}
    | { $$ = NULL; };

state: STATIC { $$ = mknode("Static", NULL, NULL); }
    | { $$ = mknode("Nonstatic", NULL, NULL); };

procedures:  procedure procedures { $$ = mknode("", $1, $2); }
    | { $$ = NULL; };

procedure: func_access type IDENTIFIER OPENPAREN arguments CLOSEPAREN COLON state cmnt OPENBRACE     func_body CLOSEBRACE {$$ = mknode("func", mknode($3, $1, mknode("ARGS", $5, mknode("return", $8, NULL))), mknode("", $11, NULL));}
    |func_access type MAIN OPENPAREN arguments CLOSEPAREN COLON state cmnt OPENBRACE func_body CLOSEBRACE  {$$ = mknode("MAIN", mknode("", mknode("", $1, $2), NULL), mknode("body", NULL, $11));};
    

func_access: PRIVATE { $$ = mknode("private", NULL, NULL); }
    | PUBLIC { $$ = mknode("public", NULL, NULL); };
    
func_body: cmnt declars procedures stmnts ret {
    $$ = mknode("(BODY\n", mknode("", $2, NULL), mknode("", $3, mknode("", $4, mknode("}", NULL, NULL))));
};

arguments: ARGS params  { $$ = mknode("ARGS", $2, NULL); }
    | { $$ = NULL; };
    
params: type COLON args more_params { $$ = mknode("params", $1, $4); }
    | { $$ = NULL; };

more_params: more_params type COLON args { $$ = mknode("params", $1, $4); }
    | { $$ = NULL; }
    | IDENTIFIER { $$ = NULL; };

args: IDENTIFIER COMMA args { $$ = mknode("args", mknode($1, NULL, NULL), $3); }
    | IDENTIFIER SEMICOLON{ $$ = mknode("args", mknode($1, NULL, NULL), NULL); }
    | { $$ = NULL; }|
    IDENTIFIER { $$ = NULL; };
    

//funcs_declars: IDENTIFIER OPENPAREN declars CLOSEPAREN| ;

declars: declars  declar { $$ = mknode("", $1, $2); }
    | { $$ = NULL; };

declar: VARIABLE type COLON oneidentifier SEMICOLON { $$ = mknode("var", $2, mknode("",$4, NULL)); }
    | STRING stringVar { $$ = mknode($1, $2, NULL); };

identifiers: oneidentifier IDENTIFIER  { $$ = mknode("", $1, mknode($2,NULL, NULL)); }
    | IDENTIFIER OPRTO exp  { $$ = mknode("", mknode($1, NULL, NULL), NULL); }
    | IDENTIFIER OPRASSIGNMENT exp  { $$ = mknode($1, $3, NULL); }
    |IDENTIFIER OPRASSIGNMENT exp  { $$ = mknode($1, $3, NULL); };


identifier: oneidentifier identifier  { $$ = mknode("", $1, $2); }
    | { $$ = NULL; };

oneidentifier: IDENTIFIER COMMA oneidentifier{ $$ = mknode($1, NULL, NULL); }
    | IDENTIFIER OPRASSIGNMENT exp COMMA oneidentifier { $$ = mknode($1, $3, NULL); }
    | IDENTIFIER OPRTO exp COMMA oneidentifier{ $$ = mknode($1, $3, NULL); }
    | IDENTIFIER{ $$ = NULL; }
    | IDENTIFIER OPRTO exp  { $$ = mknode("", mknode($1, NULL, NULL), NULL); }
    | IDENTIFIER OPRASSIGNMENT exp  { $$ = mknode($1, $3, NULL); }
    | IDENTIFIER OPRASSIGNMENT exp  { $$ = mknode($1, $3, NULL); };

    
stringVar: stringVars IDENTIFIER OPENBRACKET INTLTL CLOSEBRACKET OPRTO STRING SEMICOLON { $$ = mknode("", $1, mknode($2, mknode("[", mknode($4, NULL, NULL), mknode("]", NULL, NULL)), mknode($7, NULL, NULL))); }
    | stringVars IDENTIFIER OPENBRACKET INTLTL CLOSEBRACKET SEMICOLON { $$ = mknode("", $1, mknode($2, mknode("[", mknode($4, NULL, NULL), mknode("]", NULL, NULL)),mknode("]", NULL, NULL))); };

stringVars: stringVars stringVar1 { $$ = mknode("", $1, $2); }
    | { $$ = NULL; };

stringVar1: IDENTIFIER OPENBRACKET arithmeticExp CLOSEBRACKET OPRTO exp COMMA { $$ = mknode($1, mknode($2, $3, mknode($4, NULL, NULL)), mknode($5, $6, NULL)); }
    | IDENTIFIER OPENBRACKET arithmeticExp CLOSEBRACKET COMMA { $$ = mknode($1, mknode("[", $3, mknode("]", NULL, NULL)), NULL); };





type: BOOL { $$ = mknode("boolean", NULL, NULL); }
    | STRING { $$ = mknode("string", NULL, NULL); }
    | CHAR { $$ = mknode("char", NULL, NULL); }
    | INT { $$ = mknode("int", NULL, NULL); }
    | DOUBLE { $$ = mknode("double", NULL, NULL); }
    | PTRINT { $$ = mknode("int*", NULL, NULL); }
    | PTRCHAR { $$ = mknode("char*", NULL, NULL); }
    | FLOAT { $$ = mknode("int", NULL, NULL); }
    | PTRDOUBLE { $$ = mknode("double*", NULL, NULL); }
    | VOID { $$ = mknode("void*", NULL, NULL); };


ret: RETURN exp SEMICOLON cmnt { $$ = mknode("return", $2, NULL); }
    | { $$ = NULL; };

stmnts: stmnts stmnt { $$ = mknode("", $1, $2); }
    | { $$ = NULL; };

stmnt: OPENBRACE func_body CLOSEBRACE { $$ = mknode("", $2, NULL); }
    | assign { $$ = mknode("ASSIGN", $1, NULL); }
    | IF OPENPAREN exp CLOSEPAREN stmnt SEMICOLON { $$ = mknode("IF", mknode("(", $3, mknode(")", NULL, NULL)), $5); }
    | IF OPENPAREN exp CLOSEPAREN OPENBRACE func_body CLOSEBRACE { $$ = mknode("IF", mknode("(", $3, mknode(")", NULL, NULL)), mknode("BLOCK", $6, NULL)); }
    | IF OPENPAREN exp CLOSEPAREN stmnt SEMICOLON ELSE stmnt SEMICOLON { $$ = mknode("IF-ELSE", mknode("(", $3, mknode(")", NULL, NULL)), mknode("BLOCK", $5, $8)); }
    | IF OPENPAREN exp CLOSEPAREN OPENBRACE func_body CLOSEBRACE ELSE stmnt SEMICOLON { $$ = mknode("IF-ELSE", mknode("(", $3, mknode(")", NULL, NULL)), mknode("BLOCK", $6, $9)); }
    | IF OPENPAREN exp CLOSEPAREN stmnt SEMICOLON ELSE OPENBRACE func_body CLOSEBRACE { $$ = mknode("IF-ELSE", mknode("(", $3, mknode(")", NULL, NULL)), mknode("BLOCK", $5, mknode("BLOCK", $9, NULL))); }
    | IF OPENPAREN exp CLOSEPAREN OPENBRACE func_body CLOSEBRACE ELSE OPENBRACE func_body CLOSEBRACE { $$ = mknode("IF-ELSE", mknode("(", $3, mknode(")", NULL, NULL)), mknode("BLOCK", $6, mknode("BLOCK", $10, NULL))); }
    | WHILE OPENPAREN exp CLOSEPAREN OPENBRACE func_body CLOSEBRACE { $$ = mknode("WHILE", mknode("(", $3, mknode(")", NULL, NULL)), mknode("BLOCK", $6, NULL)); }
    | WHILE OPENPAREN exp CLOSEPAREN OPENBRACE stmnt CLOSEBRACE { $$ = mknode("WHILE", mknode("(", $3, mknode(")", NULL, NULL)), $6); }
    | DO OPENBRACE func_body CLOSEBRACE WHILE OPENPAREN exp CLOSEPAREN SEMICOLON { $$ = mknode("DO-WHILE", mknode("BLOCK", $3, NULL), mknode("(", $7, mknode(")", NULL, NULL))); }
    | FOR OPENPAREN forExp CLOSEPAREN OPENBRACE func_body CLOSEBRACE { $$ = mknode("FOR", $3, $6); }
    | FOR OPENPAREN forExp CLOSEPAREN OPENBRACE stmnt CLOSEBRACE { $$ = mknode("FOR", $3, $6); }
    | call_func SEMICOLON { $$ = mknode("FunctionCall", $1, NULL); };

call_func: IDENTIFIER OPENPAREN CLOSEPAREN { $$ = mknode($1, NULL, NULL); }
    | IDENTIFIER OPENPAREN exps CLOSEPAREN { $$ = mknode($1, $3, NULL); };

assign: IDENTIFIER OPRTO exp SEMICOLON { $$ = mknode($1, $3, NULL); }
    | IDENTIFIER OPRTO OPRADDRESS IDENTIFIER SEMICOLON { $$ = mknode("ADDRESSTO", mknode($3, NULL, NULL), mknode($4, NULL, NULL)); }
    | OPRADDRESS IDENTIFIER OPRTO IDENTIFIER SEMICOLON{ $$ = mknode("ADDRESSFROM", mknode($2, NULL, NULL), mknode($4, NULL, NULL)); }
    | IDENTIFIER OPRTO IDENTIFIER     OPRMULTI SEMICOLON{ $$ = mknode("CONTENT", mknode($1, NULL, NULL), mknode($3, NULL, NULL)); }
    | OPRMULTI IDENTIFIER OPRTO IDENTIFIER SEMICOLON{ $$ = mknode("ADDCONTENTVAR", mknode($2, NULL, NULL), mknode($4, NULL, NULL)); }
    | OPRMULTI IDENTIFIER OPRTO INTLTL SEMICOLON{ $$ = mknode("ADDCONTENTNUM", mknode($2, NULL, NULL), mknode($4, NULL, NULL)); }
    | IDENTIFIER OPENBRACKET INTLTL CLOSEBRACKET OPRTO ONECHAR SEMICOLON { $$ = mknode("ARRCHAR", mknode($1, NULL, NULL), mknode("INDEX-CHAR", mknode($3, NULL, NULL), mknode($6, NULL, NULL))); }
    | IDENTIFIER OPRTO IDENTIFIER OPRMULTI OPRMULTI SEMICOLON { $$ = mknode("DOUBLECONTENT", mknode($1, NULL, NULL), mknode($3, NULL, NULL)); }
    | IDENTIFIER OPRTO call_func SEMICOLON{ $$ = mknode("function", mknode($1, NULL, NULL), $3); };


forExp: IDENTIFIER OPRTO REALLTL SEMICOLON exp SEMICOLON IDENTIFIER update {
    $$ = mknode("FOR-EXP", mknode("INIT", mknode($1, mknode($3, NULL, NULL), NULL), NULL), mknode("EXP", $5, mknode("UPDATE", mknode($7, NULL, NULL), NULL)));
};

update: OPRTO IDENTIFIER OPRMINUS INTLTL { $$ = mknode($2, mknode($3, NULL, NULL), mknode($4, NULL, NULL)); }
    | OPRTO IDENTIFIER OPRPLUS INTLTL { $$ = mknode($3, mknode($2, NULL, NULL), mknode($4, NULL, NULL)); };
    | OPRTO IDENTIFIER OPRMULTI INTLTL { $$ = mknode($3, mknode($2, NULL, NULL), mknode($4, NULL, NULL)); };
    | OPRTO IDENTIFIER OPRDIVISION INTLTL { $$ = mknode($3, mknode($2, NULL, NULL), mknode($4, NULL, NULL)); };

exps: exps COMMA exp { $$ = mknode(" ", $1, $3); }
    | exp { $$ = $1; };

arithmeticExp: exp OPRPLUS exp { $$ = mknode("+", $1, $3); }
    | exp OPRMINUS exp { $$ = mknode("-", $1, $3); }
    | exp OPRMULTI exp { $$ = mknode("*", $1, $3); }
    | exp OPRDIVISION exp { $$ = mknode("/", $1, $3); }
    | REALLTL { $$ = mknode($1, NULL, NULL); };

exp: exp OPRPLUS exp { $$ = mknode("+", $1, $3); }
    | exp OPRMINUS exp { $$ = mknode("-", $1, $3); }
    | exp OPRMULTI exp { $$ = mknode("*", $1, $3); }
    | exp OPRDIVISION exp { $$ = mknode("/", $1, $3); }
    | exp OPRAND exp { $$ = mknode("&&", $1, $3); }
    | exp OPROR exp { $$ = mknode("||", $1, $3); }
    | exp OPREQL exp { $$ = mknode("==", $1, $3); }
    | exp OPRGREATER exp { $$ = mknode(">", $1, $3); }
    | exp OPRGREATEREQL exp { $$ = mknode(">=", $1, $3); }
    | exp OPRLESS exp { $$ = mknode("<", $1, $3); }
    | exp OPRLESSEQL exp { $$ = mknode("<=", $1, $3); }
    | exp OPRNOT exp { $$ = mknode("!", $1, NULL); }
    | exp OPRASSIGNMENT exp { $$ = mknode("=", $1, $3); }
    | exp OPRNOTEQL exp { $$ = mknode("!=", $1, $3); }
    | exp OPRTO exp { $$ = mknode("->", $1, $3); }
    | LENGTH IDENTIFIER LENGTH { $$ = mknode("LENGTH", mknode($1, NULL, NULL), NULL); }
    | REALLTL { $$ = mknode($1, NULL, NULL); }
    | HEX { $$ = mknode($1, NULL, NULL); }
    | ONECHAR { $$ = mknode($1, NULL, NULL); }
    | TRUEBOOL { $$ = mknode($1, NULL, NULL); }
    | FALSEBOOL { $$ = mknode($1, NULL, NULL); }
    | IDENTIFIER { $$ = mknode($1, NULL, NULL); }
    | DOUBLE { $$ = mknode($1, NULL, NULL); }
    | FLOATLTL { $$ = mknode($1, NULL, NULL); }
    | STRING { $$ = mknode($1, NULL, NULL); }
    | OPENPAREN exp CLOSEPAREN { $$ = $2; }
    | IDENTIFIER OPENBRACKET exp CLOSEBRACKET { $$ = mknode("INDEX", mknode($1, NULL, NULL), $3); }
    | NULLTOKEN { $$ = mknode("NULL", NULL, NULL); }
    | OPRADDRESS { $$ = mknode("&", NULL, NULL); }
    | INTLTL { $$ = mknode($1, NULL, NULL); }
    | DECIMAL { $$ = mknode($1, NULL, NULL); };

%%



node* mknode(char *token, node *left, node *right) {
    node *newnode = (node*)malloc(sizeof(node));
    newnode->left = left;
    newnode->right = right;
    newnode->token = token;
    return newnode;
}

void printTabs(int n) {
    for (int i = 0; i < n; i++) {
   	 printf(" "); // 4 spaces per tab
    }
}
void Printtree(node *tree) {
	static int printlevel = 0;
	if (tree == NULL) return;

	int flag = 0; // Default flag value
	printTabs(printlevel);

	// Handle special cases
	if (strcmp(tree->token, "var") == 0) {
    	printf("(DECLARE ");
    	flag = 2;
	} else if (strcmp(tree->token, "if") == 0) {
    	printf("(IF\n");
    	flag = 1;
	} else if (strcmp(tree->token, "while") == 0) {
    	printf("(WHILE\n");
    	flag = 1;
	} else if (strcmp(tree->token, "for") == 0) {
    	printf("(FOR\n");
    	flag = 1;
	} else if (strcmp(tree->token, "func") == 0 || strcmp(tree->token, "proc") == 0 || strcmp(tree->token, "CODE") == 0 || strcmp(tree->token, "Call func") == 0) {
    	printf("(%s \n", tree->token);
    	flag = 2;
	} else if (strcmp(tree->token, "ARGS") == 0) {
    	printf("(ARGS ");
    	if (tree->left) {
        	flag = 2;
        	printf("\n");
    	} else {
        	printf(" NONE)\n");
    	}
	} else if (strcmp(tree->token, "if-else") == 0) {
    	printf("(IF-ELSE\n");
    	printlevel--;
    	flag = 1;
	} else if (strcmp(tree->token, "return") == 0) {
    	printf("(RET ");
    	flag = 2;
	} else if (strcmp(tree->token, "{") == 0) {
    	printf("(BLOCK\n");
	} else if (strcmp(tree->token, "}") == 0) {
    	printf(")\n");
	} else if (strcmp(tree->token, "") == 0) {
    	// Do nothing
	} else if (strcmp(tree->token, "(") == 0) {
    	printf("(");
	} else if (strcmp(tree->token, "\n") == 0) {
    	printf("\n");
	} else if (strcmp(tree->token, ")") == 0) {
    	printf(")");
	} else if (strcmp(tree->token, ",") == 0) {
    	printf(",");
	} else if (strcmp(tree->token, ";") == 0) {
    	printf(";");
	} else if (strcmp(tree->token, "&&") == 0 || strcmp(tree->token, "/") == 0 || strcmp(tree->token, "=") == 0 || strcmp(tree->token, "==") == 0 || strcmp(tree->token, ">") == 0 || strcmp(tree->token, ">=") == 0 || strcmp(tree->token, "<") == 0 || strcmp(tree->token, "<=") == 0 || strcmp(tree->token, "-") == 0 || strcmp(tree->token, "!") == 0 || strcmp(tree->token, "!=") == 0 || strcmp(tree->token, "||") == 0 || strcmp(tree->token, "+") == 0 || strcmp(tree->token, "*") == 0 || strcmp(tree->token, "&") == 0 || strcmp(tree->token, "^") == 0 || strcmp(tree->token, "|") == 0) {
    	printf(" %s ", tree->token);
	} else {
    	if (tree && (!tree->left && !tree->right) || strcmp(tree->token, "main") == 0) {
        	printf("%s", tree->token);
    	} else {
        	printlevel++;
        	printf("%s", tree->token);
        	printlevel--;
    	}
	}

	if (tree->left) {
    	printlevel++;
    	Printtree(tree->left);
    	printlevel--;
	}

	if (tree->right) {
    	printlevel++;
    	Printtree(tree->right);
    	printlevel--;
	}

	if (flag == 2) {
    	printf(")");
	} else if (flag == 1) {
    	printf("\n");
    	printTabs(printlevel);
    	printf(")");
	}
}


int yyerror(char *e) {
    fflush(stdout);
    fprintf(stderr, "Error %s at line %d\n", e, yylineno);
    fprintf(stderr, "does not accept '%s'\n", yytext);
    return 0;
}

int main() {
    return yyparse();
}

