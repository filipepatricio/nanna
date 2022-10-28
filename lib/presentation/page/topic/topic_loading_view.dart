part of 'topic_page.dart';

class TopicLoadingView extends StatelessWidget {
  const TopicLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoadingShimmer.defaultColor(
            height: AppDimens.topicViewHeaderImageHeight(context),
          ),
        ],
      ),
    );
  }
}
