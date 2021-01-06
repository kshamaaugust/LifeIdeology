import 'package:flutter/material.dart';  
import 'dart:async';
import 'dart:core';
import 'package:percent_indicator/percent_indicator.dart';
import 'home.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/parser.dart';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
import 'package:device_id/device_id.dart';

class AssessmentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}
class _State extends State<AssessmentPage> {
  var user_id, jsonData;
  final storage = new FlutterSecureStorage();
  getData() async{
    var readLoginData = await storage.read(key: 'loginData');
    if(readLoginData != null){
      var jsonlogin= json.decode(readLoginData);
      user_id    = jsonlogin['id'].toString();
    }
    DateTime selectedDate = DateTime.now();
    String first = selectedDate.toString();
    var date = first.substring(0,10);
    var api_url = "http://139.59.66.2:9001/api/v1/result/?timestamp__date="+date+"";
    if(user_id != null){
      api_url += "&user="+user_id+"";
    }
    else{
      String deviceId = await DeviceId.getID;
      api_url += "&device__registration_id="+deviceId+"";
    }
    var response = await http.get(api_url);
    jsonData = json.decode(response.body);
    if(jsonData.length == 0){
      Navigator.push(  
        context,  
        MaterialPageRoute(builder: (context) => Questions()),
      );
    }
    else if(jsonData.length > 0 && user_id != null) {
      Navigator.push(  
        context,  
        MaterialPageRoute(builder: (context) => resultPage()),
      );
    }
    else if(jsonData.length > 0 && user_id == null) {
      AlertDialog alert = AlertDialog(
        title: new Text("Alert!"),
        content: new Text("Alredy submitted questions. To check result, Please Login!"),
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
      body: new SingleChildScrollView(
        child: new Container(
          height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight, end: Alignment.bottomLeft,
              colors: [ const Color(0xffF18794), const Color(0xffCC2C3F)],
            ),
          ),
          child: new Center(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0,100,0,0),
                child: Text('Self Assessment',style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(100,80,80,0),
                child: Text('Lerum Ipsum is simply dummy text of the printing and typesetting industry. Lerum Ipsum has been the industrys standard dummy text ever since the 1500s, when an', overflow: TextOverflow.ellipsis, maxLines: 8 ,style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              Container(padding: EdgeInsets.fromLTRB(0,60,0,0)),
              Container(
                width: 360.0, height: 70.0,
                padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
                child: RaisedButton(
                  color: Colors.white, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                  child: Text('Start',style: TextStyle(color: Colors.black,fontSize: 20)),
                  onPressed: () { getData(); }, 
                ),  
              ),
              Container(
                width: 360.0, height: 70.0,
                padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
                child: FlatButton( 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                  child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 20)),
                  onPressed: () => Navigator.push(  
                    context,  
                    MaterialPageRoute(builder: (context) => HomePage()),  
                  ),
                ),  
              ),
            ])
          ),
        ),
      ),
    );
  }
}
class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}
class _QuestionsState extends State<Questions> {
  var token, id, user, jsonData, lnth, jsonlogin;
  final storage = new FlutterSecureStorage();
  List answerIs = [], questionIs = [], optionIs = [];
  @override
  void initState() {
    super.initState();
    question();
  }
  question() async{
    var response = await http.get("http://139.59.66.2:9001/api/v1/question/");
    jsonData = json.decode(response.body);
    lnth = jsonData.length;
    setState(() { jsonData; });
  }
  result() async{
    String deviceid = await DeviceId.getID;
    for(int i=0; i<answerIs.length; i++){
      questionIs.add(answerIs[i]['question']);
      optionIs.add(answerIs[i]['options']);
    }
    var readLoginData = await storage.read(key: 'loginData');
    if(readLoginData != null){
      jsonlogin= json.decode(readLoginData);
      token    = jsonlogin['token'];
    }
    if (token == null ){
      Map data = {
        'answer': json.encode(answerIs),
        'device_id': deviceid,
        'question': questionIs,
        'option': optionIs
      };
      await storage.write(key: 'resultData' , value: json.encode(data));
      var response = await http.post("http://139.59.66.2:9001/api/v1/result/", body: json.encode(data), headers: <String, String>{"Content-Type": "application/json"});
      if(response.statusCode == 201){
        AlertDialog alert = AlertDialog(
          title: new Text("Alert!"),
          content: new Text("You are not logged in.. Please Login!"),
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
    }
    var readData = await storage.read(key: 'loginData');
    if(readData != null){
      jsonlogin= json.decode(readData);
      id       = jsonlogin['id'].toString();
    }
    if(id != null) {
      Map data = {
        'answer': json.encode(answerIs),
        'user': id,
        'question': questionIs,
        'option': optionIs
      };
      await storage.write(key: 'resultData' , value: json.encode(data));
      var response = await http.post("http://139.59.66.2:9001/api/v1/result/", body: json.encode(data), headers: <String, String>{"Content-Type": "application/json"});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => resultPage()),
      );
    }
  }
  var _indexQuestion = 0, _indexOption = 0, option;
  int _value2 = -1;
  _next() {
    if(jsonData != null){
      setState( (){
        _value2 = -1;
        var lastIndex = jsonData.length - 1;
        if (_indexQuestion < lastIndex) {
          _indexQuestion++;
        }
        for(int j=0; j< jsonData.length; j++){
          option = jsonData[j]['options'];
          var optnIndex = option.length -1 ;
          if (_indexOption < optnIndex) {
            _indexOption++;
          }
          for(int q=0; q< option.length; q++){
            var opnval = option[q]['title'];
          }
        }
      });
    }
  }
  void _setvalue2(int value) => setState(() => _value2 = value);
  void onChanged(int value, qusId, optionId, optionScore) async{
    setState((){
      _value2 = value;
    });
    for(int i=0; i<answerIs.length; i++){
      var qus = answerIs[i]['question'];
      if(qus == qusId){
        answerIs.removeAt(i);
      }
    }
    answerIs.add({'question':qusId,'options':optionId, 'score':optionScore});
  }

