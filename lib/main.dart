import 'package:flutter/material.dart';
import 'package:quarantine_dex/tools/util.dart';
import "package:quarantine_dex/screens/Home.dart";

void main() {
  runApp(DexApp());
}

class DexApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Quarantine Dex',
      theme: ThemeData(
        primarySwatch: themeColor,
      ),
      home: Home(title: "Quarantine Dex"),
    );
  }
}