import 'package:flutter/material.dart';
import 'package:myorg/Screens/Home/index.dart';
import 'package:myorg/Screens/Login/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(new MaterialApp(
    key: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: 'MyOrg',
    theme: ThemeData(
      primarySwatch: Colors.deepOrange,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: Loader(),
  ));
}
class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}
class _LoaderState extends State<Loader> {
  Future future;
  Future future2;
  Future<SharedPreferences> getUser()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }
  @override
  void initState() {
    future = getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<SharedPreferences>(
          future:getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              if (snapshot.data.getBool('loged')??false != true) {
                if(snapshot.data.getString('data')!=null) {
                  return HomeScreen();
                }else{
                  return LoginScreen();
                }
              } else {
                return LoginScreen();
              }
            } else {
              return Container(
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          }
      ),
    );
  }
}