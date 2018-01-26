import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'busca_service.dart';


@Component(
  selector: 'auge-busca',
  styleUrls: const ['busca_component.css'],
  templateUrl: 'busca_component.html',
  directives: const [
    CORE_DIRECTIVES,
    formDirectives,
    materialDirectives,
    MaterialInputComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
  ],
  //providers: const [BuscaService],
)

class BuscaComponent implements OnInit {

  final BuscaService _buscaService;

  BuscaComponent(this._buscaService);

  @override
  Future<Null> ngOnInit() async {
    // AutenticacaoService.inicializarFireBase();
  }

  get termoBusca {
    return _buscaService.termoBusca;
  }

  set termoBusca(String termo) {
    _buscaService.termoBusca = termo;
  }
}
