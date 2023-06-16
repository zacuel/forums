import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key});

  @override
  Widget build(BuildContext context) {
    // final article = Provider.of<Article>(context, listen: false);
    final userData = Provider.of<Auth>(context, listen: false);
    return ListTile(
      leading: Consumer<Article>(
        builder: (ctx, article, child) => IconButton(
          onPressed: () => article.toggleFavoriteStatus(userData.userId),
          icon: article.articleIcon,
          color: article.isFavorite ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}
