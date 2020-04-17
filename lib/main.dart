import 'package:flutter/material.dart';
import 'package:mtgame/result.dart';

import 'game.dart';

void main()
{
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/":(context)=>Game(),
//      "/game":(context)=>Game(),
      "/result":(context)=>Result(),
    },
  ));
}