import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/article_provider.dart';
import '../utilities/usernames.dart';

class User with ChangeNotifier {
  final String _userId;
  String alias = '';

  List<Article> favoriteArticles = [];
//max length: 5

  User(this._userId);
  String get userId {
    return _userId;
  }

  Future<void> retrieveAlias() async {
    final url = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/users/$_userId/userAlias.json');
    try {
      final data = await http.get(url);
      alias = json.decode(data.body);
    } catch (error) {
      rethrow;
    }
  }
}
