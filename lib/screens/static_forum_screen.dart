import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../widgets/article_tile.dart';
import '../constants.dart';

class StaticForumScreen extends StatefulWidget {
  //TODO consider renaming routes for user friendliness.
  static const routeName = '/static-forum';
  const StaticForumScreen({super.key});

  @override
  State<StaticForumScreen> createState() => _StaticForumScreenState();
}

class _StaticForumScreenState extends State<StaticForumScreen> {
  //TODO make these late and listen inside didChangeDependencies?
  List<Article> _localArticles = [];
  List<Article> _stateArticles = [];
  List<Article> _nationalArticles = [];
  List<Article> _globalArticles = [];
  late List<Article> _displayedList;
  @override
  void initState() {
    super.initState();
    List bigList = Provider.of<Articles>(context, listen: false).setMainForum();
    _localArticles = bigList[0];
    _stateArticles = bigList[1];
    _nationalArticles = bigList[2];
    _globalArticles = bigList[3];
    _displayedList = _localArticles;
  }

  void switchScope(int pageIndex) {
    switch (pageIndex) {
      case 0:
        {
          setState(() {
            _displayedList = _localArticles;
          });
          break;
        }
      case 1:
        {
          setState(() {
            _displayedList = _stateArticles;
          });
          break;
        }
      case 2:
        {
          setState(() {
            _displayedList = _nationalArticles;
          });
          break;
        }
      case 3:
        {
          setState(() {
            _displayedList = _globalArticles;
          });
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._displayedList.map(
              //TODO different widget without locale indicating icon for static-forum articles.
              (article) => ArticleTile(
                  title: article.title,
                  exciteLine: article.exciteLine,
                  locale: article.locale,
                  approve: () {}),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: kLocalIcon, label: 'local'),
          BottomNavigationBarItem(icon: kStateIcon, label: 'state'),
          BottomNavigationBarItem(icon: kNationalIcon, label: 'national'),
          BottomNavigationBarItem(icon: kGlobalIcon, label: 'global'),
        ],
        onTap: (value) => switchScope(value),
      ),
    );
  }
}
