// Copyright (c) 2017, Levius.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:angular_components/angular_components.dart';
import 'package:auge/services/firebase_service.dart';
import 'package:auge/src/autenticacao/autenticacao_component.dart';
import 'package:auge/src/autenticacao/autenticacao_service.dart';
import 'package:auge/src/busca/busca_component.dart';
import 'package:auge/src/app_layout/app_layout_service.dart';
import 'package:auge/src/busca/busca_service.dart';

import 'package:auge/services/app_rotas.dart';

// ignore_for_file: uri_has_not_been_generated
import 'package:auge/src/painel/painel_component.template.dart' as painel_component;
import 'package:auge/src/empresa/empresas_component.template.dart' as empresas_component;
import 'package:auge/src/conta_empresa/conta_empresa_component.template.dart' as conta_empresa;
import 'package:auge/src/iniciativa/iniciativas_component.template.dart' as iniciativas;
import 'package:auge/src/item_trabalho/itens_trabalho_component.template.dart' as itens_trabalho;
import 'package:auge/src/iniciativa/iniciativa_detalhe_component.template.dart' as iniciativa_detalhe_component;
import 'package:auge/src/item_trabalho/item_trabalho_detalhe_component.template.dart' as item_trabalho_detalhe_component;


@Component(
    selector: 'auge-layout',
    providers: const <dynamic>[AppLayoutService, AutenticacaoService, BuscaService],
    directives: const [
      CORE_DIRECTIVES,
      routerDirectives,
      DeferredContentDirective,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialTemporaryDrawerComponent,
      MaterialToggleComponent,
      MaterialDropdownSelectComponent,
      MaterialSelectDropdownItemComponent,
      MaterialSelectComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      BuscaComponent,
      AutenticacaoComponent,
       formDirectives,

    ],
    templateUrl: 'app_layout_component.html',
    styleUrls: const [
      'app_layout_component.css',
      'package:angular_components/app_layout/layout.scss.css',
    ])

/*
@RouteConfig(const [
  const Redirect(path: '/', redirectTo: const ['Painel']),
  const Route(path: '/painel', name: 'Painel', component: PainelComponent, useAsDefault: true),
  const Route(path: '/empresas/...', name: 'Empresas', component: EmpresasComponent),
  const Route(path: '/contas_empresa', name: 'ContasEmpresa', component: ContaEmpresaComponent),
  const Route(path: '/iniciativas/...', name: 'Iniciativas', component: IniciativasComponent),
  const Route(path: '/itens_trabalho/:chave_iniciativa/...', name: 'ItensTrabalho', component: ItensTrabalhoComponent),

])

*/

class AppLayoutComponent implements OnInit {

  final List<RouteDefinition> rotas = [
    new RouteDefinition(
        routePath: AppRotas.painelRoute,
        component: painel_component.PainelComponentNgFactory,
       // useAsDefault: true
    ),
    new RouteDefinition(
      routePath: AppRotas.empresasRoute,
      component: empresas_component.EmpresasComponentNgFactory,
    ),
    new RouteDefinition(
      routePath: AppRotas.contasEmpresaRoute,
      component: conta_empresa.ContaEmpresaComponentNgFactory,
    ),
    new RouteDefinition(
      routePath: AppRotas.iniciativasRoute,
      component: iniciativas.IniciativasComponentNgFactory,
    ),
    new RouteDefinition(
      routePath: AppRotas.itensTrabalhoRoute,
      component: itens_trabalho.ItensTrabalhoComponentNgFactory,
    ),
/*
    new RouteDefinition(
      routePath: AppRotas.iniciativaDetalheRoute,
      component: iniciativa_detalhe_component.IniciativaDetalheComponentNgFactory,
      // useAsDefault: true
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
*/
/*
    new RouteDefinition.redirect(
      path: '.*', // Regex
      redirectTo: AppRotas.painelRoute.toUrl(),
    ),
*/
  ];


  final AppLayoutService _appLayoutService;

  Router _router;

  String opcaoMenuAtual;

  List<OptionGroup<OpcaoEmpresaGerenciamento>> empresas = new List();
  SelectionOptions empresaOptions;

  SelectionModel empresaSingleSelectModel;

  //String ultimaOpcaoEmpresaGerenciar;

  AppLayoutComponent(this._appLayoutService, this._router);


