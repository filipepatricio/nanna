import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        centerTitle: true,
        backgroundColor: AppColors.limeGreen,
      ),
      body: Column(),
    );
  }
}
