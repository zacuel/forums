import 'package:flutter/material.dart';
import '../screens/article_screen.dart';
import '../constants.dart';

//TODO style tile
class ArticleTile extends StatelessWidget {
  final String title;
  final String exciteLine;
  final Locale locale;
  final Function approve;
  const ArticleTile(
      {super.key,
      required this.title,
      required this.exciteLine,
      required this.locale,
      required this.approve});

  @override
  Widget build(BuildContext context) {
    //TODO get better locale Icons

    Icon tileIcon = Icon(Icons.ramen_dining);
    if (locale == Locale.local) {
      tileIcon = kLocalIcon;
    } else if (locale == Locale.state) {
      tileIcon = kStateIcon;
    } else if (locale == Locale.national) {
      tileIcon = kNationalIcon;
    } else {
      tileIcon = kGlobalIcon;
    }

    return ListTile(
      leading: IconButton(
        color: Colors.amber,
        icon: tileIcon,
        onPressed: () => approve(),
      ),
      title: Text(title),
      subtitle: Text(exciteLine),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ArticleScreen(),
      )),
    );
  }
}
