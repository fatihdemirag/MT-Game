import 'package:flutter/material.dart';
import 'package:mtgame/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String highScore="";

  @override
  void initState() {
    _getSharedPreferences("highScore").then((value){

      setState(() {
        if(value==null)
          highScore="0";
        else
          highScore=value;
      });
    }).catchError((onError){
      setState(() {
        highScore="0";
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width *0.9,
              margin: EdgeInsets.fromLTRB(10,50,10,10),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: primary

              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Skorunuz",style: boldNumberTransaction),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('${arguments["score"]}', style: resultNumber),
                  ),
                  Column(
                    children: <Widget>[
                      Text('En Yüksek Skor ',style: headlines),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${highScore}",style: headlines),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

          InkWell(
            onTap: () => Navigator.pushNamedAndRemoveUntil(context,"/",(r)=>false),
            child: Container(
              color: primaryButtonColor,
              margin: EdgeInsets.only(top: 10.0),
              height: MediaQuery.of(context).size.height * 0.2,
              padding: EdgeInsets.only(bottom: 45),
              child: Center(
                child: Text('Yeniden Oyna', style: secondaryButtonColorStyle),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
Future<String> _getSharedPreferences(String getValue) async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  return sharedPreferences.getString(getValue);
}