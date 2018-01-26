import 'dart:async';

import 'package:angular/core.dart';

import 'package:firebase/firebase.dart' as fb;
import 'package:auge/model/empresa.dart';
import 'package:auge/model/conta.dart';
import 'package:auge/src/empresa/empresa_service.dart';

@Injectable()
class ContaEmpresaService {

  EmpresaService _empresaService;

  ContaEmpresaService(this._empresaService);

  Future<List<Conta>> recuperarContas({String eMail, String chave}) async {
    var event;
    if (eMail != null && eMail.isNotEmpty) {
      event = await fb.database().ref('conta').orderByChild("eMail")
          .equalTo(eMail)
          .once("value");
    } else if (chave != null && chave.isNotEmpty) {
      event = await fb.database().ref('conta').orderByChild("chave")
          .equalTo(eMail)
          .once("value");
    }
    else {
      event = await fb.database().ref('conta').once("value");
    }

    List<Conta> contas = new List();
    if (event.snapshot.exists()) {
      List<Empresa> empresas = await _empresaService.recuperarEmpresas();

      event.snapshot.forEach((ss) {
        contas.add(
            new Conta()
              ..chave = ss.key
              ..nome = ss.val()["nome"]
              ..eMail = ss.val()["eMail"]
              ..senha = ss.val()["senha"]
              ..ehAdministrador = ss.val()["ehAdministrador"]);

        Map<String, dynamic> componente = ss.val()["empresas"];

        if (componente != null) {
          componente.forEach((ee, vv) {
            contas.last.empresas.add(empresas != null && empresas.length > 0 &&
                vv["empresa_chave"] != null ? empresas.singleWhere((s) =>
            s?.chave == vv["empresa_chave"]) : null);
          });
        }
      }
      );
    }
    return contas;
  }
}

