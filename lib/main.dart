import 'package:flutter/material.dart';
import 'package:my_daly_activities/home/home.dart';

void main(){
  runApp(MyApplication());
}

class MyApplication extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),

    );
  }
}