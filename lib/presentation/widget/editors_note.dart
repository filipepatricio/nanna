import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditorsNote extends StatelessWidget {
  final String note;

  const EditorsNote({required this.note, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.readingList_editorsNote.tr(),
            style: AppTypography.h5BoldSmall.copyWith(fontFamily: fontFamilyLora, height: 1.12),
          ),
          TextSpan(
            text: note,
            style: AppTypography.h5MediumSmall.copyWith(height: 1.12, fontFamily: fontFamilyLora),
          ),
        ],
      ),
    );
  }
}
