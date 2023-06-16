import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../widgets/article_tile_2.dart';
import './personal_page.dart';
import './static_forum_screen.dart';

class RecentArticlesScreen extends StatefulWidget {
  static const routeName = '/recent-articles';
  const RecentArticlesScreen({super.key});

  @override
  State<RecentArticlesScreen> createState() => _RecentArticlesScreenState();
}

class _RecentArticlesScreenState extends State<RecentArticlesScreen> {
  //TODO shouldn't I only load articles list once?
  //TODO i should load my articles only once! this is a nice standin - because ill make it the auto first page after login with the main page being the static-forum, which will not set the articles.
  //hang on initstate only happens once(or so) its the build method i ought to be worried about.

  @override
  void initState() {
    super.initState();
    Provider.of<Articles>(context, listen: false).fetchAndSetArticles();
  }

  @override
  Widget build(BuildContext context) {
    final pageArticles = Provider.of<Articles>(context).recentArticles;
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Articles"),
        leading: GestureDetector(
          onTap: () =>
              Navigator.of(context).popAndPushNamed(PersonalPage.routeName),
          child: Row(
            //TODO back button is confusing figure something else!
            children: [Icon(Icons.arrow_back), Icon(Icons.tag_faces_sharp)],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .popAndPushNamed(StaticForumScreen.routeName),
              icon: Icon(Icons.newspaper))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ...pageArticles.map((article) {
            return ChangeNotifierProvider.value(
              value: article,
              child: ArticleTile(key: ValueKey(article.id)),
            );

            // ArticleTile(
            //   locale: article.locale,
            //   title: article.title,
            //   exciteLine: article.exciteLine,
            //   approve: () {},
            // );
          }),
        ],
      )),
    );
  }
}
