import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_providers.dart';
import 'routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  log('🔴 [MAIN] main() called');
  WidgetsFlutterBinding.ensureInitialized();
  log('🔴 [MAIN] WidgetsFlutterBinding initialized');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log('🔴 [MAIN] Firebase initialized');

  runApp(AppProviders.providers(child: MyApp()));
  log('🔴 [MAIN] App providers initialized and runApp called');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tesoro App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // key: navigatorKey,
      debugShowCheckedModeBanner: false,
      routerConfig: Routes.router,
    );
  }
}
