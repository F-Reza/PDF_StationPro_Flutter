import 'package:flutter/material.dart';
import 'package:pdf_station/view/home_screen.dart';
import 'view/create_pdf_screen.dart';
import 'widgets/main_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Station Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        //useMaterial3: true,
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        MainDrawer.routeName : (_) => const MainDrawer(),
        HomeScreen.routeName : (_) => const HomeScreen(),
        CreatePDFScreen.routeName : (_) => const CreatePDFScreen(),
      },
    );
  }
}