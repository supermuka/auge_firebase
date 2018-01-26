import 'dart:async';

import 'package:angular/core.dart';

import 'package:firebase/firebase.dart' as fb;
import 'package:auge/model/item_trabalho.dart';

@Injectable()
class ItemTrabalhoService {

  Future<List<ItemTrabalho>> recuperarItensTrabalho({String chave_iniciativa, String chave }) async {
    var event;
    if (chave != null && chave.isNotEmpty) {
      event = await fb.database().ref('item_trabalho').orderByKey().equalTo(chave).once("value");

    } else {
      event = await fb.database().ref('item_trabalho').once("value");
    }

    if (chave_iniciativa != null && chave_iniciativa.isNotEmpty) {
      event = await fb.database().ref('item_trabalho').orderByChild("chave_iniciativa").equalTo(chave_iniciativa).once("value");

    } else {
      event = await fb.database().ref('item_trabalho').once("value");
    }

    print('TESTE 1');
    //var event = await fb.database().ref('empresa').once("value");
    List<ItemTrabalho> itensTrabalho = new List();
    if (event.snapshot.exists()) {

      event.snapshot.forEach((ss) {
        print('TESTE 2');
        itensTrabalho.add(new ItemTrabalho()
          ..chave = ss.key
          ..chave_iniciativa = ss.val()["chave_iniciativa"]
          ..nome = ss.val()["nome"]
          ..dataInicio=(ss.val()["data_inicio"] != '' ? new DateTime.fromMicrosecondsSinceEpoch(ss.val()["data_inicio"]) : null)
          ..dataFim=(ss.val()["data_fim"] != '' ? new DateTime.fromMicrosecondsSinceEpoch(ss.val()["data_fim"]) : null)
          ..percentualConcluido = ss.val()["percentual_concluido"] != null ? 0 : int.parse(ss.val()["percentual_concluido"]) );
        print('TESTE 3');
      }
      );
    }
    print('TESTE 4');

    return itensTrabalho;
  }


  void salvarItemTrabalho(ItemTrabalho domain)  {

    fb.DatabaseReference dr =    fb.database().ref('item_trabalho');

    if (domain.chave == null || domain.chave.trim().length == 0) {
      domain.chave =  dr.push().key;
    }
    dr.child('${domain.chave}/chave_iniciativa').set(domain.chave_iniciativa);
    dr.child('${domain.chave}/nome').set(domain.nome);
    dr.child('${domain.chave}/note').set(domain.nota);
    dr.child('${domain.chave}/data_inicio').set(domain.dataInicio.millisecondsSinceEpoch);
    dr.child('${domain.chave}/data_fim').set(domain.dataFim.millisecondsSinceEpoch);
    dr.child('${domain.chave}/percentual_concluido').set(domain.percentualConcluido);
  }

  void excluirItemTrabalho(ItemTrabalho domain) {

    fb.DatabaseReference dr =    fb.database().ref('item_trabalho');

    if (domain.chave != null && domain.chave.trim().length > 0) {

      dr.child('${domain.chave}').remove();
    }
  }

}