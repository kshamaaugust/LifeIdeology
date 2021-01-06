import 'package:flutter/material.dart';  
import 'dart:async';
import 'blogs.dart';
import 'assessment.dart';
import 'tracker.dart';
import 'journal.dart';
import 'contact.dart';
import 'login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_id/device_id.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}
class _State extends State<HomePage> {
  var user_id, jsonData;
  final storage = new FlutterSecureStorage();
  trackerData() async{
    var readLoginData = await storage.read(key: 'loginData');
    if(readLoginData != null){
      var jsonlogin= json.decode(readLoginData);
      user_id    = jsonlogin['id'].toString();
    }
    DateTime selectedDate = DateTime.now();
    String first = selectedDate.toString();
    var date = first.substring(0,10);
    var api_url = "http://139.59.66.2:9001/api/v1/mood-track/?created="+date+"&type=is_exist";
    if(user_id != null){
      api_url += "&user="+user_id+"";
    }
    else{
      String deviceId = await DeviceId.getID;
      api_url += "&device__registration_id="+deviceId+"";
    }
    var response = await http.get(api_url);
    jsonData = json.decode(response.body);
    if(jsonData['list_of_items'].length == 0){
      Navigator.push(  
        context,  
        MaterialPageRoute(builder: (context) => TrackerPage()),
      );
    }
    else if(jsonData['list_of_items'].length > 0 && user_id != null) {
      Navigator.push(  
        context,  
        MaterialPageRoute(builder: (context) => ReportPage()),
      );
    }
    else if(jsonData['list_of_items'].length > 0 && user_id == null) {
      AlertDialog alert = AlertDialog(
        title: new Text("Alert!"),
        content: new Text("Alredy submitted Data. To check result, Please Login!"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ),
            color: Colors.blue,
            child: const Text('Login'),
          ),
          new FlatButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ),
            color: Colors.blue,
            child: const Text('Cancel'),
          ),
        ],
      );
      showDialog(
        context: context,
        barrierDismissible: false,       // outertouch false in a popup
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    setState(() { jsonData; });
  }
  journalData() async{
    var readLoginData = await storage.read(key: 'loginData');
    if(readLoginData != null){
      var jsonlogin= json.decode(readLoginData);
      user_id    = jsonlogin['id'].toString();
    }
    DateTime selectedDate = DateTime.now();
    String first = selectedDate.toString();
    var date = first.substring(0,10);
    var api_url = "http://139.59.66.2:9001/api/v1/journal-answer/?created="+date+"";
    if(user_id != null){
      api_url += "&user="+user_id+"";
    }
    else{
      String deviceId = await DeviceId.getID;
      api_url += "&device__registration_id="+deviceId+"";
    }
    var response = await http.get(api_url);
    print(response.statusCode);
    jsonData = json.decode(response.body);
    print(jsonData);
    if(jsonData.length == 0){
      Navigator.push(  
        context,  
        MaterialPageRoute(builder: (context) => journalPage()),
      );
    }
    else if(jsonData.length > 0 && user_id != null) {
      Navigator.push(  
        context,  
        MaterialPageRoute(builder: (context) => journalsecPage()),
      );
    }
    else if(jsonData.length > 0 && user_id == null) {
      AlertDialog alert = AlertDialog(
        title: new Text("Alert!"),
        content: new Text("Alredy submitted Data. To check result, Please Login!"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ),
            color: Colors.blue,
            child: const Text('Login'),
          ),
          new FlatButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ),
            color: Colors.blue,
            child: const Text('Cancel'),
          ),
        ],
      );
      showDialog(
        context: context,
        barrierDismissible: false,       // outertouch false in a popup
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    setState(() { jsonData; });
  }
  @override  
  Widget build(BuildContext context) {  
    return new Scaffold(
      body:new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          child: new Center(
            child: new Column(children: <Widget>[
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30,60,0,0),
                  height: 220,width: 330,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration( 
                        borderRadius: new BorderRadius.only(topLeft:  const  Radius.circular(20.0),topRight: const  Radius.circular(20.0), bottomLeft: const  Radius.circular(20.0), bottomRight: const  Radius.circular(20.0)
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [const Color(0xffF5A26F),const Color(0xffC55B07)],
                        ),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.push(  
                          context,  
                          MaterialPageRoute(builder: (context) => categoryPage()),  
                        ),
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0,20,170,0),
                            child: Center(child: Text('Blogs', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(30,5,0,0),
                            child: Center(child: Text('Depression is the most common response but being make you helpless.', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 12))),
                          ),             
                        ]),
                      ),
                    ),
                  ),
                ),
              ]),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30,20,0,0),
                  height: 180, width: 330,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(topLeft:  const  Radius.circular(20.0),topRight: const  Radius.circular(20.0),bottomLeft: const  Radius.circular(20.0),bottomRight: const  Radius.circular(20.0)
                        ),
                        gradient: LinearGradient( begin: Alignment.topCenter,end: Alignment.bottomCenter,
                          colors: [const Color(0xffF18794), const Color(0xffCC2C3F)],
                        ),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.push(  
                          context,  
                          MaterialPageRoute(builder: (context) => AssessmentPage()),  
                        ),
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0,20,80,0),
                            child: Center(child: Text('Assessment', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(30,5,0,0),
                            child: Center(child: Text('Depression is the most common response but being make you helpless.', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 12),),),
                          ),             
                        ]),
                      ),
                    ),
                  ),
                ),
              ]),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30,20,0,0),
                  height: 180, width: 330,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(topLeft:  const  Radius.circular(20.0),topRight: const  Radius.circular(20.0),bottomLeft: const  Radius.circular(20.0),bottomRight: const  Radius.circular(20.0)
                        ),
                        gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,
                          colors: [const Color(0xffA93EED),const Color(0xff843BFB)],
                        ),
                      ),
                      child: InkWell(
                        onTap: () { trackerData(); },
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0,20,60,0),
                            child: Center(child: Text('Mood Tracker', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(30,5,0,0),
                            child: Center(child: Text('Depression is the most common response but being make you helpless.', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 12),),),
                          ),            
                        ]),
                      ),
                    ),
                  ),
                ),
              ]),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30,20,0,0),
                  height: 180, width: 330,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(topLeft:  const  Radius.circular(20.0),topRight: const  Radius.circular(20.0),bottomLeft: const  Radius.circular(20.0),bottomRight: const  Radius.circular(20.0)
                        ),
                        gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,
                          colors: [const Color(0xffF5A26F),const Color(0xffC55B07)],
                        ),
                      ),
                      child: InkWell(
                        onTap: () { journalData(); },
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0,20,90,0),
                            child: Center(child: Text('My Journal', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(30,5,0,0),
                            child: Center(child: Text('Depression is the most common response but being make you helpless.', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 12),),),
                          ),            
                        ]),
                      ),
                    ),
                  ),
                ),
              ]),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30,20,0,0),
                  height: 180, width: 330,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(topLeft:  const  Radius.circular(20.0),topRight: const  Radius.circular(20.0),bottomLeft: const  Radius.circular(20.0),bottomRight: const  Radius.circular(20.0)
                        ),
                        gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,
                          colors: [const Color(0xffF18794),const Color(0xffCC2C3F)],
                        ),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.push(  
                          context,  
                          MaterialPageRoute(builder: (context) => contactPage()),  
                        ),
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0,20,100,0),
                            child: Center(child: Text('Contact us', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(30,5,0,0),
                            child: Center(child: Text('Depression is the most common response but being make you helpless.', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 12),),),
                          ),            
                        ]),
                      ),
                    ),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}