import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/release_note_content_view.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/release_note_media_container.dart';
import 'package:flutter/material.dart';

class ReleaseNotePopup extends StatelessWidget {
  const ReleaseNotePopup._(this.releaseNote);

  final ReleaseNote releaseNote;

  static Future<void> show({
    required BuildContext context,
    required ReleaseNote releaseNote,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => ReleaseNotePopup._(releaseNote),
      useRootNavigator: true,
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.isSmallDevice ? AppDimens.m : AppDimens.l,
          vertical: AppDimens.l,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              AppDimens.m,
            ),
          ),
          child: Material(
            color: AppColors.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (releaseNote.hasAnyMedia)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ReleaseNoteMediaContainer(releaseNote: releaseNote),
                  ),
                ReleaseNoteContentView(
                  releaseNote: releaseNote,
                  showCloseButton: !releaseNote.hasAnyMedia,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on ReleaseNote {
  bool get hasAnyMedia => media.isNotEmpty;
}
