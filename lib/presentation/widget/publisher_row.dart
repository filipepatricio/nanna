import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/material.dart';

class PublisherRow extends StatelessWidget {
  const PublisherRow({
    required this.publisher,
    super.key,
  });

  final Publisher publisher;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PublisherLogo.dark(
          publisher: publisher,
          dimension: AppDimens.ml,
        ),
        Expanded(
          child: Text(
            publisher.name,
            maxLines: 1,
            style: AppTypography.b3Regular.copyWith(
              color: AppColors.textGrey,
              height: 1.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
