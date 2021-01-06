import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}
class _State extends State<SignUpPage> {
  var token, jsonData;
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController(); 
  TextEditingController cpasController = TextEditingController();
  TextEditingController pasController  = TextEditingController();
  TextEditingController mobController  = TextEditingController(); 
  final storage = new FlutterSecureStorage();

  @override
  login(String Username, String mail, String Password, String cpassword, String mob) async{
    Map data = {
      'username':   Username,
      'email':      mail,
      'password':   Password,
      'cpassword':  cpassword,
      'mobile':     mob,
      'first_name': Username,
      'last_name':  ''
    };
    var response = await http.post("http://139.59.66.2:9001/api/v1/signup/", body: data);
    if(pasController.text != cpasController.text){
      AlertDialog alert1 = AlertDialog(  
        title: new Text("Simple Alert"),  
        content: new Text("Passwords are not same", style: TextStyle(color: Colors.red)),    
        actions: <Widget>[
          new FlatButton(
            onPressed: () { Navigator.of(this.context).pop(); },
            color: Colors.blue,
            child: const Text('Okay'),
          ),
        ],
      ); 
      showDialog(  
        context: context,  
        builder: (BuildContext context) {  
          return alert1;  
        },  
      );       
    }
    else if(response.statusCode == 400){
      AlertDialog alert2 = AlertDialog(  
        title: new Text("Simple Alert"),  
        content: new Text("Already exist username or mobile", style: TextStyle(color: Colors.red)),    
        actions: <Widget>[
          new FlatButton(
            onPressed: () { Navigator.of(this.context).pop(); },
            color: Colors.blue,
            child: const Text('Okay'),
          ),
        ],
      ); 
      showDialog(  
        context: context,  
        builder: (BuildContext context) {  
          return alert2;  
        },  
      );
    }
    else if(response.statusCode == 201){
      print(response.statusCode);
      jsonData = json.decode(response.body);
      print(jsonData);

      token        = (jsonData['token']);
      var user     = (jsonData['username']);
      var mail     = (jsonData['email']);
      var mobile   = (jsonData['mobile']);
      var fn       = (jsonData['first_name']);

      await storage.write(key: 'signFn'   , value: fn);
      await storage.write(key: 'signMail' , value: mail);
      await storage.write(key: 'signUn'   , value: user);
      await storage.write(key: 'signMob'  , value: mobile.toString());
      await storage.write(key: 'signToken', value: token);

      Navigator.push(  
        context,  
        MaterialPageRoute(builder: (context) => HomePage()),  
      ); 

      AlertDialog alert3 = AlertDialog(  
        title: new Text("Simple Alert"),  
        content: new Text("You have signed up.", style: TextStyle(color: Colors.green)),
        actions: <Widget>[
          new FlatButton(
            onPressed: () { Navigator.of(this.context).pop(); },
            color: Colors.blue,
            child: const Text('Okay'),
          ),
        ],
      ); 
      showDialog(  
        context: context,  
        builder: (BuildContext context) {  
          return alert3;  
        },  
      ); 
    }
    else{
      AlertDialog alert = AlertDialog(  
        title: new Text("Simple Alert"),  
        content: new Text("Something going wrong.", style: TextStyle(color: Colors.red)),
        actions: <Widget>[
          new FlatButton(
            onPressed: () { Navigator.of(this.context).pop(); },
            color: Colors.blue,
            child: const Text('Okay'),
          ),
        ],
      ); 
      showDialog(  
        context: context,  
        builder: (BuildContext context) {  
          return alert;  
        },  
      );
    }
    setState(() { token; });
  }
  // bool _isLoggedIn = false;
  // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // googleLogin() async{
  //   try{
  //     await _googleSignIn.signIn();
  //     print("hello");
  //     print(_googleSignIn.currentUser.displayName);
  //     setState(() {
  //       _isLoggedIn = true;
  //     });
  //   } catch (err){
  //     print(err);
  //   }
  // }
  // _logout(){
  //   _googleSignIn.signOut();
  //   setState(() {
  //     _isLoggedIn = false;
  //   });
  // }
  @override	
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black), backgroundColor: Colors.transparent, bottomOpacity: 0.0, elevation: 0.0,
      ),
      body: Center(
        child: ListView(children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 40.0)),
          Image.asset('assets/images/li45.png',width: 70,height: 120),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 5.0),
            child: TextField(
              autofocus: false,
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Name',
                contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),

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
            padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 5.0),
            child: TextField(
              autofocus: false,
              controller: mailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),

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
            padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 5.0),
            child: TextField(
              obscureText: true,
              autofocus: false,
              controller: pasController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),

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
            padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 5.0),
            child: TextField(
              obscureText: true,
              autofocus: false,
              controller: cpasController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                hintText: 'Confirm Password',
                contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 5.0),
            child: TextField(
              autofocus: false,
              controller: mobController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                hintText: 'Mobile',
                contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                
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
              height: 60.0,
              padding: EdgeInsets.fromLTRB(100,10,20,0),
              child: RaisedButton(
                onPressed: () => login(nameController.text, mailController.text, pasController.text, cpasController.text, mobController.text),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                padding: EdgeInsets.fromLTRB(0,0,0,0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xff863bfa), Color(0xffA93EED)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 160.0, minHeight: 90.0),
                    alignment: Alignment.center,
                    child: Text("Sign up", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22),),
                  ),
                ),
              ),
            ),
          ]),
          Container(
            padding: EdgeInsets.fromLTRB(140,10,0,0),
            child: Text('or sign up with',style: TextStyle(color: Colors.black,fontSize: 14),),
          ),
          Row(children: [
            Padding(padding: EdgeInsets.fromLTRB(110,60,0,0),),
            SignInButton(
              Buttons.Google,
              mini: true,
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Facebook,
              mini: true,
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Twitter,
              mini: true,
              onPressed: () {},
            ),
          ]),
        ])
      )
    );
  }
}  