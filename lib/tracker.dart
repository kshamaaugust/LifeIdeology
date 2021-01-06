import 'package:flutter/material.dart';  
import 'dart:async';
import 'home.dart';
import 'login.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:device_id/device_id.dart';

class TrackerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}
class _State extends State<TrackerPage> {
  var token, id, jsonData, title, title1;
  String first = null, sdate;
  final storage = new FlutterSecureStorage();
  TextEditingController textController = TextEditingController();
  choice1(title){ setState((){title1 = title; });}

  Upload(String choice, String text, String date) async {
    String deviceid = await DeviceId.getID;
    var readLoginData = await storage.read(key: 'loginData');
    if(readLoginData != null){
      var jsonlogin= json.decode(readLoginData);
      token = jsonlogin['token'];
      id = jsonlogin['id'];
    }
    if (token == null ){
      Map data = { 
        'device_id': deviceid,
        'user': id,
        'mood': title1,
        'description': textController.text.toString(),
        'created': sdate,
      };
      await storage.write(key: 'reportData' , value: json.encode(data));
      var response = await http.post("http://139.59.66.2:9001/api/v1/mood-track/", body: json.encode(data), headers: <String, String>{"Content-Type": "application/json"});
      jsonData = json.decode(response.body);
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
      var jsonlogin= json.decode(readData);
      id       = jsonlogin['id'].toString();
    }
    if(id != null) {
      String deviceid = await DeviceId.getID;
      Map data = { 
        'device_id': deviceid,
        'user': id,
        'mood': title1,
        'description': textController.text.toString(),
        'created': sdate
      };
      await storage.write(key: 'reportData' , value: json.encode(data));
      var response = await http.post("http://139.59.66.2:9001/api/v1/mood-track/", body: json.encode(data), headers: <String, String>{"Content-Type": "application/json"});
      jsonData = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportPage()),
      );
    }
    setState((){jsonData;});
  }
  DateTime selectedDate = DateTime.now();
  selectDate() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if(picked != null && picked != selectedDate){
      setState((){
        selectedDate = picked;
        first = selectedDate.toString();
        sdate = first.substring(0,10);
      });
    }
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
              colors: [ const Color(0xffFF6464), const Color(0xffFD9470), const Color(0xffFFC487) ],
            ),
          ),
          child: Center(
            child: Column(children: <Widget>[
              Row(children: [
                IconButton(
                  padding: EdgeInsets.fromLTRB(0,30,0,0),
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () => Navigator.push(  
                    context,  
                    MaterialPageRoute(builder: (context) => HomePage()),  
                  ),
                ),
              ]), 
              Row(children: [
                Padding(padding: EdgeInsets.fromLTRB(20,77,0,0),),
                Container(
                  child: Text('Hello !',style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),),
                ),
                Container(padding: EdgeInsets.fromLTRB(130,0,0,0)),
                RaisedButton.icon( 
                  color: Colors.transparent,
                  onPressed: () => Navigator.push(  
                    context,  
                    MaterialPageRoute(builder: (context) => ReportPage()),  
                  ),
                  icon: Icon(Icons.assignment_rounded, color: Colors.white),
                  label: Text("Report",style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ]),
              Row(children: [
                Padding(padding: EdgeInsets.fromLTRB(0,100,0,0)),
                IconButton( icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () { selectDate(); },
                ),
                Container(
                  child: Text('November 2020',style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ]),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0,20,0,0),
                  height: 409, width: 360,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(topLeft:  const  Radius.circular(40.0),topRight: const  Radius.circular(40.0)),
                  ),
                  child: Center(
                    child: Column(children: [
                      Container(
                        child: Center(child: Text('How are you feeling today? ', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(fontSize: 25))),
                      ),
                      Row(children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0,30,0,0),
                          height: 160, width: 120,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration( borderRadius: new BorderRadius.only( topLeft:    const  Radius.circular(20.0), topRight:   const  Radius.circular(20.0), bottomLeft: const  Radius.circular(20.0), bottomRight:const  Radius.circular(20.0)),
                              ),
                              width: 150.0,
                              child: InkWell(
                                onTap: () {  choice1('Sick');  },
                                child: Column(children: <Widget>[
                                  RichText(
                                    text:TextSpan(children:<TextSpan>[
                                      TextSpan(text: '🤢', style: TextStyle(fontSize: 60))
                                    ]),
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(0,10,0,0)),
                                  Text('Sick', style: TextStyle(fontSize: 13)),
                                ]),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0,30,0,0),
                          height: 160, width: 120,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration( borderRadius: new BorderRadius.only( topLeft:    const  Radius.circular(20.0), topRight:   const  Radius.circular(20.0), bottomLeft: const  Radius.circular(20.0), bottomRight:const  Radius.circular(20.0)),
                              ),
                              width: 150.0,
                              child: InkWell(
                                onTap: () { choice1('Happy'); },
                                child: Column(children: <Widget>[
                                  RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(text: '🙂', style: TextStyle(fontSize: 60))
                                    ]),
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(0,10,0,0)),
                                  Text('Happy', style: TextStyle(color: Colors.black, fontSize: 13),),
                                ]),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0,30,0,0),
                          height: 160, width: 120,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration( borderRadius: new BorderRadius.only( topLeft:    const  Radius.circular(20.0), topRight:   const  Radius.circular(20.0), bottomLeft: const  Radius.circular(20.0), bottomRight:const  Radius.circular(20.0)),
                              ),
                              width: 150.0,
                              child: InkWell(
                                onTap: () { choice1('Angry'); },
                                child: Column(children: <Widget>[
                                  RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(text: '😡', style: TextStyle(fontSize: 60))
                                    ]),
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(0,10,0,0)),
                                  Text('Angry', style: TextStyle(color: Colors.black, fontSize: 13),),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Container(padding: EdgeInsets.fromLTRB(0,20,0,0)),
                      Column(children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                          child: TextField(
                            controller: textController,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Say something...',
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Container(
                          height: 70.0,
                          padding: EdgeInsets.fromLTRB(100,15,0,10),
                          child: RaisedButton(
                            onPressed: () =>  Upload(title, textController.text, selectedDate.toString()) ,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                            padding: EdgeInsets.fromLTRB(0,0,0,0),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Color(0xffFFC487), Color(0xffFD9470), Color(0xffFF6464) ],
                                  begin: Alignment.centerRight, end: Alignment.centerLeft,
                                ),
                                borderRadius: BorderRadius.circular(40.0)
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text("Submit", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ]),
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
class ReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ReportState();
}
class _ReportState extends State<ReportPage> {
  String first = null, second = null,first_date,sec_date, curr_date, last_date, sdate, edate, slug;
  var token, id, jsondata, proj = 0, total, jsonData, totalCards;
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    firstData();
    postData();
  }
  Future<String> firstData() async{
    var now = DateTime.now();
    var firstDayOfTheweek = now.add(new Duration(days: now.weekday));
    first_date = now.toString();
    curr_date = first_date.substring(0,10);
    var date = DateTime(now.year, now.month, now.day+6);
    sec_date = date.toString();
    last_date = sec_date.substring(0,10);
    var readData   = await storage.read(key: 'loginData');
    var jsonLogin  = json.decode(readData);
    token = jsonLogin['token'];
    id = jsonLogin['id'].toString();
    var response = await http.get("http://139.59.66.2:9001/api/v1/mood-track/?created__gte="+curr_date+"&created__lte="+last_date+"&report=weekly&id="+id+"/", headers: <String, String>{'authorization':"Token "+token});
    print(response.statusCode);
    jsondata = json.decode(response.body);
    print(jsondata);
    total = (jsondata['list_of_items']).length;
    setState(() {  token; total; jsondata; });
  }
  Future<String> getData() async{
    var readData   = await storage.read(key: 'loginData');
    var jsonLogin  = json.decode(readData);
    token = jsonLogin['token'];
    id = jsonLogin['id'].toString();
    var response = await http.get("http://139.59.66.2:9001/api/v1/mood-track/?created__gte="+sdate+"&created__lte="+edate+"&report=weekly&id="+id+"/", headers: <String, String>{'authorization':"Token "+token});
    print(response.statusCode);
    jsondata = json.decode(response.body);
    print(jsondata);
    total = (jsondata['list_of_items']).length;
    setState(() {  token; total; jsondata; });
  }
  forDate() async{
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
      context: context,
      initialFirstDate: new DateTime.now(),
      initialLastDate: (new DateTime.now()).add(new Duration(days: 6)),
      firstDate: new DateTime(2015),
      lastDate: new DateTime(2030)
    );
    if(picked != null && picked.length == 2) {
      first = picked[0].toString();
      second = picked[1].toString();
      sdate = first.substring(0,10);
      edate = second.substring(0,10);
    }
    if(sdate != null && edate != null){
      getData();
    };
  }
  postData() async{
    var readData   = await storage.read(key: 'loginData');
    var jsonLogin  = json.decode(readData);
    token = jsonLogin['token'];
    jsonData = null;
    var responseapi = await http.get("http://139.59.66.2:9001/api/v1/posts/", headers: <String, String>{'authorization':"Token "+token});
    print(responseapi.statusCode);
    jsonData = json.decode(responseapi.body);
    print(jsonData);
    totalCards = jsonData['count'];
    slug = jsonData['results'][0]['slug'].toString();
    setState(() {  token; total; jsonData; });
  }
  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(url: "http://139.59.66.2:9001/blog/"+slug+"/");
  }
  @override  
  Widget build(BuildContext context) {  
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [const Color(0xffFF6464), const Color(0xffFD9470),
                const Color(0xffFFC487) ],
            ),
          ),
          child: Center(
            child: Column(children: <Widget>[
              Row(children: [
                IconButton(
                  padding: EdgeInsets.fromLTRB(0,30,0,0),
                  icon: Icon(Icons.arrow_back,color: Colors.white,),
                  onPressed: () => Navigator.push(  
                    context,  
                    MaterialPageRoute(builder: (context) => HomePage()),  
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10,30,0,0),
                  child: Text('Weekley Report',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                ),
              ]),
              Row(children: [
                Padding(padding: EdgeInsets.fromLTRB(60,90,0,0),),
                Container(
                  child: Text('Hello!',style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ),
                Container(padding: EdgeInsets.fromLTRB(90,0,0,0)),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.white,
                  onPressed: () { forDate(); },
                  icon: Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                  label: Text("Calender",style: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ]),
              Row(children: [
                Padding(padding: EdgeInsets.fromLTRB(50,50,0,0),),
                IconButton(icon: Icon(Icons.calendar_today, size: 20,color: Colors.white),
                ),
                Container(
                  child: Text(sdate ?? curr_date  ,style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                IconButton(icon: Icon(Icons.calendar_today, size: 20, color: Colors.white)),
                Container(
                  child: Text(edate ?? last_date ,style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ]),
              if(jsondata != null)
              new Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,end: Alignment.bottomCenter,
                    colors: [const Color(0xffE4E7FC),const Color(0xffE4E7FC)],
                  ),
                ),
                child: Row(children: [
                  Center(
                    child: Column(children: <Widget>[
                      new Container(
                        height: 370, width: 360,
                        child: GridView.count(
                          crossAxisCount: 2,
                          padding: EdgeInsets.fromLTRB(0,0,0,10),
                          children: List.generate(total ?? 7, (i) {
                            return Center(
                              child: Card(
                                child: Container(
                                  width: 170.0,
                                  child: Column(children: <Widget>[
                                    if(jsondata['list_of_items'][i]['mood'].toString() == 'Sick')
                                    RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(text: '🤢', style: TextStyle(fontSize: 60))
                                      ]),
                                    ),
                                    if(jsondata['list_of_items'][i]['mood'].toString() == 'Happy')
                                    RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(text: '🙂', style: TextStyle(fontSize: 60))
                                      ]),
                                    ),
                                    if(jsondata['list_of_items'][i]['mood'].toString() == 'Angry')
                                    RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(text: '😡', style: TextStyle(fontSize: 60))
                                      ]),
                                    ),
                                    // Text(jsondata['list_of_items'][i]['mood'].toString() ?? 'default' , style: TextStyle(color: Colors.grey, fontSize: 15),),
                                    Padding(padding: EdgeInsets.fromLTRB(0,10,0,0),),
                                    Text(jsondata['list_of_items'][i]['description'].toString()?? 'default', style: TextStyle(color: Colors.grey, fontSize: 13),),
                                    Padding(padding: EdgeInsets.fromLTRB(0,10,0,0),),
                                    Text(jsondata['list_of_items'][i]['created'].toString()?? 'default', style: TextStyle(fontSize: 15),),
                                  ]),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.fromLTRB(0,20,0,0),
                        height: 180, width: 340,
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          elevation: 10,
                          child: Container(
                            width: 340.0,
                            child: Row(children: <Widget>[
                              Text('Your average mood is ' + jsondata['average_mood'].toString() ?? 'good', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.grey, fontSize: 17)),
                              new CircularPercentIndicator(
                                radius: 100.0, lineWidth: 10.0,
                                percent: 0.70,
                                center: new Text(jsondata['percentage'].toString() , style: TextStyle(color: Colors.green, fontSize: 18)),
                                progressColor: Colors.green,
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Container(padding:EdgeInsets.fromLTRB(0,20,0,0)),
                    ]),
                  ),
                ]),
              ),
              if(jsondata != null)
              new Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0,10,200,0),
                    child: Text('Suggestion',style: TextStyle(color: Colors.grey, fontSize: 18),),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0,20,0,30),
                    height: 200, width: 360,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: totalCards,
                      itemBuilder: (BuildContext context, int i) =>
                      Card(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                        elevation: 10,
                        child: Container(
                          width: 130.0,
                          child: InkWell(
                            onTap: () { openBrowserTab(); },
                            child: Column(children: <Widget>[
                              Padding(padding: EdgeInsets.fromLTRB(0,20,0,0),),
                              Text(jsonData['results'][i]['title'].toString() ?? 'default', overflow: TextOverflow.ellipsis, maxLines: 4, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Column(children: [
                                // padding: EdgeInsets.fromLTRB(5,0,0,0),
                                // Html(data:jsonData['results'][i]['content'].toString() ?? 'default'),
                              ]),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}