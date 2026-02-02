1st stage Compiler

On Linux:
Commands to run:
yacc -d a.y
flex a.l
cc -o parser lex.yy.c -lfl
./parser< example.t
