import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/article_provider.dart';

class User with ChangeNotifier {
  final String _userId;
  final String alias;

  final List<String> favoriteArticlesIds;
//max length: 5

  User(this._userId, this.alias, this.favoriteArticlesIds);

  String get userId {
    return _userId;
  }

  Future<void> fetchAndSetFavoriteArticles() async {
    final url = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/users/$userId/markedArticles.json');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data == null) {
        return Future(() => []);
      }
      final extractedData = data as Map<String, bool>;
      final List<String> loadedFavoriteArticleIds = [];
      extractedData.forEach((articleId, value) {
        if (value) {
          loadedFavoriteArticleIds.add(articleId);
        }
      });
      return Future(() => loadedFavoriteArticleIds);
    } catch (error) {
      rethrow;
    }
  }
}
