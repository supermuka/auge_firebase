import 'package:auge/model/empresa.dart';

class Conta {
  String chave;
  bool alterado = false;

  String nome;
  String eMail;
  String senha;
  String uidAutenticacao;
  bool ehAdministrador;

  List<Empresa> empresas;

  Conta() {
    empresas = new List();
  }

}