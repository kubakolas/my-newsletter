import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mynewsletter/Model/Shop.dart';
import 'package:mynewsletter/Model/Subscription.dart';
import 'package:mynewsletter/Model/UserMessage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Rest {

  String address = "https://mynewsletter-server.appspot.com/";
  String _token;
  Map<String, String> headers;

  Future<void> makeHeaders() async {
    _token = await FlutterSecureStorage().read(key: 'token');
    headers = {
      HttpHeaders.authorizationHeader: _token,
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
    };
  }

  Future<void> registerUser(String token) async {
    final url = address + 'User';
    var header = { HttpHeaders.authorizationHeader: token };
    await http.post(url, headers: header);
  }

  Future<List<UserMessage>> getMessages() async {
    await makeHeaders();
    print(_token);
    final url = address + 'UserMessage';
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        var messages = jsonResponse.map((message) => new UserMessage.fromJson(message)).toList();
//        messages.sort((a, b) => b.message.date.compareTo(a.message.date));
        return messages;
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      throw Exception('Failed to load messages');
    }
  }

  Future<List<Shop>> getShops() async {
    await makeHeaders();
    final url = address + 'Shop';
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var shops = jsonResponse.map((shop) => new Shop.fromJson(shop)).toList();
//      shops.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return shops;
    } else {
      throw Exception('Failed to load shops');
    }
  }

  Future<List<Subscription>> getSubscriptions() async {
    await makeHeaders();
    final url = address + 'Subscription';
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sub) => new Subscription.fromJson(sub)).toList();
    } else {
      throw Exception('Failed to get subscription');
    }
  }

  Future<Subscription> postSubscription(Subscription sub) async {
    await makeHeaders();
    var body = jsonEncode(sub.toJson());
    final url = address + 'Subscription';
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      return Subscription.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to post subscription');
    }
  }

  Future<Subscription> deleteSubscription(int id) async {
    await makeHeaders();
    final url = address + 'Subscription/' + id.toString();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      return Subscription.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to delete subscription');
    }
  }

  Future<void> putUserMessage(UserMessage userMessage) async {
    await makeHeaders();
    var body = jsonEncode(userMessage.toJson());
    final url = address + 'UserMessage/' + userMessage.id.toString();
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {} else {
      throw Exception('Failed to put userMessage');
    }
  }

  Future<void> deleteUserMessage(int id) async {
    await makeHeaders();
    final url = address + 'UserMessage/' + id.toString();
    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {} else {
      throw Exception('Failed to put userMessage');
    }
  }
}