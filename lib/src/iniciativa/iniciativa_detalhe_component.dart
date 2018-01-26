// Copyright (c) 2017, Levius.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:auge/model/iniciativa.dart';
import 'package:auge/services/constante.dart';
import 'package:auge/src/iniciativa/iniciativa_service.dart';

import 'package:auge/services/app_rotas.dart';

@Component(
    selector: 'auge-iniciativa-detalhe',
    providers: const [IniciativaService],
    directives: const [
      CORE_DIRECTIVES,
      routerDirectives,
      AutoFocusDirective,
      materialDirectives,
      MaterialInputComponent,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialDialogComponent,
      ModalComponent,
    ],
    templateUrl: 'iniciativa_detalhe_component.html',
    styleUrls: const [
      'iniciativa_detalhe_component.css'
    ])


class IniciativaDetalheComponent implements OnInit, OnActivate {

  final IniciativaService _iniciativaService;
  final Location _location;
  final Router _router;

  Iniciativa iniciativa = new Iniciativa();

  IniciativaDetalheComponent(this._iniciativaService, this._location, this._router);

  get msgValorRequerido => Constante.msgValorRequerido;


  @override
  ngOnInit() async {

  }

  @override
  Future onActivate(_, __) async {

    print('iniciativa');
    print(_router.current.parameters);
    print(_router.current.parameters[AppRotas.iniciativaChaveParameter]);

    var chave = _router.current.parameters[AppRotas.iniciativaChaveParameter];

    if (chave != null && chave.isNotEmpty) {
      List<Iniciativa> iniciativas = await _iniciativaService.recuperarIniciativas(chave: chave);
      iniciativa = iniciativas.first;
    }

  }

  Future<Null> salvar() async {
    await _iniciativaService.salvarIniciativa(iniciativa);

    navegarParaLista();
  }

  Future<Null> excluir() async {
    try {
      await _iniciativaService.excluirIniciativa(iniciativa);
      navegarParaLista();
    } catch(e) {
      print(e);
    }
  }

  void voltar() {
    _location.back();
  }

  Future<Null> navegarParaLista() async {
    _router.navigate(AppRotas.iniciativasRoute.toUrl());

    // Passa data e hora apenas para ativar o OnInit do pai... Possível bug, pois o navigate deveria ativar o OnInit
  // await _router.navigate(['../../Iniciativas', { 'horaAtual': new DateTime.now()}]);

  }
}