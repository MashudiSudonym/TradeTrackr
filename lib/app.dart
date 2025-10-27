import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:trade_trackr/presentation/provider/router/router_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadApp.custom(
      themeMode: ThemeMode.system,
      theme: ShadThemeData(
        colorScheme: ShadNeutralColorScheme.light(),
        brightness: Brightness.light,
      ),
      darkTheme: ShadThemeData(
        colorScheme: ShadNeutralColorScheme.dark(),
        brightness: Brightness.dark,
      ),
      appBuilder: (context) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: Theme.of(context),
          routeInformationParser: ref
              .watch(routerProvider)
              .routeInformationParser,
          routeInformationProvider: ref
              .watch(routerProvider)
              .routeInformationProvider,
          routerDelegate: ref.watch(routerProvider).routerDelegate,
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
        );
      },
    );
  }
}
