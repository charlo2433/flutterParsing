import 'package:flutter/material.dart';
import 'package:flutterapitut/Controllers/databasehelper.dart';
import 'package:flutterapitut/view/adddata.dart';
import 'package:flutterapitut/view/login.dart';
import 'package:flutterapitut/view/showdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);
  final String title;

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  var salesId;

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }

  readSales() async {
    final prefs = await SharedPreferences.getInstance();

    final key = 'salesRepId';
    final Id = prefs.get(key) ?? null;

    salesId = Id;

    print('salesId: $salesId');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //startTimer();
    readSales();
    read();
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                _save('0');
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage(),
                ));
              },
            )
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new AddData(),
          )),
        ),
        body: new FutureBuilder<List<Map<String, dynamic>>>(
          future: databaseHelper.fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Text(snapshot.error.toString()),
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final client = snapshot.data[index];
                return Card(
                  child: ListTile(
                  title: Text(
                      client['clientdetails']['companyName'].toString() ??
                          "No company Name"),
                  subtitle: Text( client['clientdetails']['contactPerson'].toString() ??
                      "No client Name"),
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) =>ClientDetails(client: client)));
                  },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
