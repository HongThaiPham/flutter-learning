import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class People {
  String name;
  String gender;
  String email;

  People(this.name, this.gender, this.email);

  factory People.fromJson(Map<String, dynamic> json) =>
      new People(json["name"]["title"], json['gender'], json['email']);
}

List<People> _peoples = [
  new People('robin', 'male', 'robin.boyer@example.com'),
  new People('terry', 'female', 'terry.reid@example.com'),
];

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ScrollController _scrollController = new ScrollController();
  List<People> _dataPeople = new List<People>();
  bool isPerformingRequest = false;
  @override
  void initState() {
    super.initState();
    _getData().then((data) {
      setState(() {
        _dataPeople = data;
      });
    });
    _scrollController.addListener(() {

      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {

        if (!isPerformingRequest) {
          setState(() => isPerformingRequest = true);
          _getData().then((data) {
            data=[];
            if(data.isEmpty){
              double edge = 50.0;
              double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
              if (offsetFromBottom < edge) {
                _scrollController.animateTo(
                    _scrollController.offset - (edge -offsetFromBottom),
                    duration: new Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              }
            }
            setState(() {
              _dataPeople.addAll(data);
              isPerformingRequest = false;
            });
          });
        }
      }
    });
  }

  Widget _buildTile(data) {
    return new ListTile(
      leading: new Icon(Icons.account_circle),
      title: new Text(
        data.name,
        style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: new Text(data.email),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  List<Widget> _buildList() {
    var temp = new List<Widget>();
    temp.addAll(_peoples.map((f) {
      return _buildTile(f);
    }));
    return temp;
  }

  Widget _useListView() {
    return new ListView(
      padding: new EdgeInsets.all(8.0),
      children: _buildList(),
      controller: _scrollController,
    );
  }

  Widget _useListBuilder() {
    return new ListView.builder(
      padding: new EdgeInsets.all(5.0),
      itemBuilder: (context, index) {
        if (index == _dataPeople.length) {
          return _buildProgressIndicator();
        } else {
          return _buildTile(_dataPeople[index]);
        }
      },
      itemCount: _dataPeople.length+1,
      controller: _scrollController,
    );
  }

  Future<List<People>> _getData() async {
    List<People> peo = new List<People>();
    final response = await http.get("https://randomuser.me/api/?results=20");
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      List results = jsonResponse['results'];
      List temp = new List.from(results);
      peo.addAll(temp.map((f) {
        return new People.fromJson(f);
      }));
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return peo;

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('List'),
        ),
        body: new Container(
          child: _useListBuilder(),
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
