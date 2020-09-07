import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.instance.settings().then((_) {
    print("Timestamps enabled in snapshots\n");
  }, onError: (_) {
    print("Error enabling timestamps in snapshots\n");
  });
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Writy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Home(),
    );
  }
}