  Widget makeRadioTiles(options, qusId) {
    List<Widget> list = new List<Widget>();
    for(int i = 0; i < options.length; i++){
      list.add(new RadioListTile(
        value: i,
        groupValue: _value2,
        onChanged: (int value){onChanged(value, qusId, options[i]['id'], options[i]['score']);},
        activeColor: Colors.blue,
        controlAffinity: ListTileControlAffinity.trailing,
        title: new Html(data:options[i]['title']),
      ));
    }
    Column column = new Column(children: list,);
    return column;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight, end: Alignment.bottomLeft,
              colors: [ const Color(0xff1F5FE7), const Color(0xff5F84F0), const Color(0xffD3CAF9), const Color(0xffEDDBCF) ],
            ),
          ),
          child: Center(
            child: Column(children: <Widget>[
              Row(children: [
                Padding(padding: EdgeInsets.fromLTRB(0,80,0,0),),
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: (){
                    AlertDialog alert = AlertDialog(  
                      title: new Text("Are you sure? ", style: TextStyle(color: Colors.black),),    
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () => Navigator.push(  
                            context,  
                            MaterialPageRoute(builder: (context) => HomePage()),  
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          color: Colors.blue,
                          child: const Text('Yes'),
                        ),
                        new FlatButton(
                          onPressed: () { Navigator.of(this.context).pop(); },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          color: Colors.blue,
                          child: const Text('No'),
                        ),
                      ],
                    ); 
                    showDialog(  
                      context: this.context,  
                      builder: (BuildContext context) {  
                        return alert;  
                      },  
                    );
                  },  
                ),
              ]),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text('Hello !',style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),),
                ),
              ]),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20,5,0,0),
                  child: Text("Let's Starts" ,style: TextStyle(color: Colors.white,fontSize: 26),),
                ),
              ]),
              Column(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0,20,190,0),
                  child: Text('Questions 5/10',style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
                LinearPercentIndicator(
                  padding: EdgeInsets.fromLTRB(30,10,0,0),
                  width: 330.0,  lineHeight: 20.0, percent: 0.5, backgroundColor: Colors.grey, progressColor: Colors.white 
                ),
              ]),
              if(jsonData != null)
              Row( children: [
                Container(
                  padding: EdgeInsets.fromLTRB(40,20,10,0),
                  height: 325, width: 330,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30), topRight: Radius.circular(30), topLeft: Radius.circular(30)
                      ),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {},
                      child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20,10,0,0),
                          child: Center(child: Html(data: jsonData[_indexQuestion]['title'] ?? 'default')),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(20,0,0,0),),
                        makeRadioTiles(jsonData[_indexQuestion]['options'], jsonData[_indexQuestion]['id'] ?? 'default')      
                      ]),
                    ),
                  ),
                ),
              ]),
              Container(padding: EdgeInsets.fromLTRB(0,20,0,0)),
              if(lnth != null)
              if (_indexQuestion == lnth-1)
              Row(children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(90,0,20,0),),
                RaisedButton(
                  onPressed: () { result(); },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffA8AFF9), Color(0xff195CE6)],
                        begin: Alignment.centerRight, end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(40.0)
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 170.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text("Submit", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22),),
                    ),
                  ),
                ),
              ]),
              if(lnth != null)
              if (_indexQuestion != lnth-1)
              Row(children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(90,0,20,0),),
                RaisedButton(
                  onPressed:   _next ,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffA8AFF9), Color(0xff195CE6)],
                        begin: Alignment.centerRight, end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(40.0)
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 170.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text("Next", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22),),
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
class resultPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new resultState();
}
class resultState extends State<resultPage> {
  var jsonData, lnth, score, total;
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    result();
  }
  result() async{
    var response = await http.get("http://139.59.66.2:9001/api/v1/result/");
    jsonData = json.decode(response.body);
    for(int i=0; i<jsonData.length; i++){
      score = ((jsonData[i]['score'])*10);
    }
    total = (score.toString());
    setState(() {jsonData;});
  }
  @override  
  Widget build(BuildContext context) {  
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [ const Color(0xff1F5FE7),const Color(0xff5F84F0),const Color(0xffD3CAF9), const Color(0xffEDDBCF),
              ],
            ),
          ),
          child: Center(
            child: Column(children: <Widget>[
              Row(children: [
                Padding(padding: EdgeInsets.fromLTRB(0,80,0,0),),
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () => Navigator.push(  
                    context,  
                    MaterialPageRoute(builder: (context) => HomePage()),
                  ),
                ),
              ]),
              Container(
                padding: EdgeInsets.fromLTRB(20,0,80,0),
                child: Text("Let's see what's your report says",style: TextStyle(color: Colors.white, fontSize: 30)),
              ),
              Container(padding: EdgeInsets.fromLTRB(0,50,0,0)),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0,20,0,0),
                  height: 440, width: 360,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft:  const  Radius.circular(40.0), topRight: const  Radius.circular(40.0),
                    ),
                  ),
                  child: Column(children: [
                    if(total != null)
                    Container(
                      child: Center(child: Text('Score : ' +total+ '/10', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(fontSize: 25))),
                    ),
                    Container(padding: EdgeInsets.fromLTRB(0,20,0,0),),
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(text: '🤔', style: TextStyle(fontSize: 70))
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(80,20,60,0),
                      child: Center(child: Text("Your average mood is good this week.Your average mood is good this week.Your average mood is good this week.Your average mood is good this week.", overflow: TextOverflow.ellipsis, maxLines: 6, style: TextStyle(color: Colors.grey,fontSize: 15),),),
                    ),
                    Container(padding: EdgeInsets.fromLTRB(0,20,0,0),),
                    Row(children: [
                      Container(
                        height: 70.0,
                        padding: EdgeInsets.fromLTRB(90,20,60,0),
                        child: RaisedButton(
                          onPressed: (){},
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xff1F5FE7), Color(0xff5F84F0), Color(0xffD3CAF9),  ],
                                begin: Alignment.centerLeft,  end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(40.0)
                            ),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text("Discuss with expert", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Container(
                        width: 360.0, height: 50.0,
                        padding: EdgeInsets.fromLTRB(140,10,110,0),
                        child: RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0),side: BorderSide(color: Colors.black)),
                          child: Text('Not now',style: TextStyle(color: Colors.black,fontSize: 15),),
                          onPressed: (){
                            Navigator.push(  
                              context,  
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          }, 
                        ),  
                      ),
                    ]),
                  ]),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}