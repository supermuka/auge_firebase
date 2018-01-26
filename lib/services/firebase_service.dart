// Copyright (c) 2017, Levius.

import 'dart:async';

import 'package:angular/core.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:auge/model/empresa.dart';
import 'package:auge/model/conta.dart';


@Injectable()
class FirebaseService {

  static fb.AuthCredential credencial;

  static String empresaSelecionada = null;


  FirebaseService() {
    /*
    fb.initializeApp(
        apiKey: "",
        authDomain: "",
        databaseURL: "",
        storageBucket: ""
    );
    */
  }
/*
  entrarAutenticacao(email, password) {
    fb.auth().signInWithEmailAndPassword(email, password);
  }

  sairAutenticacao() {
    fb.auth().signOut();
  }
*/

  static inicializarFireBase() async {

    await fb.initializeApp(
        apiKey: "AIzaSyCaikCvdVAq9osMV8WmZVT7eDOHmSZj10E",
        authDomain: "auge-1910b.firebaseapp.com",
        databaseURL: "https://auge-1910b.firebaseio.com",
        storageBucket: "auge-1910b.appspot.com");
  }

  static Future<bool> autenticarComEmail(String email, String password) async {

    try {

      credencial  = fb.EmailAuthProvider.credential(email, password);


      fb.User a = await fb.auth().signInWithCredential(credencial);

      //await fb.auth().signInWithEmailAndPassword(email, password);


      return true; // AutenticacaoService.autenticado = true;

    } on fb.FirebaseError catch (e) {

     // rethrow;
      return false;
    }
  }

  static sairAutenticacao() {
    fb.auth().signOut();
  }


  static excluirConta(Conta domain) async {

    fb.DatabaseReference dr =    fb.database().ref('conta');

    if (domain.chave != null && domain.chave.trim().length > 0) {

      fb.User usuarioExclusao;
      try {
        usuarioExclusao = await fb.auth().signInWithEmailAndPassword(domain.eMail, domain.senha);
        usuarioExclusao.delete();
      } catch (e) {
        print(e);
      } finally {
        await fb.auth().signInWithCredential(credencial);
      }

      dr.child('${domain.chave}').remove();
    }
  }



  static salvarConta(Conta domain) async {

    fb.DatabaseReference dr = fb.database().ref('conta');

    if (domain.chave == null || domain.chave.trim().length == 0) {

      fb.User user;
      try {
        user = await fb.auth().createUserWithEmailAndPassword(
            domain.eMail, domain.senha);
      } on fb.FirebaseError catch (e) {
        if (e.code == "auth/email-already-in-use") {
          try {
            user = await fb.auth().signInWithEmailAndPassword(domain.eMail, domain.senha);
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {
        print(e);
      } finally {
        domain.uidAutenticacao = user.uid;
        await fb.auth().signInWithCredential(credencial);
      }

      domain.chave =  dr.push().key;

    }

    dr.child('${domain.chave}/nome').set(domain.nome);
    dr.child('${domain.chave}/eMail').set(domain.eMail);
    dr.child('${domain.chave}/senha').set(domain.senha);
    dr.child('${domain.chave}/uidAutenticacao').set(domain.uidAutenticacao);
    dr.child('${domain.chave}/ehAdministrador').set(domain.ehAdministrador);

    await dr.child('${domain.chave}/empresas').remove();

    for (int i_e = 0;i_e <domain.empresas.length;i_e++) {
        if (domain.empresas[i_e].chave == null) {
          domain.empresas[i_e].chave = dr
              .child('${domain.chave}/empresas')
              .push()
              .key;
        }
        dr.child(
            '${domain.chave}/empresas/${domain.empresas[i_e]
                .chave}/empresa_chave').set(domain.empresas[i_e].chave);

    }
  }
}