import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';
import 'screens/recent_articles_screen.dart';
import 'screens/personal_page.dart';
import 'screens/static_forum_screen.dart';
import 'screens/secret_screen.dart';

import 'providers/auth_provider.dart';
import 'providers/article_provider.dart';
import 'providers/user_provider.dart';
import 'screens/success_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //TODO change database token requirements
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Articles>(
          create: (context) => Articles(''),
          update: (context, auth, previous) => Articles(auth.userId),
        ),

        ChangeNotifierProxyProvider<Auth, User>(
            create: (ctx) => User('', '', []),
            update: (ctx, auth, previousUserModel) =>
                User(auth.userId, auth.sillyName!, []))
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) {
          return MaterialApp(
              title: 'oopBopShbam',
              //TODO design theme
              home: auth.isAuth ? RecentArticlesScreen() : AuthScreen(),
              routes: {
                PersonalPage.routeName: (ctx) => PersonalPage(),
                StaticForumScreen.routeName: (ctx) => StaticForumScreen(),
                RecentArticlesScreen.routeName: (ctx) => RecentArticlesScreen(),
                addNameWords.routeName: (ctx) => addNameWords(),
              });
        },
      ),
    );
  }
}
