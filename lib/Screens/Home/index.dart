import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myorg/Screens/update_profile.dart';
import 'package:myorg/Screens/view_fees_transictions.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
    pageBuilder: (context, animation1, animation2) => page,
    transitionsBuilder: (context, animation1, animation2, child) {
      return FadeTransition(opacity: animation1, child: child);
    },
  );
}
class HomeScreen extends StatefulWidget {
  final data;
  const HomeScreen({Key key, this.data}) : super(key: key);
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  Color primiryColor = Colors.deepOrangeAccent.shade100;
  @override
  void initState() {
    super.initState();
    orgdata = getOrgData();
    updateData();
  }
  final Duration animationDuration = Duration(milliseconds: 300);
  final Duration delay = Duration(milliseconds: 300);
  //List<GlobalKey> rectGetterKey;
  Rect rect;

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned( //<--replace Positioned with AnimatedPositioned
      duration: animationDuration, //<--specify the animation duration
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:primiryColor,
        ),
      ),
    );
  }
  updateData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(widget.data!=null){
      preferences.setBool('loged', true);
      preferences.setString('data', widget.data);
      user_name = jsonDecode(widget.data)['response']['FullName'];
      user_email = jsonDecode(widget.data)['response']['Email'];
    }else{
      setState(() {
        user_name = jsonDecode(preferences.getString('data'))['response']['FullName'];
        user_email = jsonDecode(preferences.getString('data'))['response']['Email'];
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
  List<Map> colors = [
    {"color":Colors.deepOrangeAccent.shade100,"image":"assets/b/b1.jpg",},
    {"color":Colors.deepPurpleAccent.shade100,"image":"assets/b/b2.jpg",},
    {"color":Colors.redAccent.shade100,"image":"assets/b/b3.jpg",},
    {"color":Colors.pink.shade200,"image":"assets/b/b4.jpg",}
  ];
  List primiryColors = [
    Colors.deepOrangeAccent.shade100,
    Colors.indigo.shade400,
   // Color(0xffffd0d8),
    Colors.deepPurpleAccent.shade100,
    Colors.redAccent.shade100,
  ];
  PageController _pageController = PageController(initialPage:0);
  int currentIndex = 0;
  bool adding = true,enableOrgEditing=false;
  Future orgdata;
  String org_name,user_name,user_email;
  var dio = Dio();
  getOrgData() async {
      FormData formData = new FormData.fromMap({
        "id":"1",
      });
      var response = await dio.post("http://192.168.0.100:8081/cenply/services/organization/get", data: formData);
      print(response.data);
      setState(() {
        org_name = jsonDecode(response.data)['response']['OrgName'];
      });
      return jsonDecode(response.data);
  }
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mob = TextEditingController();
  TextEditingController alt_mob = TextEditingController();
  TextEditingController addr = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conf_password = TextEditingController();
  final formKay = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return (new WillPopScope(
      onWillPop: () async {
        return true;
      },
      //Color(0xffffd0d8)
      child: Stack(
        children: [
          new Scaffold(
            backgroundColor:primiryColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor:primiryColor,
              titleSpacing: 0,
            ),
            drawer: Drawer(
              child: Stack(
                    children: [
                      Container(
                        child: ListView(
                          shrinkWrap:true,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage("assets/bg.jpg"),fit: BoxFit.cover)
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal:8.0,vertical:20),
                                color:primiryColor.withOpacity(0.5),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: primiryColor,
                                      child: Icon(CupertinoIcons.person,color: Colors.white,),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("$user_name",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                          Text("$user_email",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400)),
                                          Text("$org_name",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400))
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfile())),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white,width: 2),
                                          borderRadius: BorderRadius.all(Radius.circular(25))
                                        ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Edit  ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:12)),
                                          Icon(Icons.edit_outlined,color: Colors.white,size:10,),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: currentIndex==0?primiryColor:Colors.white,
                                elevation:currentIndex==0?10:0,
                                child: ListTile(
                                  onTap: (){
                                    _pageController.jumpToPage(0);
                                    Navigator.pop(context);
                                  },
                                  leading:Icon(Icons.dashboard_outlined,color:currentIndex==0?Colors.white:Colors.grey[900]),
                                  title: Text("Dashboard",style: TextStyle(color:currentIndex==0?Colors.white:Colors.grey[900]),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: currentIndex==1?primiryColor:Colors.white,
                                elevation:currentIndex==1?10:0,
                                child: ListTile(
                                  onTap: (){
                                    _pageController.jumpToPage(1);
                                    Navigator.pop(context);
                                  },
                                  leading:Icon(Icons.person_add_alt_1_outlined,color:currentIndex==1?Colors.white:Colors.grey[900]),
                                  title: Text("Add Member",style: TextStyle(color:currentIndex==1?Colors.white:Colors.grey[900]),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: currentIndex==2?primiryColor:Colors.white,
                                elevation:currentIndex==2?10:0,
                                child: ListTile(
                                  onTap: (){
                                    _pageController.jumpToPage(2);
                                    Navigator.pop(context);
                                  },
                                  leading:Icon(Icons.account_balance,color:currentIndex==2?Colors.white:Colors.grey[900]),
                                  title: Text("Organization Profile",style: TextStyle(color:currentIndex==2?Colors.white:Colors.grey[900]),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: currentIndex==3?primiryColor:Colors.white,
                                elevation:currentIndex==3?10:0,
                                child: ListTile(
                                  onTap: (){
                                    _pageController.jumpToPage(3);
                                    Navigator.pop(context);
                                  },
                                  leading:Icon(Icons.account_balance_wallet_outlined,color:currentIndex==3?Colors.white:Colors.grey[900]),
                                  title: Text("Fees Payments",style: TextStyle(color:currentIndex==3?Colors.white:Colors.grey[900]),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: ListTile(
                          leading:Icon(Icons.logout),
                          title: Text("Logout"),
                        ),
                      ),
                    ],
                  ),
            ),
            body:PageView(
              controller: _pageController,
              onPageChanged: (index){
                setState(() {
                  currentIndex = index;
                  primiryColor = primiryColors[index];
                });
              },
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height:height,
                      child:Stack(
                            children: [
                              Container(
                                height: height*0.35,
                                width: width,
                                child:Image.asset('assets/bg.jpg',fit: BoxFit.cover,)
                              ),
                              Container(
                                height: height*0.35,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          primiryColor,
                                          primiryColor.withOpacity(0.5),
                                          primiryColor.withOpacity(0.4),
                                          primiryColor.withOpacity(0.2),
                                        ]
                                    )
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                  height: height*0.35,
                                  child:Image.asset('assets/pay.gif',height:height*0.3)
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Text("Welcome to MyOrg",style: TextStyle(color: Colors.white,fontSize:26,fontWeight: FontWeight.w500),),
                                    Text("hello user tag line",style: TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.w200),),
                                  ],
                                ),
                              ),
                            ],
                          )
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top:height*0.25),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight: Radius.circular(25))
                            ),
                            child: ListView(
                              shrinkWrap:true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color:Colors.grey[400],
                                      child: SizedBox(height:6,width:40,),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text("Pending Transactions",style: TextStyle(fontSize:20,fontWeight: FontWeight.w400,color: Colors.grey[400]),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GridView.builder(
                                      shrinkWrap:true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                      itemCount:10,
                                      itemBuilder:(context,index){
                                        final rectGetterKey = RectGetter.createGlobalKey();
                                        var col = colors[Random().nextInt(colors.length)];
                                        Color color = col['color'];
                                        return RectGetter(
                                          key:rectGetterKey,
                                          child: GestureDetector(
                                            onTap: ()async {
                                              setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));  //<-- set rect to be size of fab
                                              WidgetsBinding.instance.addPostFrameCallback((_) {                //<-- on the next frame...
                                                setState(() =>
                                                rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide)); //<-- set rect to be big
                                                Future.delayed(animationDuration + delay, (){
                                                  Navigator.of(context)
                                                      .push(FadeRouteBuilder(page: ViewFeesTransitions()))
                                                      .then((_) => setState(() => rect = null));
                                                }); //<-- after delay, go to next page
                                              });
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                              color:col['color'],
                                              child: Container(
                                                height: 200,
                                                width: 200,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: width*0.5-9,
                                                      width: width*0.5-9,
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                                        image: DecorationImage(image:AssetImage(col['image']),fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: width*0.5-9,
                                                      width: width*0.5-9,
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        //color:color.withOpacity(0.8),
                                                          gradient: LinearGradient(
                                                              begin: Alignment.topCenter,
                                                              end: Alignment.bottomCenter,
                                                              colors: [
                                                                color.withOpacity(0.8),
                                                                color.withOpacity(0.8),
                                                                color.withOpacity(0.8),
                                                                color
                                                              ]
                                                          ),
                                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text("\$300",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:32),),
                                                          Text("Start Date 12/02/2021",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize:12),),
                                                          Text("End Date 12/03/2021",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize:12),),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: width*0.5-9,
                                                      alignment: Alignment.bottomCenter,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Container(
                                                            height:40,
                                                            // width: width*0.25-9,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Icon(CupertinoIcons.square_arrow_up,color:Colors.white,size:18),
                                                                Text(" Pay",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 20),),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height:40,
                                                            // width: width*0.25-9,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Icon(CupertinoIcons.square_arrow_down,color:Colors.white,size:18),
                                                                Text(" Receive",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 20),),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  ),
                                )
                              ],
                            )
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  color:Colors.white,
                  child: Stack(
                    children: [
                      Align(
                        alignment:Alignment.bottomCenter,
                        child: Container(
                          height: 250,
                          alignment:Alignment.bottomCenter,
                          decoration: BoxDecoration(
                              image: DecorationImage(image:AssetImage('assets/orgg.png'),fit: BoxFit.fitWidth)
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal:30.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    primiryColor,
                                    primiryColor.withOpacity(0.5),
                                    primiryColor.withOpacity(0.2),
                                    primiryColor.withOpacity(0.0)
                                  ]
                              )
                          ),
                          child: Form(
                            key: formKay,
                            child: ListView(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Add Member to your",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Colors.white),),
                                      Text("Organization",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 30,color: Colors.white),),
                                    ],
                                  ),
                                ),
                                SizedBox(height:30),
                                TextFormField(
                                  controller: name,
                                  decoration: InputDecoration(
                                    labelText: "Name",
                                    filled: true,
                                    fillColor: primiryColor.withOpacity(0.5),
                                    labelStyle: TextStyle(color: Colors.white,fontSize:14),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                  validator: (v){
                                    if(v.isEmpty){
                                      return "Enter Name";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height:15),
                                TextFormField(
                                  controller: email,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    filled: true,
                                    fillColor: primiryColor.withOpacity(0.5),
                                    labelStyle: TextStyle(color: Colors.white,fontSize:14),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                  validator: (v){
                                    if(v.isEmpty){
                                      return "Enter Email";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height:15),
                                TextFormField(
                                  controller: addr,
                                  decoration: InputDecoration(
                                    labelText: "Address",
                                    filled: true,
                                    fillColor: primiryColor.withOpacity(0.5),
                                    labelStyle: TextStyle(color: Colors.white,fontSize:14),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                  validator: (v){
                                    if(v.isEmpty){
                                      return "Enter Address";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height:15),
                                TextFormField(
                                  controller: mob,
                                  decoration: InputDecoration(
                                    labelText: "Mobile No",
                                    filled: true,
                                    fillColor: primiryColor.withOpacity(0.5),
                                    labelStyle: TextStyle(color: Colors.white,fontSize:14),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                  validator: (v){
                                    if(v.isEmpty){
                                      return "Enter Mobile No.";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height:15),
                                TextFormField(
                                  controller: alt_mob,
                                  decoration: InputDecoration(
                                    labelText: "Alt. Mobile No",
                                    filled: true,
                                    fillColor: primiryColor.withOpacity(0.5),
                                    labelStyle: TextStyle(color: Colors.white,fontSize:14),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                  validator: (v){
                                    if(v.isEmpty){
                                      return "Enter Mobile No.";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height:15),
                                TextFormField(
                                  controller: password,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    filled: true,
                                    fillColor: primiryColor.withOpacity(0.5),
                                    labelStyle: TextStyle(color: Colors.white,fontSize:14),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                  validator: (v){
                                    if(v.isEmpty){
                                      return "Enter Password";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height:15),
                                TextFormField(
                                  controller: conf_password,
                                  decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    filled: true,
                                    fillColor: primiryColor.withOpacity(0.5),
                                    labelStyle: TextStyle(color: Colors.white,fontSize:14),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                  validator: (v){
                                    if(v!=password.text){
                                      return "Password and confirm password not matched !";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height:15),
                                GestureDetector(
                                  onTap: () async {
                                    if(formKay.currentState.validate()){
                                    var dio = Dio();
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    Map data = jsonDecode(pref.getString('data'))['response'];
                                    setState((){
                                      adding= false;
                                    });
                                    try {
                                      FormData formData = new FormData.fromMap({
                                        "OrgID":data['OrgID'],
                                        "Password":password.text,
                                        "FullName":name.text,
                                        "Address":addr.text,
                                        "Email":email.text,
                                        "MobileNumber":mob.text,
                                        "MobileNumber2":alt_mob.text,
                                        "ValidFrom":DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                        "ValidTo":DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                        "CreatedBy":data['UserID'],
                                        "CreatedOn":DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                       // "ModifiedBy":name.text,
                                       // "ModifiedOn":name.text,
                                      });
                                      var response = await dio.post("http://192.168.0.100:8081/cenply/services/user/register", data: formData);
                                      print(response.data);
                                      if(jsonDecode(response.data)['success']==true) {
                                        if (jsonDecode(response.data)['response'].toString() != "[]") {
                                          setState(() {
                                             name.text = "";
                                             email.text = "";
                                             mob.text = "";
                                             alt_mob.text = "";
                                             addr.text = "";
                                             password.text = "";
                                             conf_password.text = "";
                                          });
                                          showCupertinoDialog(
                                              context: context, builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: Text("Registration Successful !"),
                                              //content: Text("Username and Password not matched !"),
                                              actions: [
                                                FlatButton(onPressed: () =>
                                                    Navigator.pop(context),
                                                    child: Text("Ok")),
                                                FlatButton(onPressed: () =>
                                                    Navigator.pop(context),
                                                    child: Text("View")),
                                              ],
                                            );
                                          });
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
                                        adding = false;
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
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("Add Member",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image:AssetImage('assets/bbg.png'),fit: BoxFit.cover)
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primiryColor,
                          primiryColor.withOpacity(0.8),
                          primiryColor.withOpacity(0.6),
                          primiryColor.withOpacity(0.4)
                        ]
                      )
                    ),
                    padding: EdgeInsets.symmetric(horizontal:20),
                    child: FutureBuilder(
                      future: orgdata,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return OrgUpdate(data: snapshot.data);
                        }else{
                          return Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      }
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Text("Fees Transactions",style: TextStyle(fontSize:20,fontWeight: FontWeight.w400,color: Colors.grey[400]),),
                        ),
                        GridView.builder(
                            shrinkWrap:true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemCount:10,
                            itemBuilder:(context,index){
                              var col = colors[Random().nextInt(colors.length)];
                              Color color = col['color'];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color:col['color'],
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: width*0.5-9,
                                        width: width*0.5-9,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                          image: DecorationImage(image:AssetImage(col['image']),fit: BoxFit.cover),
                                        ),
                                      ),
                                      Container(
                                        height: width*0.5-9,
                                        width: width*0.5-9,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            //color:color.withOpacity(0.8),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                color.withOpacity(0.8),
                                                color.withOpacity(0.8),
                                                color.withOpacity(0.8),
                                                color
                                              ]
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(15))
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("\$300",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:32),),
                                            Text("Start Date 12/02/2021",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize:12),),
                                            Text("End Date 12/03/2021",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize:12),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: width*0.5-9,
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              height:40,
                                             // width: width*0.25-9,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(CupertinoIcons.square_arrow_up,color:Colors.white,size:18),
                                                  Text(" Pay",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 20),),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height:40,
                                             // width: width*0.25-9,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(CupertinoIcons.square_arrow_down,color:Colors.white,size:18),
                                                  Text(" Receive",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 20),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _ripple(),
        ],
      ),
    ));
  }
}
class OrgUpdate extends StatefulWidget {
  final data;
  const OrgUpdate({Key key, this.data}) : super(key: key);
  @override
  _OrgUpdateState createState() => _OrgUpdateState();
}
class _OrgUpdateState extends State<OrgUpdate> {
  TextEditingController name_org = TextEditingController();
  TextEditingController email_org = TextEditingController();
  TextEditingController mob_org = TextEditingController();
  TextEditingController addr_org = TextEditingController();
  final formKayOrg = GlobalKey<FormState>();
  bool updating_org=true,enableOrgEditing= false;
  @override
  void initState() {
    name_org.text = "${widget.data['response']['OrgName']}";
    email_org.text = "${widget.data['response']['ContactPerson']}";
    mob_org.text = "${widget.data['response']['ContactNumber']}";
    addr_org.text = "${widget.data['response']['Address']}";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key:formKayOrg,
      child: ListView(
        children: [
          ListTile(
            title: Text("Your Organization",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.white),),
            trailing: IconButton(
              icon: Icon(Icons.edit_outlined,color: Colors.white,),
              onPressed: () {
                setState(() {
                  enableOrgEditing = !enableOrgEditing;
                });
              },
            ),
          ),
          SizedBox(height:30),
          TextFormField(
            enabled: enableOrgEditing,
            controller: name_org,
            decoration: InputDecoration(
              labelText: "Name",
              filled: true,
              fillColor: Colors.deepPurple.shade300,
              labelStyle: TextStyle(color: Colors.white,fontSize:14),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
            ),
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
            validator: (v){
              if(v.isEmpty){
                return "Enter Name";
              }else{
                return null;
              }
            },
          ),
          SizedBox(height:15),
          TextFormField(
            enabled: enableOrgEditing,
            controller: email_org,
            decoration: InputDecoration(
              labelText: "Contact Person",
              filled: true,
              fillColor: Colors.deepPurple.shade300,
              labelStyle: TextStyle(color: Colors.white,fontSize:14),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
            ),
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
            validator: (v){
              if(v.isEmpty){
                return "Enter Email";
              }else{
                return null;
              }
            },
          ),
          SizedBox(height:15),
          TextFormField(
            enabled: enableOrgEditing,
            controller: addr_org,
            decoration: InputDecoration(
              labelText: "Address",
              filled: true,
              fillColor: Colors.deepPurple.shade300,
              labelStyle: TextStyle(color: Colors.white,fontSize:14),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
            ),
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
            validator: (v){
              if(v.isEmpty){
                return "Enter Address";
              }else{
                return null;
              }
            },
          ),
          SizedBox(height:15),
          TextFormField(
            enabled: enableOrgEditing,
            controller: mob_org,
            decoration: InputDecoration(
              labelText: "Mobile No",
              filled: true,
              fillColor: Colors.deepPurple.shade300,
              labelStyle: TextStyle(color: Colors.white,fontSize:14),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2)),
            ),
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
            validator: (v){
              if(v.isEmpty){
                return "Enter Mobile No.";
              }else{
                return null;
              }
            },
          ),
          SizedBox(height:15),
          enableOrgEditing?GestureDetector(
            onTap: () async {
              if(formKayOrg.currentState.validate()){
                var dio = Dio();
                SharedPreferences pref = await SharedPreferences.getInstance();
                Map data = jsonDecode(pref.getString('data'))['response'];
                setState((){
                  updating_org= false;
                });
                try {
                  FormData formData = new FormData.fromMap({
                    "OrgID":data['OrgID'],
                    "user_data": jsonEncode({
                      "OrgName":name_org.text,
                      "Address":addr_org.text,
                      "ContactPerson":email_org.text,
                      "ContactNumber":mob_org.text,
                      "ModifiedBy": data['UserID'],
                      "ModifiedOn": DateFormat('dd/MM/yyyy').format(DateTime.now())
                    })
                  });
                  var response = await dio.post("http://192.168.0.100:8081/cenply/services/organization/update", data: formData);
                  print(response.data);
                  if(jsonDecode(response.data)['success']==true) {
                    if (jsonDecode(response.data)['response'].toString() != "[]") {
                      setState(() {
                        name_org.text = "";
                        email_org.text = "";
                        mob_org.text = "";
                        addr_org.text = "";
                        enableOrgEditing = false;
                      });
                    } else {
                      setState(() {
                        updating_org = true;
                      });
                      showCupertinoDialog(
                          context: context, builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("Updating Failed !"),
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
                      updating_org = true;
                    });
                    showCupertinoDialog(
                        context: context, builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text("Updating Failed !"),
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
                    updating_org = false;
                  });
                  print(e);
                  showCupertinoDialog(context: context, builder: (context){
                    return CupertinoAlertDialog(
                      title: Text("Updating Failed !"),
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
              ),
              alignment: Alignment.center,
              child: Text("Update",style: TextStyle(color: Colors.deepPurpleAccent,fontWeight: FontWeight.bold,fontSize:18),),
            ),
          ):SizedBox(),
        ],
      ),
    );
  }
}
