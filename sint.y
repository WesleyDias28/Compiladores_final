%union{
   struct  no3{
      int place;
      char *code;
      int len;
   }node;
}

%{
#include <stdio.h>
#include "analex.c"
#include "codigo.h"
#include "auxiliar.h"
#include "tabsimb.h"
#include <string.h>

char auxStringLista[30];
%}

%token AUTO
%token PAUSA
%token CASO
%token CHAR
%token CONST
%token CONTINUE
%token DEFAULT
%token FACA
%token DOUBLE
%token SENAO
%token ENUM
%token EXTERN
%token FLOAT
%token PARA 
%token GOTO
%token SE
%token INT
%token LONG
%token REGISTER
%token RETORNE
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token <node> ESCOLHA
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token ENQUANTO
%token <node> ID
%token <node> NUM
%token MAIORIGUAL
%token MENORIGUAL
%token COMPARACAO
%token DIFERENCA
%token STRING
%token OR
%token AND
%token NOT

%left AND OR NOT
%left '>' '<' MAIORIGUAL MENORIGUAL COMPARACAO DIFERENCA
%left '+' '-'
%left '*' '/'

%type <node> constante atribuicao exp
%type <node> se comandos
%type <node> enquanto faca para incdec stmtseq statement atribuicaoespecial chamadafuncao escolha

%start PROG
%%
PROG : declfuncao PROG
     | programa 
     ;

programa: funcao
	| funcao programa 
	;

stmtseq : stmtseq statement {$$.code = (char *)malloc(strlen($2.code)); sprintf($$.code,"%s",$2.code); imprime_cod(&$$.code);
}
   | statement {$$.code = (char *)malloc(strlen($1.code)); sprintf($$.code,"%s",$1.code); imprime_cod(&$$.code);
}
   ;

statement : atribuicao {$$ = $1;}
	| se {$$ = $1;}
	| para {$$ = $1;}
	| enquanto 
	| faca
	| atribuicaoespecial
	| chamadafuncao
	| escolha
	;

declfuncao : tipo ID '(' listaparametrosdecl ')' ';' 
	| VOID ID '(' listaparametrosdecl ')' ';' 
	| tipo ID '(' ')' ';'
	| VOID ID '(' ')' ';'
	;

funcao: funcaosemretorno 
	| funcaocomretorno  
	;

funcaosemretorno: VOID ID '(' listaparametrosdecl ')' '{' stmtseq '}' 
	| VOID ID '(' ')' '{' stmtseq '}'
	;

funcaocomretorno: tipo ID '(' listaparametrosdecl ')' '{' stmtseq RETORNE retorno '}'
	| tipo ID '(' ')' '{' stmtseq RETORNE retorno '}'
	;

retorno: chamadafuncao
	| exp ';'
	;

chamadafuncao: ID '(' listaparametroschamada ')'';' 
	| ID '(' ')'';'
	;

tipo: INT
	| FLOAT
	| CHAR
	| DOUBLE
	;

listaparametrosdecl: tipo ID
	| tipo ID ',' listaparametrosdecl
	;

listaparametroschamada: ID
	| NUM
	| ID ',' listaparametroschamada
	| NUM ',' listaparametroschamada 
	;

