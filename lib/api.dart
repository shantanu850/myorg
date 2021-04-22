class Api{
  bool debug = true;
  String getUrl(){
    if(!debug){
      var url = "https://staging.tcmstunner.com/MyOrg/services/";
      print("release_mode");
      return url;
    }else{
      var url = "http://192.168.0.103:8081/cenply/services/";
      print("debug_mode");
      return url;
    }
  }
}