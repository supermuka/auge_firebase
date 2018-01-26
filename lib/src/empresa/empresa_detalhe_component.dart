// Copyright (c) 2017, Levius.

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:auge/model/empresa.dart';
import 'package:auge/services/constante.dart';
import 'package:auge/src/empresa/empresa_service.dart';
import 'package:auge/services/app_rotas.dart';

@Component(
    selector: 'auge-empresa-detalhe',
    providers: const <dynamic>[materialProviders, EmpresaService],
    directives: const [
      CORE_DIRECTIVES,
      routerDirectives,
      AutoFocusDirective,
      ModalComponent,
      materialDirectives,
      MaterialInputComponent,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialDialogComponent,    ],
    templateUrl: 'empresa_detalhe_component.html',
    styleUrls: const [
      'empresa_detalhe_component.css'
    ])

class EmpresaDetalheComponent implements OnInit {

  final EmpresaService _empresaService;
  final Location _location;
  final Router _router;

  Empresa empresa = new Empresa();

  EmpresaDetalheComponent(this._empresaService, this._router, this._location);

  get msgValorRequerido => Constante.msgValorRequerido;

  @override
  ngOnInit() async {
    if (_router.current.parameters.isNotEmpty) {
      var chave = _router.current.parameters[AppRotas.empresaChaveParameter];

      if (chave != null && chave.isNotEmpty) {
      List<Empresa> empresas = await _empresaService.recuperarEmpresas(chave: chave);
      empresa = empresas.first;

      }
    }

   //  empresa = _empresaService.empresaSelecionada;

  }

  Future<Null> salvarEmpresa() async {
    await _empresaService.salvarEmpresa(empresa);
    voltar();
  }

  Future<Null> excluirEmpresa() async {
    try {
      await _empresaService.excluirEmpresa(empresa);
      voltar();
    } catch(e) {
      print(e);
    }
  }

  bool desabilitarSalvar() {
    return !empresa.alterado || empresa.nome == null || empresa.nome.trim().isEmpty;
  }

 // final _fecharDetalhe = new StreamController();
//  @Output()
 // Stream get fecharDetalhe => _fecharDetalhe.stream;

  void fechar() {
    voltar();

  }

  void voltar() {
    _location.back();

  }

}