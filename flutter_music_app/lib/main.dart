import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music_app/playing.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
//  SystemUiOverlayStyle systemUiOverlayStyle =
//      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
//  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Music Player',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.white,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (_) => HomePage(),
        '/playing': (_) => PlayingPage(),
      },
    );
  }
}
