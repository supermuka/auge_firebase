
import 'package:auge/model/conta.dart';


class ItemTrabalho {
  String chave;
  String chave_iniciativa;
  String nome;
  String nota;
  DateTime dataInicio;
  DateTime dataFim;
  String estado;
  int percentualConcluido;

  List<Conta> colaboradores;

  ItemTrabalho() {

    colaboradores = new List<Conta>();
  }
}