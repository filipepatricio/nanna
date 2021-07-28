import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
        centerTitle: true,
        backgroundColor: const Color(0xFFBBF383),
      ),
      body: Column(),
    );
  }
}
