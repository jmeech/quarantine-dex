import 'package:flutter/material.dart';
import "package:quarantine_dex/screens/Home.dart";
import 'package:quarantine_dex/tools/AppDB.dart';

void main() {
  runApp(DexApp());
}

class DexApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    AppDB().initDB();

    return MaterialApp(
      title: 'Quarantine Dex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: "Quarantine Dex"),
    );
  }
}