// Copyright (c) 2017, Levius.

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:intl/intl.dart';

import 'package:auge/services/app_rotas.dart';

import 'package:auge/services/firebase_service.dart';
import 'package:auge/src/autenticacao/autenticacao_service.dart';

// ignore_for_file: uri_has_not_been_generated
import 'package:auge/src/autenticacao/autenticacao_component.template.dart' as autenticacao_component;
import 'package:auge/src/app_layout/app_layout_component.template.dart' as app_layout_component;
import 'package:auge/src/app_layout/app_layout_home.template.dart' as app_layout_home;
import 'package:auge/src/painel/painel_component.template.dart' as painel_component;

@Component(
    selector: 'auge-app-component',
    providers: const <dynamic>[materialProviders, AutenticacaoService],
    directives: const [
      CORE_DIRECTIVES,
      routerDirectives,
    ],
    templateUrl: 'app_component.html',
    styleUrls: const [
      'app_component.css',
      //'package:angular_components/app_layout/layout.scss.css',
    ])

/*
@RouteConfig(const [
  const Redirect(path: '/', redirectTo: const ['Autenticacao']),
  const Route(
      path: '/autenticacao',
      name: 'Autenticacao',
      component: AutenticacaoComponent,
      useAsDefault: true),
  const Route(path: '/app_layout/...', name: 'AppLayout', component: AppLayoutComponent)
])
*/

class AppComponent implements OnInit {

  final Router _router;
/*
  String autenticacaoRoute = AppRotas.autenticacaoRoute.toUrl();
  String appLayoutRoute = AppRotas.appLayoutRoute.toUrl();
*/
  final List<RouteDefinition> rotas = [
    new RouteDefinition(
      routePath: AppRotas.autenticacaoRoute,
      component: autenticacao_component.AutenticacaoComponentNgFactory,
      useAsDefault: true
    ),
    new RouteDefinition(
      routePath: AppRotas.appLayoutRoute,
      component: app_layout_component.AppLayoutComponentNgFactory,
    ),
    /*
   new RouteDefinition.redirect(
      path: '.*', // Regex
      redirectTo: AppRotas.autenticacaoRoute.toUrl(),
    ),
    */
  ];

  AppComponent(this._router) {
    Intl.defaultLocale = 'pt_BR';
  }

  @override
  ngOnInit() async {
    FirebaseService.inicializarFireBase();
  }

  bool estahAutenticado() {
    return AutenticacaoService.autenticado;
  }

  void sairAutenticado() {
    return AutenticacaoService.sairAutenticacao();
  }
/*
  navegar() {
    print('navegar');

    _router.navigate(AppRotas.autenticacaoRoute.toUrl());


  }

  navegar2() {
    print('navegar2');
    print(_router.current.routes);

    _router.navigate(AppRotas.appLayoutRoute.toUrl());


  }
*/
}

