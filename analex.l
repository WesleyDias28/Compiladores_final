%{
#include <stdio.h>
#include "sint.h"

int yyerror(char *s);
int cont=0; int linha=1; int posicaoInparamada;

extern YYSTYPE yylval;

%}
%%

"auto" {return AUTO;}
"pausa" {return PAUSA;}
"caso" {return CASO;}
"char" {return CHAR;}
"const" {return CONST;}
"continue" {return CONTINUE;}
"default" {return DEFAULT;}
"faca" {return FACA;}
"double" {return DOUBLE;}
"senao" {return SENAO;}
"enum" {return ENUM;}
"extern" {return EXTERN;}
"float" {return FLOAT;}
"para" {return PARA;}
"goto" {return GOTO;}
"se" {return SE;}
"int" {return INT;}
"long" {return LONG;}
"register" {return REGISTER;}
"retorne" {return RETORNE;}
"short" {return SHORT;}
"signed" {return SIGNED;}
"sizeof" {return SIZEOF;}
"static" {return STATIC;}
"struct" {return STRUCT;}
"escolha" {return ESCOLHA;}
"typedef" {return TYPEDEF;}
"union" {return UNION;}
"unsigned" {return UNSIGNED;}
"void" {return VOID;}
"volatile" {return VOLATILE;}
"enquanto" {return ENQUANTO;}
[0-9]+ {yylval.node.place = insere(yytext);return NUM;}
"||" {return OR;}
"&&" {return AND;}
"==" {return COMPARACAO;}
">=" {return MAIORIGUAL;}
"<=" {return MENORIGUAL;}
"!=" {return DIFERENCA;}
"+" {return '+';}
\".*\" { return STRING; }
"-" {return '-';}
"/" {return '/';}
"*" {return '*';}
"=" {return '=';}
":" {return ':';}
";" {return ';';}
">" {return '>';}
"<" {return '<';}
"(" {return '(';}
")" {return ')';}
"{" {return '{';}
"}" {return '}';}
"&" {return '&';}
"|" {return '|';}
"!" {return NOT;}
[a-zA-Z]([a-zA-Z]|[0-9])* {yylval.node.place = insere(yytext);return ID;}
[\t] {}
" " {}
\n {linha++;}
. {return -1;}
%%
#ifndef yywrap
yywrap() { return 1; }
#endif

int yyerror(char *s) { fprintf(stderr, "\n\n---------- \n\t\n%s na linha %d\n\n----------\n",s,linha); }
