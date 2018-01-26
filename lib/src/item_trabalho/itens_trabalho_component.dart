// Copyright (c) 2018, Levius.
// Samuel Schwebel

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:auge/model/item_trabalho.dart';
import 'package:auge/src/item_trabalho/item_trabalho_service.dart';

import 'package:auge/services/app_rotas.dart';

// ignore_for_file: uri_has_not_been_generated
import 'package:auge/src/app_layout/app_layout_home.template.dart' as app_layout_home;
import 'package:auge/src/item_trabalho/item_trabalho_detalhe_component.template.dart' as item_trabalho_detalhe_component;
import 'package:auge/src/iniciativa/iniciativa_detalhe_component.template.dart' as iniciativa_detalhe_component;

@Component(
    selector: 'auge-itens-trabalho',
    providers: const [ItemTrabalhoService],
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
    ],
    templateUrl: 'itens_trabalho_component.html',
    styleUrls: const [
      'itens_trabalho_component.css'
    ])

class ItensTrabalhoComponent implements OnInit, OnActivate {

  final List<RouteDefinition> rotas = [

    new RouteDefinition(
        routePath: AppRotas.appLayoutHomeRoute,
        component: app_layout_home.AppLayoutHomeComponentNgFactory,
        useAsDefault: true
    ),

    new RouteDefinition(
      routePath: AppRotas.itemTrabalhoDetalheAdicionarRoute,
      component: item_trabalho_detalhe_component.ItemTrabalhoDetalheComponentNgFactory,
      // useAsDefault: true
    ),

    new RouteDefinition(
      routePath: AppRotas.itemTrabalhoDetalheRoute,
      component: item_trabalho_detalhe_component.ItemTrabalhoDetalheComponentNgFactory,
      // useAsDefault: true
    ),
  ];

  final ItemTrabalhoService _itemTrabalhoService;
  final Router _router;
  String _chaveIniciativaSelecionada;

  List<ItemTrabalho> itensTrabalho;

  ItensTrabalhoComponent(this._itemTrabalhoService, this._router);

  @override
  ngOnInit() async {
  }

  @override
  Future onActivate(routeStateprevious, routeStatecurrent) async {
print('entrou no onactivate*******');
    _chaveIniciativaSelecionada = routeStatecurrent.parameters[AppRotas.iniciativaChaveParameter];

    print(_chaveIniciativaSelecionada);

    if (_chaveIniciativaSelecionada != null && _chaveIniciativaSelecionada.isNotEmpty) {
      itensTrabalho = await _itemTrabalhoService.recuperarItensTrabalho(chave_iniciativa: _chaveIniciativaSelecionada);
    } else {
      itensTrabalho = new List();
    }
  }

  void navegarPara(ItemTrabalho item) {
    String url;
    if (item == null) {
      url = AppRotas.itemTrabalhoDetalheAdicionarRoute.toUrl(parameters: {
        AppRotas.iniciativaChaveParameter: _chaveIniciativaSelecionada
      });
    } else {
      url = AppRotas.itemTrabalhoDetalheRoute.toUrl(parameters: {
        AppRotas.iniciativaChaveParameter: _chaveIniciativaSelecionada,
        AppRotas.itemTrabalhoChaveParameter: item.chave
      });
    }
    print(url);
    _router.navigate(url);

   }
}