import 'package:flutter/material.dart';
import 'package:pokedex_test_project/project_data/project_data.dart';
import 'package:pokedex_test_project/screens/tabbar_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProjectData(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TabBarScreen(),
      ),
    );
  }
}