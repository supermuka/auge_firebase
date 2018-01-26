// Copyright (c) 2017, Levius.

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';

import 'package:auge/model/item_trabalho.dart';
import 'package:auge/model/conta.dart';
import 'package:auge/services/constante.dart';
import 'package:auge/src/item_trabalho/item_trabalho_service.dart';

import 'package:auge/services/app_rotas.dart';

@Component(
    selector: 'auge-item-trabalho-detalhe',
    providers: const [ItemTrabalhoService],
    directives: const [
      CORE_DIRECTIVES,
      routerDirectives,
      AutoFocusDirective,
      ModalComponent,
      materialDirectives,
      materialInputDirectives,
      materialNumberInputDirectives,
      formDirectives,
      MaterialNumberValidator,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialDialogComponent,
      MaterialAutoSuggestInputComponent,
      MaterialChipsComponent,
      MaterialChipComponent,
    ],
    templateUrl: 'item_trabalho_detalhe_component.html',
    styleUrls: const [
      'item_trabalho_detalhe_component.css'
    ])

class ItemTrabalhoDetalheComponent implements OnInit, OnActivate  {

  final ItemTrabalhoService _itemTrabalhoService;
  final Router _router;
  final Location _location;

  ItemTrabalho itemTrabalho = new ItemTrabalho();

  String membroInputText = '';
  SelectionOptions membroOptions;
  SelectionModel membroSingleSelectModel;

  String leadingGlyph = 'search';

  String label = 'Buscar Membro';
  String emptyPlaceholder = 'Sem correspondência';

  List<Conta> membros = new List();

  List<Conta> _contas;

  String errorPercentualConcluido;

  ItemTrabalhoDetalheComponent(this._itemTrabalhoService, this._router, this._location)  {



    initializeDateFormatting(Intl.defaultLocale , null);

    //Mock
    _contas = new List()..add(new Conta()..nome = 'Samuel Schwebel')..add(new Conta()..nome = 'Micheli Schwebel');

    membroOptions = new StringSelectionOptions<Conta>(
        _contas, toFilterableString: (Conta conta) => conta.nome);
  }

  get msgValorRequerido => Constante.msgValorRequerido;

  @override
  ngOnInit() async {
    itemTrabalho.dataInicio = new DateTime.now();
    itemTrabalho.dataFim = new DateTime.now();
  }

  @override
  Future onActivate(b, a) async {

    print('entrou no onActivate');

    var chave_iniciativa = _router.current.parameters[AppRotas
        .iniciativaChaveParameter];

    var chave = _router.current.parameters[AppRotas.itemTrabalhoChaveParameter];

    print('chave');
    print(chave);

    if (chave != null && chave.isNotEmpty) {
      List<ItemTrabalho> itensTrabalho = await _itemTrabalhoService.recuperarItensTrabalho(chave: chave);
      itemTrabalho = itensTrabalho.first;
    }

    itemTrabalho.chave_iniciativa = chave_iniciativa;

    membroSingleSelectModel =
    new SelectionModel.withList(allowMulti: false, selectedValues: [null])
      ..selectionChanges.listen((c) {

        if (c.isNotEmpty && c.first.added != null && c.first.added.length != 0 && c.first.added?.first != null) {
          if (!itemTrabalho.colaboradores.contains(c.first.added.first)) {
            itemTrabalho.colaboradores.add(c.first.added.first);
          }

        }

      });
  }

  removerColaborador(Conta c) {
    itemTrabalho.colaboradores.remove(c);
  }

  Future<Null> salvar() async {
    await _itemTrabalhoService.salvarItemTrabalho(itemTrabalho);
    voltar();
  }

  Future<Null> excluir() async {
    try {
      await _itemTrabalhoService.excluirItemTrabalho(itemTrabalho);
      voltar();
    } catch(e) {
      print(e);
    }
  }

  void fechar() {
    voltar();
  }

  void voltar() {
    _location.back();
  }

  String get membroLabelRenderer {
    String nomeLabel;
    print('aaa');
    if ((membroSingleSelectModel != null &&
        membroSingleSelectModel.selectedValues != null &&
        membroSingleSelectModel.selectedValues.length != null)) {

      nomeLabel = membroSingleSelectModel.selectedValues.first.nome;
    }

    return nomeLabel;
  }

  ItemRenderer get membroItemRenderer => (dynamic conta) => conta.nome;

  String get dataInicioStr {
    print('get dataInicioStr');
    print(itemTrabalho.dataInicio);

    var formatter = new DateFormat('yyyy-MM-dd');

    //var formatter = new DateFormat('dd-MM-yyyy');
    var ds = itemTrabalho.dataInicio == null ? null : formatter.format(itemTrabalho.dataInicio);
    print(ds);
    return ds;
  }

  void set dataInicioStr(String date) {
    print('set dataInicioStr');
    print(date);

    var formatter = new DateFormat('yyyy-MM-dd');

   itemTrabalho.dataInicio = formatter.parse(date);

    //dataInicio = DateTime.parse(date);
    print(itemTrabalho.dataInicio);
  }

  String get dataFimStr {
    var formatter = new DateFormat('dd-MM-yyyy');
    return itemTrabalho.dataFim == null ? null : formatter.format(itemTrabalho.dataFim);
  }

  void set dataFimStr(String date) {
    print(date);
    var formatter = new DateFormat('yyyy-MM-dd');
    itemTrabalho.dataFim = formatter.parse(date);
  }

  int get percentualConcluido {
    return itemTrabalho.percentualConcluido;
  }

  void set percentualConcluido(int percentualConcluido) {
    if (percentualConcluido != null && !(percentualConcluido >= 0 && percentualConcluido <= 100)) {
      errorPercentualConcluido = 'O percentual deve ficar entre 0 e 100';
    } else {
      errorPercentualConcluido = null;
      itemTrabalho.percentualConcluido = percentualConcluido;
    }

  }
}