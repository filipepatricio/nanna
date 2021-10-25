import 'package:better_informed_mobile/presentation/page/article/article_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;

class ArticleContentHtml extends HookWidget {
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
  Widget build(BuildContext context) {
    final document = useMemoized(
      () => html_parser.parse(
        makeHtmlContentResponsive(html),
      ),
    );

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        scrollToPosition();
      });
    }, []);

    return Html.fromDom(
      document: document,
      shrinkWrap: true,
    );
  }
}

String makeHtmlContentResponsive(String htmlContent) {
  return '''<!DOCTYPE html>
      <html>
        <head>
          <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
          <style>
              body { 
                background-color: #FCFAF8; 
                color: #282B35; 
                font-family: Lora; 
              }
              p { 
                padding-left: 24px; 
                padding-right: 24px; 
              }
              h1, h2, h3, h4, h5, h6 { 
                padding-left: 24px; 
                padding-right: 24px; 
              }
              img { 
                object-fit: cover;
                width: 100%;
                height: auto;
              }
              
              /* Marker highlighting stroke */
              .highlight {
                position: relative;
                padding: 0 0.1rem;
                margin: 0 -0.1rem;
                z-index: 1;
              }
              
              .highlight::before {
                background-color: #BBF383;
                clip-path: polygon(2% 100%, 0% 63%, 98% 49%, 100% 85.47%);
                position: absolute;
                content: " ";
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: -1;
              }
              
              .raw h3 {
                line-height: 2rem;
                font-weight: 700;
                margin-bottom: 0.75rem;
              }
              
              .raw p {
                margin-bottom: 1.5rem;
              }
              
              .raw ul {
                list-style-type: none;
                margin-bottom: 1rem;
                padding-left: 0;
              }
              
              .raw ul>li {
                font-size: 1rem;
                line-height: 1.4rem;
                padding-bottom: 0.5rem;
              }
              
              .raw ul>li::before {
                content: "■";
                font-size: 1rem;
                line-height: 1rem;
                color: #bbf383;
                margin-right: 0.4rem;
              }
          </style>
          <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Lora" />
        </head>
        $htmlContent
      </html>''';
}