atribuicao: ID '=' exp ';'
{
		 create_cod(&$$.code);
		 
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($3.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 //imprime_cod(&$$.code);
      }
	| ID '=' STRING ';'
	;

atribuicaoespecial: ID '+' '=' exp ';' 
	| ID '-' '=' exp ';'
	| ID '*' '=' exp ';' 
	| ID '/' '=' exp ';' 
	;

incdec: ID '+' '+' 
        {
		create_cod(&$$.code);		 
		 
		sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		insere_cod(&$$.code,auxStringLista);
		 
		sprintf(auxStringLista,"\t\tADDi AX,1\n");
		insere_cod(&$$.code,auxStringLista);  

		sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($1.place));
		insere_cod(&$$.code,auxStringLista);
		
	}
	| ID '-' '-' 
	 {
		create_cod(&$$.code);		 
		 
		sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		insere_cod(&$$.code,auxStringLista);
		 
		sprintf(auxStringLista,"\t\tSUBi AX,1\n");
		insere_cod(&$$.code,auxStringLista);  
		
	}
	| ID '+' '=' exp 
	{
		 create_cod(&$$.code);
		 
		 insere_cod(&$$.code,$4.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($4.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tADD AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 //imprime_cod(&$$.code);
      }
	| ID '-' '=' exp 
	{
		 create_cod(&$$.code);
		 
		 insere_cod(&$$.code,$4.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($4.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tSUB AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 //imprime_cod(&$$.code);
      }
	| ID '=' exp
	{ 
		 create_cod(&$$.code);
		 
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($3.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 //imprime_cod(&$$.code);
      }
	;

comandos: '{' stmtseq '}' {$$ = $2;}
	| statement {$$ = $1;}
	;

se:  SE '(' exp ')' comandos
{
		 int label1 = 0;
    		 
		 create_cod(&$$.code);     
		 
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($3.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,1\n");
	         insere_cod(&$$.code,auxStringLista);
		
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 
		 insere_cod(&$$.code,$5.code);
		 
		 sprintf(auxStringLista,"\tL%d :\n", label1);  
		 insere_cod(&$$.code,auxStringLista);
 
	      	 //imprime_cod(&$$.code);
	}

	| SE '(' exp ')' comandos SENAO comandos	
{
    		 int label1 = 0;
		 int label2 = 0;

		 create_cod(&$$.code);     
		 
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($3.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,1\n");
	         insere_cod(&$$.code,auxStringLista);
		
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 
		 insere_cod(&$$.code,$5.code);
		
		 label2 = newLabelAssembly();
		 sprintf(auxStringLista,"\t\tJMP L%d\n", label2);
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\tL%d :\n", label1);  
		 insere_cod(&$$.code,auxStringLista);

		 insere_cod(&$$.code,$7.code);
 
		 sprintf(auxStringLista,"\tL%d :\n", label2);  
		 insere_cod(&$$.code,auxStringLista);

	      	 //imprime_cod(&$$.code);
	} 
	;

para: PARA '(' incdec ';' exp ';' incdec ')' comandos 
{
    		 int label1 = 0;
		 int label2 = 0;
		 
		 create_cod(&$$.code);  

		 insere_cod(&$$.code,$3.code);
		
		 label1 = newLabelAssembly(); 	 
			
		 sprintf(auxStringLista,"\tL%d :\n", label1);  
		 insere_cod(&$$.code,auxStringLista); 		 
		 
		 insere_cod(&$$.code,$5.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($5.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,1\n");
	         insere_cod(&$$.code,auxStringLista);
		
		 label2 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label2);
		 insere_cod(&$$.code,auxStringLista);
		 
		 insere_cod(&$$.code,$9.code);	

		 insere_cod(&$$.code,$7.code);	

		 sprintf(auxStringLista,"\t\tJMP L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\tL%d :\n", label2);  
		 insere_cod(&$$.code,auxStringLista);
 
	      	 //imprime_cod(&$$.code);
}
	 | PARA '(' ';' ';' ')' comandos {
	
}
        ;

enquanto: ENQUANTO '(' exp ')' comandos
	{
		 int label1 = 0;
		 int label2 = 0;
    		 
		 create_cod(&$$.code);  
		
		 label1 = newLabelAssembly(); 
			
		 sprintf(auxStringLista,"\tL%d :\n", label1);  
		 insere_cod(&$$.code,auxStringLista);  
		 
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($3.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,1\n");
	         insere_cod(&$$.code,auxStringLista);
		
		 label2 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label2);
		 insere_cod(&$$.code,auxStringLista);
		 
		 insere_cod(&$$.code,$5.code);

		 sprintf(auxStringLista,"\t\tJMP L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\tL%d :\n", label2);  
		 insere_cod(&$$.code,auxStringLista);
 
	      	// imprime_cod(&$$.code);
	}

	;

faca: FACA comandos ENQUANTO '(' exp ')' ';'
	{

	 	 int label1 = 0;
		 int label2 = 0;
    		 
		 create_cod(&$$.code);  
		
		 label1 = newLabelAssembly(); 
			
		 sprintf(auxStringLista,"\tL%d :\n", label1);  
		 insere_cod(&$$.code,auxStringLista);  
		 
		 insere_cod(&$$.code,$2.code);
		
		 insere_cod(&$$.code,$5.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($5.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,1\n");
	         insere_cod(&$$.code,auxStringLista);
		
		 label2 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label2);
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tJMP L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\tL%d :\n", label2);  
		 insere_cod(&$$.code,auxStringLista);
 
	      	// imprime_cod(&$$.code);
	}
	;

escolha: ESCOLHA '(' exp ')' '{' caso '}'
	; 

caso: CASO constante ':' stmtseq PAUSA ';' caso
	| CASO constante ':' stmtseq PAUSA ';'
	| DEFAULT ':' stmtseq PAUSA ';'
	| DEFAULT ':' stmtseq
	;

constante: constante '+' constante
        {
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tADD AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 
        }
	| constante '-' constante
{
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     	 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tSUB AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 
      }
	| constante '*' constante 
{
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     	 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMUL AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 
      }
	| constante '/' constante
{
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	    	 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tDIV AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 
      } 
	| ID { create_cod(&$$.code); 
	               $$.place = $1.place;
		         }
	| NUM { create_cod(&$$.code); 
	               $$.place = $1.place;
		         }
	;

exp:  constante {$$ = $1;}
	| exp AND exp
{
		 int label1 = 0;
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     	 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tAND AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,	auxStringLista);
		 
		 
      } 
	| exp OR exp 
{
		 int label1 = 0;
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     	 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tOR AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,	auxStringLista);
		 
		 
      }
	| NOT exp 
{
		 int label1 = 0;
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$2.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($2.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tNOT AX\n");
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tCMP AX,%s\n",obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 
      }
	| exp MAIORIGUAL exp
{
		
		 int label1 = 0;	 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJGE L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,	auxStringLista);
		 
		 
      }
	| exp MENORIGUAL exp 
{
		
	         int label1 = 0; 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJLE L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,	auxStringLista);
		 
		 
      }
	| exp DIFERENCA exp
{
		 
		 int label1 = 0;
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJNZ L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,	auxStringLista);
		 
		 
      }
	| exp COMPARACAO exp 
{
		 int label1 = 0;
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJZ L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,	auxStringLista);
		 
		 
      }	
	| exp '>' exp 
{
		 int label1 = 0;
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJG L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,	auxStringLista);
		 
		 
      }
	| exp '<' exp
{
		 int label1 = 0;
		 
		 create_cod(&$$.code); 
	         $$.place = newRegTemp();
		 
		 insere_cod(&$$.code,$1.code);
		 insere_cod(&$$.code,$3.code);
		 
		 sprintf(auxStringLista,"\t\tMOV AX,1\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));
		 insere_cod(&$$.code,auxStringLista);

		 sprintf(auxStringLista,"\t\tMOV AX,%s\n", obtemNome($1.place));
		 insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tMOV DX,%s\n", obtemNome($3.place));
	     insere_cod(&$$.code,auxStringLista);
		 
		 sprintf(auxStringLista,"\t\tCMP AX,DX\n");
		 insere_cod(&$$.code,auxStringLista);
		 
		 label1 = newLabelAssembly();
		 
		 sprintf(auxStringLista,"\t\tJL L%d\n", label1);
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV AX,0\n");
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\t\tMOV %s,AX\n", obtemNome($$.place));  
		 insere_cod(&$$.code,auxStringLista);
		 sprintf(auxStringLista,"\tL%d:\n", label1);
		 insere_cod(&$$.code,	auxStringLista);
		 
		 
      }
	| '(' exp ')' 
	{/*
		create_cod(&$$.code); 
	         
		insere_cod(&$$.code,$1.code);
	*/}
	; 
%%

extern FILE *yyin;

main(int argc, char **argv){
	yyin=fopen(argv[1],"rt");
	criaLista();
	//criaListaInstrucao();
	int retorno = yyparse();
	//imprime();
	//imprimeInstrucao();
}

