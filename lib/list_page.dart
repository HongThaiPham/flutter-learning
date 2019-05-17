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
  List<People> _dataPeople;
  @override
  void initState() {
    super.initState();
    _getData().then((data) {
      setState(() {
        _dataPeople = data;
      });
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
    );
  }

  Widget _useListBuilder() {
    return new ListView.builder(
      padding: new EdgeInsets.all(5.0),
      itemBuilder: (context, index) {
        return _buildTile(_dataPeople[index]);
      },
      itemCount: _dataPeople.length,
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
    // print(respone.toString());
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
}
