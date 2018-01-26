// Copyright (c) 2017, Levius.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:auge/model/empresa.dart';
import 'package:auge/model/conta.dart';
import 'package:auge/services/firebase_service.dart';
import 'package:auge/services/constante.dart';
import 'package:auge/src/empresa/empresa_service.dart';
import 'package:auge/src/conta_empresa/conta_empresa_service.dart';

@Component(
    selector: 'auge-conta-empresa',
    providers: const <dynamic>[materialProviders, EmpresaService, ContaEmpresaService],
    directives: const [
      CORE_DIRECTIVES,
      materialDirectives,
      MaterialInputComponent,
      MaterialFabComponent,
      MaterialButtonComponent,
      MaterialIconComponent,
    ],
    templateUrl: 'conta_empresa_component.html',
    styleUrls: const [
      'conta_empresa_component.css'
    ])

class ContaEmpresaComponent implements OnInit {

  final EmpresaService _empresaService;
  final ContaEmpresaService _contaEmpresaService;

  get msgValorRequerido => Constante.msgValorRequerido;

  List<Empresa> empresas = new List();
  List<ContaViewModel> contas = new List();

  SelectionModel empresaSelectModel = new SelectionModel.withList(selectedValues: [null]);

  ContaEmpresaComponent(this._empresaService, this._contaEmpresaService);

  @override
  ngOnInit() async {
    empresas = await _empresaService.recuperarEmpresas();
    List<Conta> c = await _contaEmpresaService.recuperarContas();

    if (c!= null) {
      c.forEach((i){ contas.add(new ContaViewModel(i)); });
    }
  }

  @override
  OnDestroy() {

  }

  salvarConta(int i)  {
      FirebaseService.salvarConta(contas[i].conta);
  }

  excluirConta(int i) async {
    //contas[i].conta.deletado = true;
    await FirebaseService.excluirConta(contas[i].conta);
    contas.removeAt(i);
  }

  void adicionarConta() {
    contas.add(new ContaViewModel(new Conta()));
  }


  SelectionOptions get empresaOptions {
    if (empresas.length > 0)

      return new SelectionOptions.fromList(empresas);
    else
      return new SelectionOptions(null);
  }

  ItemRenderer get empresaItemRenderer => (dynamic item) => item.nome;


  String get singleSelectEmpresaLabel {
    if ((empresaSelectModel != null) &&
        (empresaSelectModel.selectedValues != null) &&
        (empresaSelectModel.selectedValues.length > 0)) {
      return empresaSelectModel.selectedValues.first.nome;
    } else {
      return 'Selecione Empresa';
    }
  }

  void excluirEmpresa(int i, int ii) {
    contas[i].conta.empresas.removeAt(ii);
  }

  void adicionarEmpresa(int i) {
    contas[i].conta.empresas.add(empresaSelectModel.selectedValues.first);
  }

  desabilitarAdicionarEmpresa(int i) {
    if (contas != null && contas[i].conta != null && contas[i].conta.empresas != null && empresaSelectModel != null && empresaSelectModel.selectedValues.length > 0 ) {
      bool b = false;
      contas[i].conta.empresas.forEach((f) {
        if (f == empresaSelectModel.selectedValues.first) {
          b = true;
        }
      });

      return b;
    } else {
      return true;
    }
  }

  void modeloAlterado(int i, bool alterado) {
    contas[i].conta.alterado = alterado;
  }

  bool desabilitarSalvar(int i) {
    return !contas[i].conta.alterado || contas[i].conta.nome == null || contas[i].conta.nome.trim().isEmpty;
  }

  bool desabilitarCancelar(int i) {
    return !contas[i].conta.alterado;
  }

  cancelarConta(int i) async {
    try {
      if (contas[i].conta.chave != null) {
        List<Conta> conts = await _contaEmpresaService.recuperarContas(
            chave: contas[i].conta.chave);
        contas[i].conta = conts.first;
      } else {
        contas[i].conta  = new Conta();
      }
    } catch(e) {
      print(e);
    }
  }

}

class ContaViewModel {

  bool detalhe = false;

  Conta conta;

  ContaViewModel(Conta conta) {
     this.conta = conta;
  }
}
