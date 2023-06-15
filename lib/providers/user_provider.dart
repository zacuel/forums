import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/article_provider.dart';
import '../utilities/usernames.dart';

//TODO need list of users for add fuction?
class User with ChangeNotifier {
  final String _userId;
  String alias = '';

  List<Article> favoriteArticles = [];
//max length: 5
  User(this._userId);

  static Future<void> createAlias(String userId) async {
    final theAlias = await NameEngine.newUserName;
    final url = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/users/$userId.json');
    try {
      await http.put(url, body: json.encode({'userAlias': theAlias}));
    } catch (error) {
      rethrow;
    }
  }

  // static Future<void> createAlias(String userId) async {
  //   final url = Uri.parse(
  //       'https://ydtwo-8550b-default-rtdb.firebaseio.com/users/$userId.json');
  //   final alias = await NameEngine.NewUsername;

  //   //TODO use 'put' for name words
  //   await http.put(url, body: json.encode({'userAlias': alias}));
  // }
}
