import 'package:angular_router/angular_router.dart';

/*
@RouteConfig(const [
  const Redirect(path: '/', redirectTo: const ['Autenticacao']),
  const Route(
      path: '/autenticacao',
      name: 'Autenticacao',
      component: AutenticacaoComponent,
      useAsDefault: true),
  const Route(path: '/app_layout/...', name: 'AppLayout', component: AppLayoutComponent)
])


static const planTypeParameter = 'planType';

static final overviewRoute = new RoutePath(
  path: "overview",
  useAsDefault: true,
);
static final planningRoute = new RoutePath(
  path: "planning/:$planTypeParameter",
);
static final clientRoute = new RoutePath(
  path: "client",
);

*/

class AppRotas {

  //Parametros
  static const empresaChaveParameter = 'chave';
  static const iniciativaChaveParameter = 'chave_iniciativa';
  static const itemTrabalhoChaveParameter = 'chave_item_detalhe';

  static final appRoute = new RoutePath(
    path: 'app',
 //  useAsDefault: true,
  );

  static final autenticacaoRoute = new RoutePath(
    path: 'autenticacao',

  //  useAsDefault: true,
  );

  static final appLayoutRoute = new RoutePath(
    path: 'app_layout',
   // parent: autenticacaoRoute,
  );


  static final painelRoute = new RoutePath(
    path: 'painel',
    useAsDefault: true,
  );
  static final empresasRoute = new RoutePath(
    //path: "empresas/...",
    path: 'empresas',
  );
  static final contasEmpresaRoute = new RoutePath(
    path: 'contas_empresa',
  );
  static final iniciativasRoute = new RoutePath(
    path: 'iniciativas',
    parent: appLayoutRoute
  );

  static final iniciativaDetalheRoute = new RoutePath(
    path: 'iniciativa/:$iniciativaChaveParameter',
    //parent: appLayoutRoute
      parent: iniciativasRoute
  );

  static final itensTrabalhoRoute = new RoutePath(
    path: 'iniciativa/:$iniciativaChaveParameter/itens_trabalho',
    parent: appLayoutRoute
  );

  static final itemTrabalhoDetalheAdicionarRoute = new RoutePath(
    path: 'item_trabalho',
   // path: 'iniciativa/:$iniciativaChaveParameter/item_trabalho',
    //  path: 'item_trabalho/:$itemTrabalhoChaveParameter',
    parent:  itensTrabalhoRoute,
    //   useAsDefault: true
  );

  static final itemTrabalhoDetalheRoute = new RoutePath(
    path: 'item_trabalho/:$itemTrabalhoChaveParameter',
    // path: 'iniciativa/:$iniciativaChaveParameter/item_trabalho/:$itemTrabalhoChaveParameter',
    //  path: 'item_trabalho/:$itemTrabalhoChaveParameter',
    parent:  itensTrabalhoRoute,
 //   useAsDefault: true
  );

  static final teste = new RoutePath(
    path: 'teste',
    // path: 'iniciativa/:$iniciativaChaveParameter/item_trabalho',
    //  path: 'item_trabalho/:$itemTrabalhoChaveParameter',
    parent:  itensTrabalhoRoute,
    additionalData: ':$iniciativaChaveParameter'
    //   useAsDefault: true
  );

  static final appLayoutHomeRoute = new RoutePath(
    path: '',
    useAsDefault: true,
  );

  static final empresaDetalheRoute = new RoutePath(
    path: 'empresa/:$empresaChaveParameter',
  );
}