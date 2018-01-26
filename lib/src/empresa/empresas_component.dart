// Copyright (c) 2018, Levius.

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:auge/model/empresa.dart';

import 'package:auge/src/app_layout/app_layout_home.dart';
import 'package:auge/src/empresa/empresa_service.dart';
import 'package:auge/src/empresa/empresa_detalhe_component.dart';
import 'package:auge/services/app_rotas.dart';

// ignore_for_file: uri_has_not_been_generated
import 'package:auge/src/app_layout/app_layout_home.template.dart' as app_layout_home;
import 'package:auge/src/empresa/empresa_detalhe_component.template.dart' as empresa_detalhe;

@Component(
    selector: 'auge-empresas',
    providers: const <dynamic>[EmpresaService],
    directives: const [
      CORE_DIRECTIVES,
      routerDirectives,
      AutoFocusDirective,
      materialDirectives,
      MaterialInputComponent,
      MaterialFabComponent,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialDialogComponent,
      ModalComponent,

    ],
    templateUrl: 'empresas_component.html',
    styleUrls: const [
      'empresas_component.css'
    ])

/*
@RouteConfig(const [
  //const Redirect(path: '/', redirectTo: const ['Empresas']),
  const Route(path: '/', name: 'AppLayoutHome', component: AppLayoutHomeComponent, useAsDefault: true),
  const Route(path: '/empresa/:chave', name: 'EmpresaDetalhe', component: EmpresaDetalheComponent),
])
*/


class EmpresasComponent implements OnInit {

  final List<RouteDefinition> rotas = [
    new RouteDefinition(
        routePath: AppRotas.appLayoutHomeRoute,
        component: app_layout_home.AppLayoutHomeComponentNgFactory,
        useAsDefault: true
    ),
    new RouteDefinition(
        routePath: AppRotas.empresaDetalheRoute,
        component: empresa_detalhe.EmpresaDetalheComponentNgFactory,
    ),
  ];

  final EmpresaService _empresaService;
  final Router _router;
 // final RouteParams _routeParams;


  Empresa e;

  EmpresasComponent(this._empresaService, this._router);

  void chamarDetalhe(Empresa empresaSelecionada) {
    if (empresaSelecionada == null) {
      _empresaService.empresaSelecionada = new Empresa();
    } else {
      _empresaService.empresaSelecionada = empresaSelecionada;
    }
  }

  bool apresentarDetalhe() {
    return (_empresaService.empresaSelecionada != null);
  }

  @override
  ngOnInit() async {

    await _empresaService.recuperarEmpresas();
  }


  get empresas {

    return _empresaService.empresas;
  }

  void navegarPara(Empresa e) {
    _empresaService.empresaSelecionada = e;

     // _router.navigate([nome, { 'chave': e != null ? e.chave : null}]);
    _router.navigate(AppRotas.empresaDetalheRoute.toUrl(parameters: {AppRotas.empresaChaveParameter: e.chave}));


  }


}