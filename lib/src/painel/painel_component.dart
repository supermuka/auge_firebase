// Copyright (c) 2017, Levius.

import 'package:angular/angular.dart';
import 'package:auge/src/app_layout/app_layout_service.dart';


@Component(
  selector: 'auge-painel',
  styleUrls: const ['painel_component.css'],
  templateUrl: 'painel_component.html',
  directives: const [
    CORE_DIRECTIVES,
  ],
  providers: const [],
)

class PainelComponent implements OnInit {

  AppLayoutService _appLayoutService;

  PainelComponent(this._appLayoutService);

  @override
  ngOnInit() {
    _appLayoutService.buscaHabilitada = false;
  }
}