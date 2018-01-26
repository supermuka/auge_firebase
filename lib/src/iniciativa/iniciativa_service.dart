import 'dart:async';

import 'package:angular/core.dart';

import 'package:firebase/firebase.dart' as fb;
import 'package:auge/model/iniciativa.dart';

@Injectable()
class IniciativaService {

  //Iniciativa iniciativaSelecionada;

  Future<List<Iniciativa>> recuperarIniciativas({String chave}) async {
    var event;
    if (chave != null && chave.isNotEmpty) {
      event = await fb.database().ref('iniciativa').orderByKey().equalTo(chave).once("value");

    } else {
      event = await fb.database().ref('iniciativa').once("value");
    }

    //var event = await fb.database().ref('empresa').once("value");
    List<Iniciativa> iniciativas = new List();
    if (event.snapshot.exists()) {

      event.snapshot.forEach((ss) {

        iniciativas.add(new Iniciativa()..chave = ss.key..nome = ss.val()["nome"]..descricao = ss.val()["descricao"]);

      }
      );
    }
    return iniciativas;
  }


  Future<Null> salvarIniciativa(Iniciativa domain) async {

    fb.DatabaseReference dr =    fb.database().ref('iniciativa');


    if (domain.chave == null || domain.chave.trim().length == 0) {
      domain.chave =  dr.push().key;
    }

    dr.child('${domain.chave}/nome').set(domain.nome);
    dr.child('${domain.chave}/descricao').set(domain.descricao);
  }

  void excluirIniciativa(Iniciativa domain) {

    fb.DatabaseReference dr =    fb.database().ref('iniciativa');

    if (domain.chave != null && domain.chave.trim().length > 0) {

      dr.child('${domain.chave}').remove();
    }
  }
}