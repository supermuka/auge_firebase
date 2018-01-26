// Copyright (c) 2017, Levius.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'autenticacao_service.dart';
import 'package:auge/services/firebase_service.dart';

import 'package:auge/services/app_rotas.dart';

// ignore_for_file: uri_has_not_been_generated
import 'package:auge/src/app_layout/app_layout_component.template.dart' as app_layout_component;


@Component(
  selector: 'auge-autenticacao',
  styleUrls: const ['autenticacao_component.css'],
  templateUrl: 'autenticacao_component.html',
  providers: const [materialProviders, AutenticacaoService],
  directives: const [
    CORE_DIRECTIVES,
    routerDirectives,
    materialDirectives,
    MaterialInputComponent,
  ],

)

class AutenticacaoComponent implements OnInit {

  String appLayoutRoute = AppRotas.appLayoutRoute.toUrl();
/*
  final List<RouteDefinition> rotas = [

    new RouteDefinition(
      routePath: AppRotas.appLayoutRoute,
      component: app_layout_component.AppLayoutComponentNgFactory,

    ),
    //   new RouteDefinition.redirect(
    //     path: '.*', // Regex
    //    redirectTo: AppRotas.autenticacaoRoute.toUrl(),
    //  ),
  ];
  */
  final AutenticacaoService _autenticacaoService;

  String eMail = "samuel.schwebel@gmail.com";
  String senha = "123456";
  String error;

  Router _router;

  AutenticacaoComponent(this._autenticacaoService, this._router);

  @override
  ngOnInit() {
    // AutenticacaoService.inicializarFireBase();

  }

  Future<Null> entrarAutenticacao(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {

      if (await FirebaseService.autenticarComEmail(email, password)) {

        await _autenticacaoService.definirAutenticado(email);

        if (!AutenticacaoService.autenticado) {
          error = "Não encontrado conta com o e-mail relacionado.";
        } else {
          print('navegarParaAppLayout');
          navegarParaAppLayout();
        }
      } else {
        error = "Por favor preencha corretamente o email e senha.";
      }
    }
  }

  Future<Null> navegarParaAppLayout() {
    print(AppRotas.appLayoutRoute.toUrl());
    _router.navigate(AppRotas.appLayoutRoute.toUrl());
  }

}