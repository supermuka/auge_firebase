import 'dart:async';

import 'package:angular/core.dart';
import 'package:auge/services/firebase_service.dart';
import 'package:auge/model/empresa.dart';
import 'package:auge/model/conta.dart';
import 'package:auge/src/empresa/empresa_service.dart';
import 'package:auge/src/conta_empresa/conta_empresa_service.dart';


@Injectable()
class AutenticacaoService  {

  final ContaEmpresaService _contaEmpresaService = new ContaEmpresaService(new EmpresaService());

  static bool autenticado = false;
  static bool ehAdministrador = false;
  static List<Empresa> autenticadoEmpresas = new List();

  AutenticacaoService();

  Future<Null> definirAutenticado(String eMail) async {

    List<Conta> contas = await _contaEmpresaService.recuperarContas(eMail: eMail);

    autenticadoEmpresas.clear();
    if (contas.isNotEmpty) {

      print(contas.first.empresas);

      contas.first.empresas.forEach((e) => autenticadoEmpresas.add(e));
      autenticado = true;
      ehAdministrador = contas.first.ehAdministrador;
    }
  }


  static void inicializarFireBase() {
/*
    fb.initializeApp(
        apiKey: "AIzaSyAxACUypjTqQTjqQk2zO9hWbguq7x_z2Uc",
        authDomain: "precomi-e8d99.firebaseapp.com",
        databaseURL: "https://precomi-e8d99.firebaseio.com",
        storageBucket: "precomi-e8d99.appspot.com");
        */
  }

  /*
  static Future<bool> autenticarComEmail(String email, String password) async {

    if (await FirebaseService.autenticarComEmail(email, password) == false) {
      AutenticacaoService.autenticado = true;

    } else {
      AutenticacaoService.autenticado = false;
    }


    /*
    try {

       await fb.auth().signInWithEmailAndPassword(email, password);

       token = await fb.auth().currentUser.getToken();

       AutenticacaoService.autenticado = true;

    } catch (e) {
      erro = "Não foi possível autenticar usuário. " + e.toString();
    }
    */
  }
*/
  static sairAutenticacao() {

    /*
    fb.auth().signOut();
    AutenticacaoService.autenticado = false;
    */
    FirebaseService.sairAutenticacao();
    AutenticacaoService.autenticado = false;

  }


}
