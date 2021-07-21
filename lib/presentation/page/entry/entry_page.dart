import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Loader(),
    );
  }
}
