import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:versus_match/presentation/pages/splash_page.dart';
import 'package:versus_match/presentation/pages/login_page.dart';
import 'package:versus_match/presentation/pages/register_page.dart';
import 'package:versus_match/presentation/pages/home_page.dart';
import 'package:versus_match/presentation/pages/challenge_page.dart';
import 'package:versus_match/presentation/pages/create_team_page.dart'; // 👈 Agregado

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Versus Match',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (context) => const SplashPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        HomePage.routeName: (context) => const HomePage(),
        ChallengePage.routeName: (context) => const ChallengePage(),
        CreateTeamPage.routeName: (context) => const CreateTeamPage(), // 👈 Agregado
      },
    );
  }
}