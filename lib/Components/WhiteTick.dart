import 'package:flutter/material.dart';

class Tick extends StatelessWidget {
  final DecorationImage image;
  Tick({this.image});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      height: 250.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
       // image: image,
      ),
      child: Text("MyOrg",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 46),),
    ));
  }
}
