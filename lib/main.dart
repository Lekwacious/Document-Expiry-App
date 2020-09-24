import 'package:flutter/material.dart';
import 'package:flutter_app/ui/doclist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
Widget build(BuildContext context){
    return MaterialApp( debugShowCheckedModeBanner: false,
    title: 'DocExpire',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
    home: DocList(),
    );
  }
}