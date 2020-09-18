import 'package:flutterapitut/Controllers/FlutterSession.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  String serverUrl = "http://52.38.98.60/api";
  var token;
  var salesId;

  var status;

  loginData(String phone, String password) async {
    String myUrl = "$serverUrl/Login";
    final response = await http.post(myUrl,
        headers: {'Accept': 'application/json'},
        body: {"phone": "$phone", "password": "$password"});
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["access_token"]}');
      _save(data["access_token"]);
      _saveSales(data["Salesrep ID"]);
    }
  }

  registerData(String name, String email, String password) async {
    String myUrl = "$serverUrl/register1";
    final response = await http.post(myUrl,
        headers: {'Accept': 'application/json'},
        body: {"name": "$name", "email": "$email", "password": "$password"});
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      // _save(data["token"]);
      await FlutterSession().set('token', data["token"]);
    }
  }

  Future<List<Map<String, dynamic>>> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'salesRepId';
    final value = prefs.get(key) ?? 0;
    http.Response response =
    await http.get('$serverUrl/tripRoute/$value');
    if (response.statusCode != 200) return null;
    return List<Map<String, dynamic>>.from(
        json.decode(response.body)['clients on trip']);
  }

  void deleteData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/products/$id";
    http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void addData(String name, String price) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/products";
    http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
      "price": "$price"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void editData(int id, String name, String price) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "http://flutterapitutorial.codeforiraq.org/api/products/1";
    http.put(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
      "price": "$price"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }

  _saveSales(int salesId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'salesRepId';
    final value = salesId;
    prefs.setInt(key, value);
  }

  readSales() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'salesRepId';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }


}
