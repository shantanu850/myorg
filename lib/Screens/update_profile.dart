import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mob = TextEditingController();
  TextEditingController alt_mob = TextEditingController();
  TextEditingController addr = TextEditingController();
  String id;
  final formKay = GlobalKey<FormState>();
  getData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = jsonDecode(preferences.getString('data')) as Map;
    print(data);
    setState(() {
      name.text = data['response']['FullName'];
      email.text = data['response']['Email'];
      mob.text = data['response']['MobileNumber'];
      alt_mob.text = data['response']['MobileNumber2'];
      addr.text = data['response']['Address'];
      id = data['response']['UserID'];
    });
  }
  bool adding = true;
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent.shade100,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,), onPressed: ()=>Navigator.pop(context)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal:30.0),
        child: Form(
          key:formKay,
          child: ListView(
            children: [
              Text("Update Profile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.white),),
              SizedBox(height:30),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Name",
                  filled: true,
                  fillColor: Colors.deepOrange.shade300,
                  labelStyle: TextStyle(color: Colors.white,fontSize:14),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                ),
              ),
              SizedBox(height:15),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.deepOrange.shade300,
                  labelStyle: TextStyle(color: Colors.white,fontSize:14),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                ),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
              SizedBox(height:15),
              TextFormField(
                controller: addr,
                decoration: InputDecoration(
                  labelText: "Address",
                  filled: true,
                  fillColor: Colors.deepOrange.shade300,
                  labelStyle: TextStyle(color: Colors.white,fontSize:14),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                ),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
              SizedBox(height:15),
              TextFormField(
                controller: mob,
                decoration: InputDecoration(
                  labelText: "Mobile No",
                  filled: true,
                  fillColor: Colors.deepOrange.shade300,
                  labelStyle: TextStyle(color: Colors.white,fontSize:14),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                ),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
              SizedBox(height:15),
              TextFormField(
                controller: alt_mob,
                decoration: InputDecoration(
                  labelText: "Alt. Mobile No",
                  filled: true,
                  fillColor: Colors.deepOrange.shade300,
                  labelStyle: TextStyle(color: Colors.white,fontSize:14),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                ),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: adding?GestureDetector(
        onTap:()async{
          if(formKay.currentState.validate()){
            var dio = Dio();
            SharedPreferences preferences = await SharedPreferences.getInstance();
            setState((){
              adding= false;
            });
            try {
              FormData formData = new FormData.fromMap({
                //"OrgID":data['OrgID'],
                "FullName":name.text,
                "Address":addr.text,
                "Email":email.text,
                "MobileNumber":mob.text,
                "MobileNumber2":alt_mob.text,
                //"ValidTo":DateFormat('dd-MM-yyyy').format(DateTime.now()),
                //"CreatedBy":data['UserID'],
                //"CreatedOn":DateFormat('dd-MM-yyyy').format(DateTime.now()),
                 "ModifiedBy":id,
                 "ModifiedOn":DateFormat('dd-MM-yyyy').format(DateTime.now()),
              });
              var response = await dio.post(Api().getUrl()+"user/update?id=$id", data: formData);
              print(response.data);
              if(jsonDecode(response.data)['success']==true) {
                if (jsonDecode(response.data)['response'].toString() != "[]") {
                  preferences.setString('data', response.data);
                  setState(() {
                    name.text = "";
                    email.text = "";
                    mob.text = "";
                    alt_mob.text = "";
                    addr.text = "";
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>UpdateProfile()));
                } else {
                  setState(() {
                    adding = true;
                  });
                  showCupertinoDialog(
                      context: context, builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text("Registration Failed !"),
                      content: Text("Internal Server Error !"),
                      actions: [
                        FlatButton(onPressed: () =>
                            Navigator.pop(context),
                            child: Text("Ok"))
                      ],
                    );
                  });
                }
              }else{
                setState(() {
                  adding = true;
                });
                showCupertinoDialog(
                    context: context, builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text("Registration Failed !"),
                    content: Text("${jsonDecode(response.data)['error']}"),
                    actions: [
                      FlatButton(onPressed: () =>
                          Navigator.pop(context),
                          child: Text("Ok"))
                    ],
                  );
                });
              }
              return response.data;
            } catch (e) {
              setState(() {
                adding = true;
              });
              print(e);
              showCupertinoDialog(context: context, builder: (context){
                return CupertinoAlertDialog(
                  title: Text("Registration Failed !"),
                  content: Text("$e"),
                  actions: [
                    FlatButton(onPressed: ()=>Navigator.pop(context), child:Text("Ok"))
                  ],
                );
              });
            }
          }
        },
        child: Container(
          height: 56,
          color: Colors.white,
          alignment: Alignment.center,
          child: Text("Update Profile",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
        ),
      ):Container(
        height: 56,
        color: Colors.white,
        alignment: Alignment.center,
        child: SizedBox(width:40,height:40,child: CircularProgressIndicator(),),
      ),
    );
  }
}
