import 'package:flutter/material.dart';
import 'styles.dart';
import 'RegisterAnimation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../Components/SignUpLink.dart';
import '../../Components/SignInButton.dart';
import '../../Components/WhiteTick.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);
  @override
  RegisterScreenState createState() => new RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
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
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: backgroundImage,
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: <Color>[
                      const Color.fromRGBO(162, 146, 199, 0.8),
                      const Color.fromRGBO(51, 51, 63, 0.9),
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
                                      onTap: () {
                                        setState(() {
                                          animationStatus = 1;
                                        });
                                        _playAnimation();
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
                  ))),
        )));
  }
}
