import 'package:angular/core.dart';

@Injectable()
class BuscaService {

  String _termoBusca = '';

  String get termoBusca {
    return _termoBusca;
  }

  set termoBusca(String termo) {
    _termoBusca = termo;
  }

}