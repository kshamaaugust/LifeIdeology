import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';
// import 'login.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:convert';

class Splash extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<Splash> {
  // final storage = new FlutterSecureStorage();
  // var user;
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 1),
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => HomePage())));
  }
  // getData()  async{
  //   var readData   = await storage.read(key: 'loginData');
  //   if(readData == null){
  //     Navigator.push(  
  //       this.context,  
  //       MaterialPageRoute(builder: (context) => LoginPage()),  
  //     );
  //   }
  //   var jsonLogin  = json.decode(readData);
  //   user  = jsonLogin['username'];
  //   if(user != null){
  //     Navigator.push(  
  //       this.context,  
  //       MaterialPageRoute(builder: (context) => homePage()),  
  //     );
  //   }
  //   else{
  //     Navigator.push(  
  //       this.context,  
  //       MaterialPageRoute(builder: (context) => LoginPage()),  
  //     );
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/li45.png'),
      ),
    );
  }
}