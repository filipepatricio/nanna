import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/markdown_bullet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';

const _listElementTag = 'li';

class ArticleContentHtml extends HookWidget {
  final String html;
  final MediaItemCubit cubit;
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
        _makeHtmlContentResponsive(html),
      ),
      [html],
    );

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => scrollToPosition(),
        );
      },
      [],
    );

    return Html.fromDom(
      document: document,
      shrinkWrap: true,
      onLinkTap: _onLinkTap,
      customRender: {
        _listElementTag: (RenderContext context, Widget widget) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: const EdgeInsets.only(top: AppDimens.l), child: const MarkdownBullet()),
              const SizedBox(width: AppDimens.m),
              Expanded(child: widget),
            ],
          );
        },
      },
    );
  }

  Future<void> _onLinkTap(String? url, context, attrs, element) async {
    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }
}

String _makeHtmlContentResponsive(String htmlContent) {
  return '''<!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
              body {
                color: #282B35;
                font-family: Lora;
                font-size: 18px;
                line-height: 29px;
                font-weight: 400;
                margin: 0;
              }
              ol {
                padding-left: 24px;
                padding-right: 24px;
              }
              ul {
                padding-left: 24px;
                padding-right: 24px;
              }
              li {
                padding-top: 6px;
                padding-bottom: 6px;
              }
              p {
                margin: 0;
                padding-left: 24px;
                padding-right: 24px;
                padding-bottom: 18px;
              }
              h1, h2, h3, h4, h5, h6 {
                line-height: 24px;
                font-family: "Plus Jakarta Sans";
                padding-left: 24px;
                padding-right: 24px;
              }
              strong{
                line-height: 26px;
                font-family: "Plus Jakarta Sans";
              }
              img {
                object-fit: cover;
                width: 100%;
                height: auto;
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
                content: "●";
                font-size: 1rem;
                line-height: 1rem;
                color: #000000;
                margin-right: 0.4rem;
              }
          </style>
          <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Lora" />
        </head>
        $htmlContent
      </html>''';
}
