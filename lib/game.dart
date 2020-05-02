import 'dart:async';
import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:mtgame/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

String appId="ca-app-pub-9361831426651608~1855814756";
String bannerId="ca-app-pub-9361831426651608/1810672590";

class _GameState extends State<Game> {
  String score="0";
  String operation="";

  int time=15;
  int firstNumber=0;
  int secondNumber=0;
  int result=0;
  int highScore;
  int star=0;

  Color successColor0,successColor1,successColor2,successColor3;
  Color starColor;

  List<int> resultArray = new List(4);

  Timer timer;

  BannerAd bannerAd;

  void timerStart()
  {
    timer=Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) => setState(
            () {
          if (time < 1) {
            timer.cancel();

            Navigator.pushNamedAndRemoveUntil(context, "/result",(r)=>false,arguments: {"star":star,"score":score});
          } else {
            time = time - 1;
          }
        },
      ),
    );
  }
  reCalculate()
  {
    successColor0=primary;
    successColor1=primary;
    successColor2=primary;
    successColor3=primary;

    firstNumber=Random.secure().nextInt(99)==0?1:Random.secure().nextInt(99);
    secondNumber=Random.secure().nextInt(10)==0?1:Random.secure().nextInt(10);

    int operationRand=Random.secure().nextInt(3);
    switch(operationRand)
    {
      case 0:
        operation="+";
        result=firstNumber+secondNumber;
        break;
      case 1:
        operation="-";
        result=firstNumber-secondNumber;
        break;
      case 2:
        operation="*";
        result=firstNumber*secondNumber;
        break;
      case 3:
        operation="/";
        result=(firstNumber%secondNumber!=0?reCalculate():firstNumber/secondNumber);
        break;
    }


    resultArray[0]=(Random.secure().nextInt(result+5))==0?(Random.secure().nextInt(result+5)):(Random.secure().nextInt(result+5));
    resultArray[1]=(Random.secure().nextInt(result+9))==0?(Random.secure().nextInt(result+9)):(Random.secure().nextInt(result+9));
    resultArray[2]=(Random.secure().nextInt(result+10))==0?(Random.secure().nextInt(result+10)):(Random.secure().nextInt(result+10));
    resultArray[3]=result;

    resultArray.shuffle();

  }

  int correctNumber=0;
  resultSuccess()
  {
    // ignore: unrelated_type_equality_checks
    if(operation=="+"|| operation=="-")
      score=(int.parse(score)+1).toString();
    else
      score=(int.parse(score)+2).toString();

    correctNumber++;

    setState(() {
      if(correctNumber>3)
      {
        if(star==0)
          starColor=Colors.amberAccent;
        star++;
        correctNumber=0;
      }
    });
    time=15;

    _sharedPreferences("star",star.toString());
  }
  resultUnSuccess()
  {
    _getSharedPreferences("highScore").then((value){
      if(int.parse(score)>int.parse(value) || int.parse(score)==int.parse(value))
        _sharedPreferences("highScore",score);
    }).catchError((onError){
      _sharedPreferences("highScore",score);
    });

    _sharedPreferences("star",star.toString());
  }
  starClick()
  {
    setState(() {
      if(star>0)
        star--;
      else
        showAlertDialog("Altınınız kalmamış.","3 soru bilirseniz 1 altın kazanabilirsiniz.");
    });

    _sharedPreferences("star",star.toString());

    reCalculate();
    time=15;
  }

  Future<void> showAlertDialog(String title,String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: secondaryButtonColor,
          titleTextStyle: TextStyle(
            color: Colors.white
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message,style: TextStyle(
                    color: Colors.white
                ),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Tamam',style: TextStyle(
                  color: Colors.white
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void dispose() {
    timer.cancel();
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {

    setState(() {

      reCalculate();

      timerStart();

      _getSharedPreferences("star").then((value){
        debugPrint(value);
        star=int.parse(value);

        if(int.parse(value)>0)
          starColor=Colors.amberAccent;

      }).catchError((onError){
        star=0;
      });

    });


    FirebaseAdMob.instance.initialize(appId: appId);
    bannerAd = createBannerAd()..load()..show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: primary,
        body:
        SingleChildScrollView(
          child:         Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left:10,right: 5),
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: primary
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Puan',style: headlines),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("$score",style: boldNumber),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white10,
                                  size: 18.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left:5.0,right: 10),
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: primary
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Süre',style: headlines),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${time.toString()}",style: boldNumber),
                                ),
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white10,
                                  size: 18.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child:GestureDetector(
                            child:Container(
                              margin: EdgeInsets.only(left:5.0,right: 10),
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: primary
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Yıldız',style: headlines),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("$star",style: boldNumber),
                                  ),
                                  Icon(
                                    Icons.stars,
                                    color: starColor!=null?starColor:Colors.white10,
                                    size: 18.0,
                                  ),
                                ],
                              ),
                            ),
                            onTap: ()=>starClick(),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(left:10.0,right: 10.0,top: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: primary
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Text('${firstNumber} ${operation} ${secondNumber}',style: boldNumberTransaction)
                              ],
                            ),

                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: successColor0 != null ? successColor0:primary,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text('${resultArray[0]}',style: boldNumber)
                                ],
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                if(resultArray[0]==result)
                                {
                                  successColor0=success;
                                  resultSuccess();
                                }
                                else
                                {
                                  successColor0=unsuccess;
                                  Navigator.pushNamedAndRemoveUntil(context, "/result",(r)=>false,arguments: {"star":star,"score":score});

                                  resultUnSuccess();
                                }

                                Future.delayed(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    reCalculate();
                                  });
                                });
                              });
                            },
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: successColor1 != null ? successColor1:primary,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text('${resultArray[1]}',style: boldNumber)
                                ],
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                if(resultArray[1]==result)
                                {
                                  successColor1=success;
                                  resultSuccess();
                                }
                                else
                                {
                                  successColor1=unsuccess;
                                  Navigator.pushNamedAndRemoveUntil(context, "/result",(r)=>false,arguments: {"star":star,"score":score});
                                  resultUnSuccess();
                                }

                                Future.delayed(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    reCalculate();
                                  });
                                });
                              });
                            },
                          ),
                        )

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: successColor2 != null ? successColor2:primary,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text('${resultArray[2]}',style: boldNumber)
                                ],
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                if(resultArray[2]==result)
                                {
                                  successColor2=success;
                                  resultSuccess();
                                }
                                else
                                {
                                  successColor2=unsuccess;
                                  Navigator.pushNamedAndRemoveUntil(context, "/result",(r)=>false,arguments: {"star":star,"score":score});
                                  resultUnSuccess();
                                }
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    reCalculate();
                                  });
                                });
                              });
                            },
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: successColor3 != null ? successColor3:primary,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text('${resultArray[3]}',style: boldNumber)
                                ],
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                if(resultArray[3]==result)
                                {
                                  successColor3=success;
                                  resultSuccess();
                                }
                                else
                                {
                                  successColor3=unsuccess;
                                  Navigator.pushNamedAndRemoveUntil(context, "/result",(r)=>false,arguments: {"star":star,"score":score});
                                  resultUnSuccess();
                                }
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    reCalculate();
                                  });
                                });
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
          ,
        )
    );
  }
}
_sharedPreferences(String key,var value) async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  sharedPreferences.setString(key,value);
}
Future<String> _getSharedPreferences(String getValue) async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  return sharedPreferences.getString(getValue);
}
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['mathematic', 'matematik','game'],
  contentUrl: 'https://fatihdemirag.net',
  birthday: DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>["8A4B46F00AB99D16E61FD645F4FD1EFB"], // Android emulators are considered test devices
);

BannerAd createBannerAd() {
  return BannerAd(
      adUnitId: bannerId,
      //Change BannerAd adUnitId with Admob ID
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd $event");
      });
}