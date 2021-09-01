import 'package:better_informed_mobile/presentation/page/article/article_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ArticleContentHtml extends StatefulWidget {
  final String html;
  final ArticleCubit cubit;
  final Function() scrollToPosition;

  const ArticleContentHtml({
    required this.html,
    required this.cubit,
    required this.scrollToPosition,
    Key? key,
  }) : super(key: key);

  @override
  ArticleContentHtmlState createState() =>
      ArticleContentHtmlState(url: html, cubit: cubit, scrollToArticlePosition: scrollToPosition);
}

class ArticleContentHtmlState extends State<ArticleContentHtml> {
  final String url;
  final ArticleCubit cubit;
  final Function() scrollToArticlePosition;
  double _height = 1.0;

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true, mediaPlaybackRequiresUserGesture: false),
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
  );

  ArticleContentHtmlState({required this.cubit, required this.url, required this.scrollToArticlePosition});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _height,
      child: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse('https://pugjs.org/language/plain-text.html')),
        initialOptions: options,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          // Event fired when the WebView finishes loading an url
          await resizeWebViewHeight(controller);
          Future.delayed(const Duration(milliseconds: 500), () async {
            await scrollToArticlePosition();
          });
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
        },
      ),
    );
  }

  Future<void> resizeWebViewHeight(InAppWebViewController controller) async {
    await controller.evaluateJavascript(source: 'document.documentElement.scrollHeight').then((height) {
      setState(() {
        _height = double.parse(height.toString());
      });
    });
  }
}
