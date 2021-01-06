import 'package:flutter/material.dart';  
import 'dart:async';
import 'home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class categoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new categoryState();
}
class categoryState extends State<categoryPage> {
  var jsonData, total, categoryId;
  @override
  void initState() {
    super.initState();
    this.category();
  }
  Future<String> category() async {
    var response = await http.get("http://139.59.66.2:9001/api/v1/category/");
    jsonData = json.decode(response.body);
    total = jsonData['count'];
    setState(() { jsonData; });
  }
  @override  
  Widget build(BuildContext context) {  
    return new Scaffold(
      body:new SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            Row(children: [
              IconButton(
                padding: EdgeInsets.fromLTRB(0,40,0,0),
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.push(  
                  context,  
                  MaterialPageRoute(builder: (context) => HomePage()),  
                ),
              ),
            ]),
            if(jsonData != null)
            if(total != null)
            Container(
              padding: EdgeInsets.fromLTRB(0,0,0,30),
              height: 600, width: 330,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: total,
                itemBuilder: (BuildContext context, int i) =>
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft:  const  Radius.circular(20.0), topRight: const  Radius.circular(20.0), bottomLeft: const  Radius.circular(20.0), bottomRight: const  Radius.circular(20.0)
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [const Color(0xffF5A26F),const Color(0xffC55B07)],
                      ),
                    ),
                    child: InkWell(
                      onTap: () {  
                        Navigator.push(  
                          context,  
                          MaterialPageRoute(builder: (context) => BlogsPage(categoryId: jsonData['results'][i]['id'])),  
                        );  
                      },
                      child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(30,20,0,30),
                          child: Center(child: Text(jsonData['results'][i]['title'] ?? 'default',overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
                        ),             
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
class BlogsPage extends StatefulWidget {
  var categoryId;
  BlogsPage({this.categoryId});
  @override
  State<StatefulWidget> createState() => new _State();
}
class _State extends State<BlogsPage> {
  var jsonData, total, slug, categoryId;
  @override
  void initState() {
    super.initState();
    this.blogsData();
  }
  Future<String> blogsData() async {
    categoryId = widget.categoryId;
    var response = await http.get("http://139.59.66.2:9001/api/v1/posts/?category="+categoryId.toString()+"");
    jsonData = json.decode(response.body);
    total = jsonData['count'];
    slug = (jsonData['results'][0]['slug'].toString());
    setState(() { jsonData; });
  }
  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(url: "http://139.59.66.2:9001/blog/"+slug+"/");
  }
  @override  
  Widget build(BuildContext context) {  
    return new Scaffold(
      body:new SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            Row(children: [
              IconButton(
                padding: EdgeInsets.fromLTRB(0,40,0,0),
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.push(  
                  context,  
                  MaterialPageRoute(builder: (context) => categoryPage()),  
                ),
              ),
            ]),
            if(jsonData != null)
            if(total != null)
            Container(
              padding: EdgeInsets.fromLTRB(0,0,0,30),
              height: 600, width: 480,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: total,
                itemBuilder: (BuildContext context, int i) =>
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  elevation: 10,
                  child: Container(
                    width: 130.0,
                    child: InkWell(
                      onTap: () { openBrowserTab(); },
                      child: Column(children: <Widget>[
                        Row(children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(20,10, 0, 0),
                            width: 70, height: 70,
                            child: new CircleAvatar(
                              radius: 30.0,
                              backgroundImage: new NetworkImage("http://itzmejyoti.com/images/about/IMG-4232.JPG"),
                              backgroundColor: Colors.transparent,
                            )
                          ),
                          Column(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0,5,40,0),
                              child: Text(jsonData['results'][i]['author']['username'].toString() ?? 'default', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            ),
                            Row(children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(10,0,0,0),
                                child: Text(jsonData['results'][i]['timestamp'].substring(0,10).toString() ?? 'default', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5,0,0,0),
                                child: Text(jsonData['results'][i]['timestamp'].substring(11,19).toString() ?? 'default', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ),
                            ]),
                          ]), 
                        ]),
                        Container(
                          child: Center(child: Image.network(jsonData['results'][i]['featured'] ?? 'default')),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20,20,0,0),
                          child: Center(child: Text(jsonData['results'][i]['title'].toString() ?? 'default', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20,20,10,0),
                          child: Center(child: Text(jsonData['results'][i]['meta_description'].toString() ?? 'default', overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.grey, fontSize: 12))),
                        ),
                        Row(children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(20,60,0,0)),
                          Icon(Icons.favorite, color: Colors.red),
                          Text(jsonData['results'][i]['like'].toString() ?? '0', style: TextStyle(color: Colors.grey, fontSize: 12),),
                          Padding(padding: EdgeInsets.fromLTRB(30,40,0,0)),
                          Icon(Icons.comment, color: Colors.grey),
                          Text(jsonData['results'][i]['comments'].length.toString() ?? '0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Padding(padding: EdgeInsets.fromLTRB(160,40,0,0)),
                          Icon(Icons.visibility, color: Colors.grey),
                          Text(jsonData['results'][i]['view'].toString() ?? '0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ]),               
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}