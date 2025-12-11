import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_providers.dart';
import 'routes/routes.dart';

void main() {
  runApp(AppProviders.providers(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tesoro Nft',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: Routes.router,
    );
  }
}