  @override
  ngOnInit() async {

    _appLayoutService.buscaHabilitada = false;

    List<OpcaoEmpresaGerenciamento> eee = new List();

    if (AutenticacaoService.autenticadoEmpresas != null && AutenticacaoService.autenticadoEmpresas.isNotEmpty) {
      AutenticacaoService.autenticadoEmpresas.forEach((e) =>
      eee.add(new OpcaoEmpresaGerenciamento()
      ..nome = e.nome
      ..empresa_chave = e.chave
      ..codigo = null));
    }
    empresas.add(new OptionGroup.withLabel(eee, 'Empresa'));

    if (ehAdministrador) {
        List<OpcaoEmpresaGerenciamento> ggg = new List();
        ggg.add(new OpcaoEmpresaGerenciamento()
          ..nome = 'Empresa'
          ..empresa_chave = null
          ..codigo = 'Empresas');
        ggg.add(new OpcaoEmpresaGerenciamento()
          ..nome = 'Conta'
          ..empresa_chave = null
          ..codigo = 'ContasEmpresa');
        empresas.add(new OptionGroup.withLabel(ggg, 'Gerenciar'));
    }
    List<OpcaoEmpresaGerenciamento> sss = new List();
    sss.add(new OpcaoEmpresaGerenciamento()
      ..nome = 'Sair'
      ..empresa_chave = null
      ..codigo = 'SAIR');
    empresas.add(new OptionGroup.withLabel(sss, null));

    empresaOptions = new SelectionOptions.withOptionGroups(empresas);

    empresaSingleSelectModel =
    new SelectionModel.withList(selectedValues: [empresaOptions.optionsList.first])..selectionChanges.listen((d) {

      FirebaseService.empresaSelecionada = d.first.added.first.empresa_chave;
      navegarPara(d.first.added.first.codigo);

    });

    FirebaseService.empresaSelecionada = empresaOptions.optionsList.first.empresa_chave;
    //vaiPara(empresaOptions.optionsList.first.codigo);

  }


  bool get ehAdministrador {
    return AutenticacaoService.ehAdministrador;
  }

  get opcaoMenuAtualDescricao {
    String omad;
    if (opcaoMenuAtual == 'Empresas')
      omad = 'Empresa';
    else if (opcaoMenuAtual == 'ContasEmpresa')
      omad = 'Conta';
    else if (opcaoMenuAtual == 'Iniciativas')
      omad = 'Iniciativas';
    else if (opcaoMenuAtual == 'IniciativaDetalhe')
      omad = 'Iniciativa';
    else if (opcaoMenuAtual == 'ItensTrabalho')
      omad = 'Itens de Trabalho';
    else if (opcaoMenuAtual == 'ItemTrabalhoDetalhe')
      omad = 'Item de Trabalho';
    return omad;
  }

  bool estahAutenticado() {
    if (!AutenticacaoService.autenticado) {
      opcaoMenuAtual = null;
    }

    return AutenticacaoService.autenticado;
  }

  void sairAutenticado() {
    AutenticacaoService.sairAutenticacao();
  }

  /*
  void definirOpcaoMenu(String om) {
    if (om == 'SAIR') {
      opcaoMenuAtual = 'PAINEL';
      sairAutenticado();
    } else {
      opcaoMenuAtual = om;
    }
  }
  */

  Future navegarPara(String om) {

    opcaoMenuAtual = om;
    print(om);
    if (om == 'iniciativas')  {
      print("iniciativas chamada");

      _router.navigate(AppRotas.iniciativasRoute.toUrl());
    }
  }

  bool get possuiEmpresaSelecionada {
    return FirebaseService.empresaSelecionada != null;
  }

  ItemRenderer get itemRenderer => (dynamic item) => item.nome;

// Label for the button for single selection.
  String get singleSelectEmpresaLabel {
    String nomeLabel;
    if ((empresaSingleSelectModel != null) &&
        (empresaSingleSelectModel.selectedValues != null) &&
        (empresaSingleSelectModel.selectedValues.length > 0)) {

      if (empresaSingleSelectModel.selectedValues.first.codigo == 'Empresas' || empresaSingleSelectModel.selectedValues.first.codigo == 'ContasEmpresa') {
        nomeLabel = 'Gerenciar > ' + empresaSingleSelectModel.selectedValues.first.nome;
      } else {
        nomeLabel = empresaSingleSelectModel.selectedValues.first.nome;
      }
    } else {
      nomeLabel = 'Selecione';
    }

    return nomeLabel ;
  }

  get buscaHabilitada {
    return _appLayoutService.buscaHabilitada;
  }

  void navegarParaItensTrabalho() {
    print('KKKKKKKKKKKKKKKKKKKKKKKKKKKK');

    var url = AppRotas.itensTrabalhoRoute.toUrl(parameters: {
      AppRotas.iniciativaChaveParameter: '123'});
    print(url);
    _router.navigate(AppRotas.itensTrabalhoRoute.toUrl(parameters: {
      AppRotas.iniciativaChaveParameter: '123'}));

  }
}

class OpcaoEmpresaGerenciamento {
  String nome;
  String empresa_chave;
  String codigo;
}