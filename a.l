%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.c"
    #include "y.tab.h"

%}
%option noyywrap
%%
bool { return BOOL; }
char { return CHAR; }
int { return INT; }
real { return REAL; }
string { return STRING; }
double { return DOUBLE; }
float { return FLOAT; }
int\* { return PTRINT; }
char\* { return PTRCHAR; }
double\* { return PTRDOUBLE; }
float\* { return PTRFLOAT; }
if { return IF; }
else { return ELSE; }
while { return WHILE; }
for { return FOR; }
var { return VARIABLE; }
args>> { return ARGS; }
public { return PUBLIC; }
private { return PRIVATE; }
static { return STATIC; }
return { return RETURN; }
null { return MY_NULL; }
void { return VOID; }
do { return DO; }
main { return MAIN; }
"&&" { return OPRAND; }
"/" { return OPRDIVISION; }
"=" { return OPRASSIGNMENT; }
"==" { return OPREQL; }
"<" { return OPRGREATER; }
"<=" { return OPRGREATEREQL; }
">" { return OPRLESS; }
">=" { return OPRLESSEQL; }
"-" { return OPRMINUS; }
"!" { return OPRNOT; }
"!=" { return OPRNOTEQL; }
"||" { return OPROR; }
"+" { return OPRPLUS; }
"*" { return OPRMULTI; }
"&" { return OPRADDRESS; }
"<-" { return OPRTO; }
"|" { return LENGTH; }
";" { return SEMICOLON; }
":" { return COLON; }
"," { return COMMA; }
"{" { return OPENBRACE; }
"}" { return CLOSEBRACE; }
"(" { return OPENPAREN; }
")" { return CLOSEPAREN; }
"[" { return OPENBRACKET; }
"]" { return CLOSEBRACKET; }
\/\*.*\*\/ { return COMMENT; }
true { return TRUEBOOL; }
false { return FALSEBOOL; }
[a-zA-Z][a-zA-Z0-9_]* { yylval.string = strdup(yytext); return IDENTIFIER; }
\'.\' { yylval.string = strdup(yytext); return ONECHAR; }
0(x|X)[0-9A-F]+ { yylval.string = strdup(yytext); return HEX; }
[0-9]* { yylval.string = strdup(yytext); return INTLTL; }
[0-9]*\.?[0-9]*[eE]?[-+]?[0-9]+ { yylval.string = strdup(yytext); return DECIMAL; }
[-+]?[0-9]*\.?[0-9]*[eE]?[-+]?[0-9]+ { yylval.string = strdup(yytext); return REALLTL; }
[-+]?[0-9]*\.?[0-9]*f { yylval.string = strdup(yytext); return FLOATLTL; }
"\""[^"]*"\"" { yylval.string = strdup(yytext); return STRINGLTL; }
[ \t]+ ;  // Skip whitespace
[\n] { yylineno++; }  // Count newlines
%%


