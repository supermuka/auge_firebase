import 'package:auge/model/conta.dart';

class Empresa {
  String chave;
  bool alterado = false;

  String nome;
  String cnpj;

  Empresa() {

  }

  @override
  String get uiDisplayName => nome;

  @override
  String toString() => uiDisplayName;


}