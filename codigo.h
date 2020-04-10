#include <stdlib.h>
#include <string.h>

char *codigo;

create_cod(char **codigo) {
  *codigo = (char *) malloc(2);
  strcpy(*codigo,"");
}

insere_cod(char **codigo, char *instrucao) {
char *aux;
   aux = *codigo;
  *codigo = (char *) malloc(strlen(*codigo)+strlen(instrucao)+2);
  strcpy(*codigo,aux);
  strcat(*codigo,instrucao);
  free(aux);
}

imprime_cod(char **codigo) {
  printf("%s",*codigo);
}
