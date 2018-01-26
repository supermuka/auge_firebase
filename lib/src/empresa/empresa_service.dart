import 'dart:async';

import 'package:angular/core.dart';

import 'package:firebase/firebase.dart' as fb;
import 'package:auge/model/empresa.dart';

@Injectable()
class EmpresaService {

  Empresa empresaSelecionada;
  List<Empresa> empresas = new List();

  Future<List<Empresa>> recuperarEmpresas({String chave}) async {
    var event;
    if (chave != null && chave.isNotEmpty) {
      event = await fb.database().ref('empresa').orderByKey().equalTo(chave).once("value");

    } else {
      event = await fb.database().ref('empresa').once("value");
    }

    //var event = await fb.database().ref('empresa').once("value");
    if (event.snapshot.exists()) {

      event.snapshot.forEach((ss) {

        empresas.add(new Empresa()..chave = ss.key..nome = ss.val()["nome"]..cnpj = ss.val()["cnpj"]);

      }
      );
    }
    return empresas;
  }



  void salvarEmpresa(Empresa domain)  {

    fb.DatabaseReference dr =    fb.database().ref('empresa');

    if (domain.chave == null || domain.chave.trim().length == 0) {

      domain.chave =  dr.push().key;

      empresas.add(domain);

    } else {
   //   empresas[empresas.indexOf(empresas.firstWhere((e) => e.chave == domain.chave))] = domain;
    }

    dr.child('${domain.chave}/nome').set(domain.nome);
    dr.child('${domain.chave}/cnpj').set(domain.cnpj);

  }

  void excluirEmpresa(Empresa domain) {

    fb.DatabaseReference dr =    fb.database().ref('empresa');

    if (domain.chave != null && domain.chave.trim().length > 0) {

      dr.child('${domain.chave}').remove();
    }

    empresas.removeAt(empresas.indexOf(empresas.firstWhere((e) => e.chave == domain.chave)));
  }
}