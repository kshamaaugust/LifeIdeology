import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'home.dart';
import 'journal.dart';
import 'signUp.dart';
import 'tracker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'assessment.dart';
import 'package:device_id/device_id.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}
class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();  
  final storage = new FlutterSecureStorage();
  var jsonData, id;

  @override
  login(String Username, String Password) async{
    Map data = {
      'username': Username,
      'password': Password
    };
    var response = await http.post("http://139.59.66.2:9001/api/v1/login/", body: data);
    if(response.statusCode == 200){
      jsonData = json.decode(response.body);
      print(jsonData);
      id = (jsonData['data']['id']).toString();
      await storage.write(key: 'loginData', value: json.encode(jsonData['data']));
      String deviceId = await DeviceId.getID;
      await http.get("http://139.59.66.2:9001/api/v1/update/user-data/?user="+id+"&device_id="+deviceId+"");
      var resultData  = await storage.read(key: 'resultData');           // read result API data 
      if (resultData == null){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      else{
        // var resultData1 = json.decode(resultData);
        // resultData1['device_id'] = device_id;
        // var forResult = await http.post("http://139.59.66.2:9001/api/v1/result/", body: json.encode(resultData1), headers: <String, String>{'authorization':  "Token "+token, "Content-Type": "application/json"});
        // var resultJson = json.decode(forResult.body);
        // if(forResult.statusCode == 201) {
        //   await storage.delete(key: 'resultData');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => resultPage()),
          );
        // }
      }
      var reportData  = await storage.read(key: 'reportData');           // read tracker report API data 
      if (reportData == null){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportPage()),
        );
      }
      var journalData  = await storage.read(key: 'journalData');           // read tracker report API data 
      if (journalData == null){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => journalsecPage()),
        );
      }
    }
    else{
      AlertDialog alert = AlertDialog(
        title: new Text("Simple Alert"),
        content: new Text("Invalid Username and Password", style: TextStyle(color: Colors.red),),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    setState(() { jsonData; });
  }
  @override	
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),),
              Image.asset('assets/images/li45.png',width: 70, height: 120),            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 0.0),
              child: new Text('Login To Your Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 20.0),
              child: TextField(
                autofocus: false,
                controller: nameController,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  hintText: 'Email',
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
              child: TextField(
                obscureText: true, autofocus: false,
                controller: passwordController,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white, hoverColor: Colors.white,
                  hintText: 'Password',
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                  
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 20),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 20),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
              ),
            ),
            Row(children: [
              Container(
                height: 70.0,
                padding: EdgeInsets.fromLTRB(90,10,20,0),
                child: RaisedButton(
                  onPressed: () => login(nameController.text, passwordController.text),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xff863bfa), Color(0xffA93EED)],
                          begin: Alignment.centerLeft, end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(40.0)
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 170.0, minHeight: 90.0),
                      alignment: Alignment.center,
                      child: Text("Sign in", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22),),
                    ),
                  ),
                ),
              ),
            ]),
            Container(
              padding: EdgeInsets.fromLTRB(140,15,0,0),
              child: Text('or sign in with',style: TextStyle(color: Colors.grey,fontSize: 14),),
            ),
            Row(children: [
              Padding(padding: EdgeInsets.fromLTRB(110,70,0,0),),
              SignInButton(
                Buttons.Google, mini: true,
                onPressed: () {},
              ),
              SignInButton(
                Buttons.Facebook, mini: true,
                onPressed: () {},
              ),
              SignInButton(
                Buttons.Twitter, mini: true,
                onPressed: () {},
              ),
            ]),
            Row(children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(100,20,0,0),
                child: Text("Don't have account?",style: TextStyle(color: Colors.grey,fontSize: 14),),
              ),
              new GestureDetector(
                onTap: () {
                  Navigator.push(  
                    context,  
                    MaterialPageRoute(builder: (context) => SignUpPage()),  
                  );
                },
                child: new Container(
                  padding: EdgeInsets.fromLTRB(0,20,0,0),
                  child: Text('Sign Up',style: TextStyle(color: Colors.purple,fontSize:14),),
                ),
              ),
            ]),
          ],
        )
      )
    );
  }
}  