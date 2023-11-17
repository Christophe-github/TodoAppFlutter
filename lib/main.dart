

import 'package:flutter/material.dart';
import 'routes/go_router.dart' as router;
import 'ui/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp.router(
      // scrollBehavior: ScrollConfiguration.of(context).copyWith(physics: const BouncingScrollPhysics()),
      routerConfig: router.router,
      title: 'Todo App Flutter',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
