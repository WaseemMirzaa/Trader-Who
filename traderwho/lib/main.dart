
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


// import 'package:flutter_web_plugins/flutter_web_plugins.dart'

import 'app.dart';
import 'core/cubit/bloc_observer.dart';
import 'core/di/di.dart';




Future<void> main() async {
  // if (kIsWeb) {
  //   setUrlStrategy(PathUrlStrategy());
  // }
  
  await initDI();
  await initRepoDI();
  await initDataDI();
  Bloc.observer = CubitObserver();
  runApp(const App());
}
