import 'package:flutter/material.dart';  
import 'dart:async';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class contactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new contactState();
}
class contactState extends State<contactPage> {
  FocusNode _focusNode = FocusNode();
  final storage = new FlutterSecureStorage();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phnController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  contact(String name, String mail, String phn, String msg) async{
    Map data = {
      'name': nameController.text,
      'email': mailController.text,
      'phone': phnController.text,
      'message': msgController.text
    };
    var response = await http.post("http://139.59.66.2:9001/api/v1/contact-us/", body: data);
    if(response.statusCode == 201){
      AlertDialog alert = AlertDialog(
        title: new Text("Simple Alert"),
        content: new Text("Data Submitted successfully"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.push(  
              context,  
              MaterialPageRoute(builder: (context) => HomePage()),  
            ),
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
	          colors: [ const Color(0xffCC2C3F), const Color(0xffF18794)],
	        ),
	      ),
	      child: Center(
	      	child: Column(children: <Widget>[
	          Row(children: [
		        IconButton(
		          padding: EdgeInsets.fromLTRB(0,20,0,0),
		          icon: Icon(Icons.arrow_back,  color: Colors.white,),
		          onPressed: () => Navigator.push(  
		            context,  
		            MaterialPageRoute(builder: (context) => HomePage()),  
		          ),
		        ),
		      ]),
		      Container(
		        padding: EdgeInsets.fromLTRB(0,47,100,0),
		        child: Text('Contact Us',style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
		      ),
		      Container(
		      	padding: EdgeInsets.fromLTRB(40,40,40,0),
	            child: TextField(
	              controller: nameController,
	              decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
	                labelText: 'Name',
	                labelStyle: TextStyle( color: _focusNode.hasFocus ? Colors.blue : Colors.white)
	              ),
	            ),
	          ),
		      Container(
		      	padding: EdgeInsets.fromLTRB(40,20,40,0),
	            child: TextField(
	              controller: mailController,
	              decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
	                labelText: 'Email',
	                labelStyle: TextStyle( color: _focusNode.hasFocus ? Colors.blue : Colors.white)
	              ),
	            ),
	          ),
	          Container(
		      	padding: EdgeInsets.fromLTRB(40,20,40,0),
	            child: TextField(
	              controller: phnController,
	              decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
	                labelText: 'Phone',
	                labelStyle: TextStyle( color: _focusNode.hasFocus ? Colors.blue : Colors.white)
	              ),
	            ),
	          ),
	          Container(
		      	padding: EdgeInsets.fromLTRB(40,20,40,0),
	            child: TextField(
	              controller: msgController,
	              decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
	                labelText: 'Message',
	                labelStyle: TextStyle( color: _focusNode.hasFocus ? Colors.blue : Colors.white)
	              ),
	            ),
	          ),
	          Container(
                padding: EdgeInsets.fromLTRB(0,50,0,10),
                child: RaisedButton(
                  onPressed: () { contact(nameController.text, mailController.text, phnController.text, msgController.text); },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
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
		  ),
		),
	  ),
	);
  }
}