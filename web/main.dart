// Copyright (c) 2017, Administrador. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:auge/app_component.dart';
import 'package:http/browser_client.dart';

// ignore_for_file: uri_has_not_been_generated
import 'main.template.dart' as ng;

void main() {

  bootstrapStatic(AppComponent, [
    routerProviders,
    // We use this instead of <base href="/" /> to make local development
    // nicer (i.e. load "styles.css" relatively).
    const Provider(APP_BASE_HREF, useValue: '/'),
    new Provider(Window, useValue: window),
    // Remove next line in production
    provide(LocationStrategy, useClass: HashLocationStrategy),
    provide(BrowserClient, useFactory: () => new BrowserClient(), deps: [])], ng.initReflector);

/*
  bootstrap(AppComponent, [
      routerProviders,
      // Remove next line in production
      provide(LocationStrategy, useClass: HashLocationStrategy),
      provide(BrowserClient, useFactory: () => new BrowserClient(), deps: [])]);
*/
}
