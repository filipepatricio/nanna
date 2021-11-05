import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditorsNote extends StatelessWidget {
  final String note;

  const EditorsNote({required this.note, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      note,
      textScaleFactor: 1,
      style: AppTypography.h5MediumSmall.copyWith(height: 1.12, fontFamily: fontFamilyLora),
    );
  }
}
