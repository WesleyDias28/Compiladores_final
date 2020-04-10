int temporario = 0;
int labelAssembly = 0;

int newRegTemp(){
  return --temporario;
}

int newLabelAssembly(){
  return ++labelAssembly;
}
