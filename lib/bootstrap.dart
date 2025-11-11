import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_trackr/constants.dart';
import 'package:trade_trackr/app_observer.dart';

enum Flavors { dev, prod }

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Add cross flavor setup logic here if needed

  // Initialize Flavor Environment
  switch (Constants.appFlavor) {
    case Constants.dev:
      await dotenv.load(fileName: 'assets/${Constants.dev}/.env');
    case Constants.prod:
      await dotenv.load(fileName: 'assets/${Constants.prod}/.env');
    default:
      await dotenv.load(fileName: 'assets/${Constants.prod}/.env');
  }

  // Run the app
  runApp(ProviderScope(observers: [AppObserver()], child: await builder()));
}
