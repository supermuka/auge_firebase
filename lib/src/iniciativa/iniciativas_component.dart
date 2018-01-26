// Copyright (c) 2018, Levius.
// Samuel Schwebel

import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:auge/model/iniciativa.dart';

import 'package:auge/src/iniciativa/iniciativa_service.dart';
import 'package:auge/src/busca/busca_service.dart';

import 'package:auge/src/app_layout/app_layout_service.dart';
//import 'package:auge/src/iniciativa/iniciativa_detalhe_component.dart';

import 'package:auge/services/app_rotas.dart';

// ignore_for_file: uri_has_not_been_generated
import 'package:auge/src/app_layout/app_layout_home.template.dart' as app_layout_home;
import 'package:auge/src/iniciativa/iniciativa_detalhe_component.template.dart' as iniciativa_detalhe_component;
import 'package:auge/src/item_trabalho/itens_trabalho_component.template.dart' as itens_trabalho_component;
import 'package:auge/src/item_trabalho/item_trabalho_detalhe_component.template.dart' as item_trabalho_detalhe_component;


@Component(
    selector: 'auge-iniciativas',
    providers: const <dynamic>[IniciativaService],
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
      MaterialProgressComponent,
      ModalComponent,
  //    IniciativaDetalheComponent,

    ],
    templateUrl: 'iniciativas_component.html',
    styleUrls: const [
      'iniciativas_component.css'
    ])

/*
@RouteConfig(const [
  ///const Redirect(path: '/', redirectTo: const ['Iniciativas'], useAsDefault: true),
  const Route(path: '/', name: 'AppLayoutHome', component: AppLayoutHomeComponent, useAsDefault: true),
  //const Route(path: '', name: 'Iniciativasx', component: IniciativasComponent, useAsDefault: true),
  //const Route(path: '/', name: 'Iniciativas', component: IniciativasComponent, useAsDefault: true),
  const Route(path: '/iniciativa/:chave_iniciativa', name: 'IniciativaDetalhe', component: IniciativaDetalheComponent),

  const Route(path: '/item_trabalho/:chave_iniciativa/:chave_item_trabalho', name: 'ItemTrabalhoDetalhe', component: ItemTrabalhoDetalheComponent)
])
*/

class IniciativasComponent implements OnInit, OnActivate, OnDestroy {


  final List<RouteDefinition> rotas = [

    new RouteDefinition(
        routePath: AppRotas.appLayoutHomeRoute,
        component: app_layout_home.AppLayoutHomeComponentNgFactory,
        useAsDefault: true
    ),

    new RouteDefinition(
      routePath: AppRotas.iniciativaDetalheRoute,
      component: iniciativa_detalhe_component.IniciativaDetalheComponentNgFactory,
     // useAsDefault: true
    ),

    new RouteDefinition(
      routePath: AppRotas.itensTrabalhoRoute,
      component: itens_trabalho_component.ItensTrabalhoComponentNgFactory,
      // useAsDefault: true
    ),


  ];


  final IniciativaService _iniciativaService;
  final BuscaService _buscaService;
  final Router _router;
  final AppLayoutService _appLayoutService;

  List<Iniciativa> _iniciativas = new List();

  IniciativasComponent(this._iniciativaService, this._appLayoutService, this._buscaService, this._router);

  @override
  ngOnInit() async {

  }

  @override
  Future onActivate(_, __) async {
    _iniciativas = await _iniciativaService.recuperarIniciativas();
    _appLayoutService.buscaHabilitada = true;
  }

  List<Iniciativa> get iniciativas {
    return _buscaService?.termoBusca.toString().isEmpty ? _iniciativas : _iniciativas.where((t) => t.nome.contains(_buscaService.termoBusca)).toList();
  }

  @override
  ngOnDestroy() async {
    _appLayoutService.buscaHabilitada = false;

  }

  void navegarParaItensTrabalho(Iniciativa item) {
    print('kkkk');
    print(AppRotas.itensTrabalhoRoute.toUrl(parameters: { AppRotas.iniciativaChaveParameter: item.chave }));
    print(item.chave);
    _router.navigate(AppRotas.itensTrabalhoRoute.toUrl(parameters: { AppRotas.iniciativaChaveParameter: item.chave }));


    AppRotas.itensTrabalhoRoute.toUrl(parameters: { AppRotas.iniciativaChaveParameter: item.chave });



    print(_router.current.path);
    print(_router.current.routePath);
    print(_router.current.parameters);
    print(_router.current.fragment);

    print('llll');
  }

  void navegarParaDetalhe(Iniciativa item, [MouseEvent me]) {

    _router.navigate(AppRotas.iniciativaDetalheRoute.toUrl(parameters: { AppRotas.iniciativaChaveParameter: item != null ? item.chave : null}));

    if (me != null)
      me.stopPropagation();
  }

}