import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/Bookmark Provider.dart';
import 'Controller/ShareScreen.dart';
import 'Controller/language_provider.dart';
import 'frontpage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
        ChangeNotifierProvider<ShareMusic>(create: (_) => ShareMusic()),
        ChangeNotifierProvider<BookmarkProvider>(create: (_) => BookmarkProvider(),)
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Frontpage(),
    );
  }
}
