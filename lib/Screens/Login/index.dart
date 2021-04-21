import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myorg/Components/AnimatedWave.dart';
import 'package:myorg/Screens/Home/index.dart';
import 'package:myorg/api.dart';
import '../../main.dart';
import 'styles.dart';
import 'loginAnimation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../Components/SignUpLink.dart';
import '../../Components/SignInButton.dart';
import '../../Components/WhiteTick.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        title: new Text('Are you sure?'),
        actions: <Widget>[
        new FlatButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: new Text('No'),
        ),
        new FlatButton(
        onPressed: () =>
        Navigator.pushReplacementNamed(context, "/home"),
        child: new Text('Yes'),
        ),
        ],
        );
      },
        ) ??
        false;
  }
  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: [
            Positioned.fill(child: Container(
                decoration: new BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/wbg.jpg'),fit:BoxFit.cover),
                ),
                child: new Container(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                          colors: <Color>[
                            Colors.blue.withOpacity(0.4),
                            Colors.blue.withOpacity(0.4),
                          ],
                          stops: [0.2, 1.0],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.0, 1.0),
                        )),
                    child: new ListView(
                      padding: const EdgeInsets.all(0.0),
                      children: <Widget>[
                        new Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Tick(image: tick),
                                new Container(
                                  margin: new EdgeInsets.symmetric(horizontal: 20.0),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Form(
                                          child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              new Container(
                                                decoration: new BoxDecoration(
                                                  border: new Border(
                                                    bottom: new BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white24,
                                                    ),
                                                  ),
                                                ),
                                                child: new TextFormField(
                                                  controller: username,
                                                  obscureText: false,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: new InputDecoration(
                                                    icon: new Icon(
                                                      Icons.person_outline,
                                                      color: Colors.white,
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: "username",
                                                    hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
                                                  ),
                                                ),
                                              ),
                                              new Container(
                                                decoration: new BoxDecoration(
                                                  border: new Border(
                                                    bottom: new BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white24,
                                                    ),
                                                  ),
                                                ),
                                                child: new TextFormField(
                                                  obscureText: true,
                                                  controller: password,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: new InputDecoration(
                                                    icon: new Icon(
                                                      Icons.lock_outline,
                                                      color: Colors.white,
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: "password",
                                                    hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                new SignUp()
                              ],
                            ),
                            animationStatus == 0
                                ? new Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: new InkWell(
                                  onTap: () async {
                                    setState(() {
                                      animationStatus = 1;
                                    });
                                    _playAnimation();
                                    var dio = Dio();
                                    try {
                                      FormData formData = new FormData.fromMap({
                                        "username":username.text,
                                        "password":password.text
                                      });
                                      var response = await dio.post(Api().getUrl()+"user/login", data: formData);
                                      print(response.data);
                                      if(jsonDecode(response.data)['response'].toString()!="[]") {
                                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen(data:response.data)));
                                      }else{
                                        setState((){
                                          animationStatus = 0;
                                        });
                                        showCupertinoDialog(context: context, builder: (context){
                                          return CupertinoAlertDialog(
                                            title: Text("Login Failed !"),
                                            content: Text("Username and Password not matched !"),
                                            actions: [
                                              FlatButton(onPressed: ()=>Navigator.pop(context), child:Text("Ok"))
                                            ],
                                          );
                                        });
                                      }
                                      return response.data;
                                    } catch (e) {
                                      setState(() {
                                        animationStatus = 0;
                                      });
                                      print(e);
                                      showCupertinoDialog(context: context, builder: (context){
                                        return CupertinoAlertDialog(
                                          title: Text("Login Failed !"),
                                          content: Text("$e"),
                                          actions: [
                                            FlatButton(onPressed: ()=>Navigator.pop(context), child:Text("Ok"))
                                          ],
                                        );
                                      });
                                    }
                                  },
                                  child: new SignIn()),
                            )
                                : new StaggerAnimation(
                                username:username.text,
                                password:password.text,
                                buttonController:
                                _loginButtonController.view),
                          ],
                        ),
                      ],
                    )))),
            onBottom(AnimatedWave(
              height: 180,
              speed: 0.4,
            )),
            onBottom(AnimatedWave(
              height: 120,
              speed: 0.3,
              offset: pi,
            )),
            onBottom(AnimatedWave(
              height: 220,
              speed: 0.5,
              offset: pi / 2,
            )),
          ],
        ),
        ));
  }
}
