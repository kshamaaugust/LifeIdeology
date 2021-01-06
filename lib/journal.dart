import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:device_id/device_id.dart';

class journalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _journalState();
}
class _journalState extends State<journalPage> {
  var jsonData, curr_date, qusJson, total, ansJson, id;
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    this.thoughtsAPI();
    this.questions();
  }
  Future<String> thoughtsAPI() async {
  	var now = DateTime.now();
	String first_date = now.toString();
    curr_date = first_date.substring(0,10);
    var response = await http.get("http://139.59.66.2:9001/api/v1/thoughts/?date="+curr_date.toString()+"");
    jsonData = json.decode(response.body);
    setState(() {jsonData; });
  }
  Future<String> questions() async {
    var response = await http.get("http://139.59.66.2:9001/api/v1/journal-question/");
    qusJson = json.decode(response.body);
    total = qusJson.length;
    setState(() { qusJson; });
  }
  TextEditingController ans1Controller = TextEditingController();
  TextEditingController ans2Controller = TextEditingController();
  TextEditingController ans3Controller = TextEditingController();

  Future<String> answer(String ans1, String ans2, String ans3) async {
  	String deviceid = await DeviceId.getID;
    var readLoginData = await storage.read(key: 'loginData');
    if(readLoginData != null){
      var jsonlogin= json.decode(readLoginData);
      id = jsonlogin['id'].toString();
    }
    if(id == null ){
    	Map data = {
	    	'answer1': ans1Controller.text,
	    	'answer2': ans2Controller.text,
	    	'answer3': ans3Controller.text,
	    	'created': curr_date.toString(),
	    	'device_id': deviceid,
	    	'user': id,
	    	'question': '1'
	    };
	    await storage.write(key: 'journalData' , value: json.encode(data));
	    var response = await http.post("http://139.59.66.2:9001/api/v1/journal-answer/",body: json.encode(data), headers: <String, String>{"Content-Type": "application/json"});
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
    if(readLoginData != null){
      var jsonlogin= json.decode(readLoginData);
      id = jsonlogin['id'].toString();
    }
    if(id != null){
	    Map data = {
	    	'answer1': ans1Controller.text,
	    	'answer2': ans2Controller.text,
	    	'answer3': ans3Controller.text,
	    	'created': curr_date.toString(),
	    	'device_id': deviceid,
	    	'user': id,
	    	'question': '1'
	    };
	    await storage.write(key: 'journalData' , value: json.encode(data));
	    var response = await http.post("http://139.59.66.2:9001/api/v1/journal-answer/",body: json.encode(data), headers: <String, String>{"Content-Type": "application/json"});
  	}
  }	
  @override  
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
	    child: new Container(
	      width: MediaQuery.of(context).size.width,
	      decoration: BoxDecoration(
	        gradient: LinearGradient( begin: Alignment.topCenter, end: Alignment.bottomCenter,
	          colors: [const Color(0xffC55B07), const Color(0xffF5A26F)],
	        ),
	      ),
	      child: Center(
			child: Column(children: <Widget>[
			  Row(children: [
			    IconButton(
				  padding: EdgeInsets.fromLTRB(0,30,0,0),
				  icon: Icon(Icons.arrow_back,color:Colors.white),
				  onPressed: () => Navigator.push(  
					context,  
					MaterialPageRoute(builder: (context) => HomePage()),  
				  ),
				),
			    Container(
			      padding: EdgeInsets.fromLTRB(10,30,0,0),
			      child: Text('My Journal',style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
			    ),
			  ]),
			  Container(
			    padding: EdgeInsets.fromLTRB(0,20,100,0),
			    child: Text("Let's Starts",style: TextStyle(color: Colors.white, fontSize: 28),),
			  ),
			  Container(
			    padding: EdgeInsets.fromLTRB(0,0,100,0),
			    child: Text('What you think today',style: TextStyle(color: Colors.white, fontSize: 14)),
		      ),
			  Row(children: [
			    Container(
			      padding: EdgeInsets.fromLTRB(50,30,0,0),
			      child: Text('My Journal',style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
			    ),
			    Container(
			   	  padding: EdgeInsets.fromLTRB(110,30,0,0),
			      child: Text(curr_date.toString(), style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
			    ),
			  ]),
			  if(jsonData != null)
			  Container(
			    padding: EdgeInsets.fromLTRB(80,20,60,0),
	            child: Text(jsonData[0]['thought'].toString() ?? 'default' , overflow: TextOverflow.ellipsis, maxLines: 3 ,style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
			  ),
			  if(qusJson != null)
			  Container(
              	padding: EdgeInsets.fromLTRB(0,0,0,30),
              	height: 680, width: 480,
              	child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: total ?? 3,
                  itemBuilder: (BuildContext context, int i) =>
	                Container(
	                  width: 130.0,
	                  child: InkWell(
	                    // onTap: () => Navigator.push(  
	                    //   context,  
	                    //   MaterialPageRoute(builder: (context) => ViewBlogsPage(postsId: jsonData['results'][i]['id'])),  
	                    // ),
	                    child: Column(children: <Widget>[
	                      Container(
			                padding: EdgeInsets.fromLTRB(0,10,0,0),
			                child: Text(qusJson[i]['question'].toString() ?? 'default',style: TextStyle(color: Colors.white, fontSize: 16)),
			              ),
			              Container(
			              	padding: EdgeInsets.fromLTRB(40,0,40,0),
			              	child: TextField(
			                  autofocus: false,
			                  controller: ans1Controller,
			                  decoration: InputDecoration(
			                    hintText: '1.',
			                    contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
			                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
			                  ),
			                ),
			              ),
			              Container(
			              	padding: EdgeInsets.fromLTRB(40,0,40,0),
			              	child: TextField(
			                  autofocus: false,
			                  controller: ans2Controller,
			                  decoration: InputDecoration(
			                    hintText: '2.',
			                    contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
			                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
			                  ),
			                ),
			              ),
			              Container(
			              	padding: EdgeInsets.fromLTRB(40,0,40,0),
			              	child: TextField(
			                  autofocus: false,
			                  controller: ans3Controller,
			                  decoration: InputDecoration(
			                    hintText: '3.',
			                    contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
			                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
			                  ),
			                ),
			              ),       
	                  ]),
	                ),
                  ),
              	),
              ),
		      Container(padding: EdgeInsets.fromLTRB(0,20,0,0)),
		      Row(children: [
	            Container(
	              height: 70.0,
	              padding: EdgeInsets.fromLTRB(100,15,0,10),
	              child: RaisedButton(
	                onPressed:()  { answer(ans1Controller.text, ans2Controller.text, ans3Controller.text); } ,
	                color: Colors.white,
	                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
	                padding: EdgeInsets.fromLTRB(0,0,0,0),
	                child: Ink(
	                  child: Container(
	                    constraints: BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
	                    alignment: Alignment.center,
	                    child: Text("Submit", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
	                  ),
	                ),
	              ),
	            ),
	          ]),
		      Container(padding: EdgeInsets.fromLTRB(0,50,0,0)),
			]),
		  ),
		),
	  ),
	  floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(  
	      context,  
	      MaterialPageRoute(builder: (context) => journalsecPage()),  
	    ),
        child: Icon(Icons.menu,color: Colors.yellow),
        backgroundColor: Colors.white,
      ),    
    );
  }
}
class journalsecPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _journalsecState();
}
class _journalsecState extends State<journalsecPage>{
  @override  
  Widget build(BuildContext context) {  
    return new Scaffold(
      body: new SingleChildScrollView(
	    child: new Container(
	      width: MediaQuery.of(context).size.width,
	      decoration: BoxDecoration(
	        gradient: LinearGradient(
	          begin: Alignment.topCenter,
	          end: Alignment.bottomCenter,
	          colors: [
	            const Color(0xffC55B07),
	            const Color(0xffF5A26F),
	          ],
	        ),
	      ),
	      child: Container(
	      	child: Column(children: <Widget>[
	          Row(children: [
		        IconButton(
		          padding: EdgeInsets.fromLTRB(0,20,0,0),
		          icon: Icon(Icons.arrow_back, size: 40, color: Colors.white,),
		          onPressed: () {  
		            Navigator.push(  
		              context,  
		              MaterialPageRoute(builder: (context) => HomePage()),  
		            );  
		          },
		        ),
		        Container(
		          padding: EdgeInsets.fromLTRB(10,30,0,0),
		          child: Text('My Journal',style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
		        ),
		      ]),
		      Row(children: [
                IconButton(
              	  padding: EdgeInsets.fromLTRB(0,80,0,0),
                  icon: Icon(Icons.calendar_today, color: Colors.white,),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                    );
                  },
                ),
                Container(
              	  padding: EdgeInsets.fromLTRB(0,80,0,0),
                  child: Text('November 2020',style: TextStyle(color: Colors.white, fontSize: 18),),
                ),
                Container(
              	  padding: EdgeInsets.fromLTRB(90,80,0,0),
                  child: Text('Add Journals',style: TextStyle(color: Colors.white, fontSize: 13),),
                ),
              ]),
              Container(
                padding: EdgeInsets.fromLTRB(0,20,0,0),
              ),
              new Container(
              	decoration: BoxDecoration(color: Colors.white),
              	child: Column(children: <Widget>[
	              Row(children: [
	              	Padding(padding: EdgeInsets.fromLTRB(10,0,0,0),),
	              	RotatedBox(
      				  quarterTurns: -1,
	              	  child: Text('20 Nov. 11:00 AM',style: TextStyle(color: Colors.grey, fontSize: 15),),
	              	),
			        Container(
			          padding: EdgeInsets.fromLTRB(75,30,0,0),
			          height: 210,
			          width: 332,
			          child: Card(
			            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),),
			            // elevation: 10,
			            child: Container(
			              decoration: BoxDecoration(
			                borderRadius: new BorderRadius.only(
			                  topLeft:  const  Radius.circular(30.0),
			                  bottomLeft: const  Radius.circular(30.0),
			                ),
			                gradient: LinearGradient(
			                  // begin: Alignment.topCenter,
			                  // end: Alignment.bottomCenter,
			                  colors: [
			                    const Color(0xffE4E7FC),
	            				const Color(0xffE4E7FC),
			                  ],
			                ),
			              ),
			              child: InkWell(
			                onTap: () {  
			                  // Navigator.push(  
			                  //   context,  
			                  //   MaterialPageRoute(builder: (context) => BlogsPage()),  
			                  // );  
			                },
			                child: Column(children: <Widget>[
			                  Row(children: [
			                    Container(
			                      padding: EdgeInsets.fromLTRB(30,20,0,0),
			                      child: Center(child: Text('Journal 1', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),),
			                    ),
			                  ]),  
			                  Column(children: [
			                    Container(
			                      padding: EdgeInsets.fromLTRB(30,5,30,0),
			                      child: Center(child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry.', overflow: TextOverflow.ellipsis, maxLines: 5, style: TextStyle(color: Colors.black, fontSize: 15),),),
			                    ),
			                    // IconButton(
			                    //   padding: EdgeInsets.fromLTRB(180,0,0,0),
			                    //   icon: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 45),
			                    // ),
			                  ]),              
			                ]),
			              ),
			            ),
			          ),
			        ),
			      ]),
			      Container(
			      	padding: EdgeInsets.fromLTRB(0,10,0,0),
			      ),
			      new Divider(color: Colors.black),
			      Row(children: [
			        Padding(padding: EdgeInsets.fromLTRB(10,0,0,0),),
	              	RotatedBox(
      				  quarterTurns: -1,
	              	  child: Text('20 Nov. 11:00 AM',style: TextStyle(color: Colors.grey, fontSize: 15),),
	              	),
			        Container(
			          padding: EdgeInsets.fromLTRB(75,10,0,0),
			          height: 210,
			          width: 332,
			          child: Card(
			            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),),
			            // elevation: 10,
			            child: Container(
			              decoration: BoxDecoration(
			                borderRadius: new BorderRadius.only(
			                  topLeft:  const  Radius.circular(30.0),
			                  bottomLeft: const  Radius.circular(30.0),
			                ),
			                gradient: LinearGradient(
			                  begin: Alignment.topCenter,
			                  end: Alignment.bottomCenter,
			                  colors: [
			                    const Color(0xffC55B07),
	            				const Color(0xffF5A26F),
			                  ],
			                ),
			              ),
			              child: InkWell(
			                onTap: () {  
			                  // Navigator.push(  
			                  //   context,  
			                  //   MaterialPageRoute(builder: (context) => BlogsPage()),  
			                  // );  
			                },
			                child: Column(children: <Widget>[
			                  Row(children: [
			                    Container(
			                      padding: EdgeInsets.fromLTRB(30,20,0,0),
			                      child: Center(child: Text('Journal 1', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),),
			                    ),
			                  ]),  
			                  Column(children: [
			                    Container(
			                      padding: EdgeInsets.fromLTRB(30,5,30,0),
			                      child: Center(child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry.', overflow: TextOverflow.ellipsis, maxLines: 5, style: TextStyle(color: Colors.white, fontSize: 15),),),
			                    ),
			                    IconButton(
			                      padding: EdgeInsets.fromLTRB(180,0,0,0),
			                      icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 45),
			                    ),
			                  ]),              
			                ]),
			              ),
			            ),
			          ),
			        ),
			      ]),
			      Container(
			      	padding: EdgeInsets.fromLTRB(0,10,0,0),
			      ),
			      new Divider(color: Colors.black),
			      Row(children: [
			        Padding(padding: EdgeInsets.fromLTRB(10,0,0,0),),
	              	RotatedBox(
      				  quarterTurns: -1,
	              	  child: Text('20 Nov. 11:00 AM',style: TextStyle(color: Colors.grey, fontSize: 15),),
	              	),
			        Container(
			          padding: EdgeInsets.fromLTRB(75,10,0,0),
			          height: 210,
			          width: 332,
			          child: Card(
			            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),),
			            // elevation: 10,
			            child: Container(
			              decoration: BoxDecoration(
			                borderRadius: new BorderRadius.only(
			                  topLeft:  const  Radius.circular(30.0),
			                  bottomLeft: const  Radius.circular(30.0),
			                ),
			                gradient: LinearGradient(
			                  // begin: Alignment.topCenter,
			                  // end: Alignment.bottomCenter,
			                  colors: [
			                    const Color(0xffE4E7FC),
	            				const Color(0xffE4E7FC),
			                  ],
			                ),
			              ),
			              child: InkWell(
			                onTap: () {  
			                  // Navigator.push(  
			                  //   context,  
			                  //   MaterialPageRoute(builder: (context) => BlogsPage()),  
			                  // );  
			                },
			                child: Column(children: <Widget>[
			                  Row(children: [
			                    Container(
			                      padding: EdgeInsets.fromLTRB(30,20,0,0),
			                      child: Center(child: Text('Journal 1', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),),
			                    ),
			                  ]),  
			                  Column(children: [
			                    Container(
			                      padding: EdgeInsets.fromLTRB(30,5,30,0),
			                      child: Center(child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry.', overflow: TextOverflow.ellipsis, maxLines: 5, style: TextStyle(color: Colors.black, fontSize: 15),),),
			                    ),
			                    // IconButton(
			                    //   padding: EdgeInsets.fromLTRB(180,0,0,0),
			                    //   icon: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 45),
			                    // ),
			                  ]),              
			                ]),
			              ),
			            ),
			          ),
			        ),
			      ]),
			    ]),
              ),
		    ]),
		  ),
		),
	  ),
	);
  }
}