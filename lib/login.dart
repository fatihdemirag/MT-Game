import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueGrey,
                      Colors.red,
                      Colors.white
                    ])),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'MT Game',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontFamily: 'Open Sans',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
              FlatButton(
                padding: EdgeInsets.all(10),
                child:  Text(
                  'Oyna',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontFamily: 'Open Sans',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: (){

                },
              )
            ],
          )
        ],
      ),
    );

  }
}
