import 'package:flutter/material.dart';
import 'package:galaxysfassigment/pages/home.dart';
import 'package:galaxysfassigment/pages/purchase.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/" : (context) =>  const Home(),
      "/Purchase" : (context) => const Purchase(),
    },
  ));
}
