import 'package:flutter/material.dart';

class People {
  String name;
  String gender;
  String email;

  People(this.name, this.gender, this.email);
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
  @override
  void initState() {
    super.initState();
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
        return _buildTile(_peoples[index]);
      },
      itemCount: _peoples.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('List'),
      ),
      body: new Container(child: _useListBuilder()),
    );
  }
}
