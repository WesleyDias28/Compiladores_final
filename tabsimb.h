#include <stdio.h>
#include <string.h>

typedef struct simbolo{
 char nome[40];
 int tamanho;
 int tipo;
}simbolo;

typedef struct no{
 simbolo conteudo;
 struct no *prox;
}no;

typedef struct lista{
 struct no *inicio;
 struct no *fim;
}lista;


//Protótipo de funções
void criaLista();
int insere(char *nome);
int procura(char *nome);
void imprime();
char *obtemNome(int pos);


int tamanho = 0;
int posicaoGlobal = 0;
lista l;


void criaLista()
{
    l.inicio = NULL;
    l.fim = NULL;
}

int insere(char *nome){

    no *auxNo;
    int posicaoLocal = 0;

    posicaoLocal = procura(nome);
    
    if(posicaoLocal == -1){

	    auxNo = (no*) malloc(sizeof(no));
	    if (auxNo == NULL)
		return 0;

	    if (l.inicio == NULL)//Iniciando armazenamento na tabela de simbolos
	    {		
		l.inicio = auxNo;
	    }else{ //Linkando os nós na lista
		l.fim->prox = auxNo;
	    }
	    
            strcpy(auxNo->conteudo.nome,(const char*) nome);
	    auxNo->prox = NULL;	    
	    l.fim = auxNo;
            
	    posicaoLocal = posicaoGlobal++;
    }
    return posicaoLocal;
}

int procura(char *nome){
    
    no *auxNo;
    int posicaoLocal = 0;

    auxNo = l.inicio;

    if (auxNo == NULL) //Lista Vazia
        return -1;

    while (auxNo!=NULL) //Percorrendo lista
    {
        if (strcmp(auxNo->conteudo.nome,nome) == 0){ //Encontrei lexema na tabela de simbolos
            return posicaoLocal;
        }
        auxNo = auxNo->prox;
        posicaoLocal++;
    }

    //Não encontrei lexema na tabela de simbolos e posso inserir
    return -1;
}

void imprime(){

    no *auxNo;
    
    if (l.inicio == NULL)
        printf("\nLista vazia...\n\n");
    else
    {
	printf("\n\nTabela de Símbolos:\n");
	auxNo = l.inicio;
        while (auxNo != NULL)
        {
            printf("%s\n", auxNo->conteudo.nome);
            auxNo = auxNo->prox;
        }
    }
}
char nome[30];
char *obtemNome(int pos){
     no *auxNo; 
     auxNo = l.inicio;

     if(pos > posicaoGlobal){
	char *invalido = "Não temos essa posição na tabela de símbolos";
	return invalido;
     }
	
     if(pos >= 0){
	     for(int i = 0;i<pos;i++){ // Chegando até a posição desejada.
		auxNo = auxNo->prox;
	     }
     }else {
        sprintf(nome,"Temp%d",-pos);
	return nome;
     }
		
     return auxNo->conteudo.nome;

}
