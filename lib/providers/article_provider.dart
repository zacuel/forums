import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class Article with ChangeNotifier {
  //TODO add locale
  final String id;
  final String title;
  final String exciteLine;
  final bool isOriginal;
  final String? articleUrl;
  final String? content;
  final DateTime creationDate;
  final Locale locale;
  bool isFavorite;

  Article({
    required this.id,
    required this.title,
    this.exciteLine = "Check This Out!",
    required this.isOriginal,
    this.articleUrl,
    this.content,
    required this.locale,
    required this.creationDate,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String userId) async {
    //TODO THE NEXT LINE IS FOR FAILSAFENESS.
    // final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/users/$userId/markedArticles/$id.json');
    try {
      await http.put(url, body: json.encode(isFavorite));
    } catch (error) {
      rethrow;
    }
  }

  Icon get articleIcon {
    if (locale == Locale.local) {
      return kLocalIcon;
    } else if (locale == Locale.state) {
      return kStateIcon;
    } else if (locale == Locale.national) {
      return kNationalIcon;
    } else {
      return kGlobalIcon;
    }
  }
}

class Articles with ChangeNotifier {
  List<Article> _articles = [];

  List<Article> get articles {
    return [..._articles];
  }

  List<Article> get recentArticles {
    //TODO limit to 10 or so recent articles
    List<Article> orderedList = [..._articles];
    orderedList.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    return orderedList.reversed.toList();
  }

  List<Article> get _localArticles {
    return _articles
        .where((article) => article.locale == Locale.local)
        .toList();
  }

  List<Article> get _stateArticles {
    return _articles
        .where((article) => article.locale == Locale.state)
        .toList();
  }

  List<Article> get _nationalArticles {
    return _articles
        .where((article) => article.locale == Locale.national)
        .toList();
  }

  List<Article> get _globalArticles {
    return _articles
        .where((article) => article.locale == Locale.global)
        .toList();
  }

  List<List<Article>> setMainForum() {
    return [_localArticles, _stateArticles, _nationalArticles, _globalArticles];
  }

  Future<void> fetchAndSetArticles() async {
    final url = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/articles.json');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data == null) {
        return;
      }
      final extractedData = data as Map<String, dynamic>;
      final List<Article> loadedArticles = [];
      extractedData.forEach((articleId, articleData) {
        loadedArticles.add(Article(
          id: articleId,
          title: articleData['title'],
          creationDate: DateTime.parse(articleData['creationDate']),
          isOriginal: articleData['url'] == null,
          articleUrl: articleData['url'] ?? null,
          content: articleData['content'] ?? null,
          exciteLine: articleData['exciteLine'],
          locale: Locale.values[articleData['localeIndex']],
        ));
      });
      _articles = loadedArticles;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createArticle(Article article) async {
    final url = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/articles.json');
    try {
      var response;
      if (article.isOriginal) {
        response = await http.post(
          url,
          body: json.encode({
            'localeIndex': article.locale.index,
            'creationDate': article.creationDate.toIso8601String(),
            'title': article.title,
            'exciteLine': article.exciteLine,
            'content': article.content,
          }),
        );
      } else if (article.content != null) {
        response = await http.post(
          url,
          body: json.encode({
            'localeIndex': article.locale.index,
            'creationDate': article.creationDate.toIso8601String(),
            'title': article.title,
            'exciteLine': article.exciteLine,
            'content': article.content,
            'url': article.articleUrl,
          }),
        );
      } else {
        response = await http.post(url,
            body: json.encode({
              'localeIndex': article.locale.index,
              'creationDate': article.creationDate.toIso8601String(),
              'title': article.title,
              'exciteLine': article.exciteLine,
              'url': article.articleUrl
            }));
      }
      final newArticle = Article(
        title: article.title,
        exciteLine: article.exciteLine,
        content: article.content ?? null,
        isOriginal: article.articleUrl == null,
        articleUrl: article.articleUrl ?? null,
        creationDate: article.creationDate,
        locale: article.locale,
        id: json.decode(response.body)['name'],
      );
      _articles.add(newArticle);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
