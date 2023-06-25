import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/article_provider.dart';
import './create_post_screen.dart';
import './static_forum_screen.dart';
import '../widgets/article_tile_2.dart';
import '../constants.dart';

class PersonalPage extends StatelessWidget {
  static const routeName = '/personal-page';
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    var listOfArticles =
        Provider.of<Articles>(context, listen: false).favoriteArticles;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.tag_faces_sharp),
        title: Text("your page"),
        actions: [Icon(Icons.videogame_asset_outlined)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...listOfArticles.map(
              (article) => Text(article.exciteLine),
            ),
            Text("articles user has upvoted goes here"),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return CreatePostScreen();
                    },
                  ));
                },
                child: Text("Create New Article")),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text("go to news"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context)
                  .popAndPushNamed(StaticForumScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
