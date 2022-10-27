import 'dart:async';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImageLoadResolver extends StatefulHookWidget {
  const ImageLoadResolver({
    required this.child,
    required this.images,
    required this.completer,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final List<Image?> images;
  final Completer completer;

  @override
  State<ImageLoadResolver> createState() => _ImageLoadResolverState();
}

class _ImageLoadResolverState extends State<ImageLoadResolver> {
  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        if (!kIsTest) {
          final notNullImages = widget.images.whereType<Image>().toList();
          if (notNullImages.isEmpty) {
            widget.completer.complete();
            return () {};
          }

          final internalCompleters = <Completer>[];
          for (var i = 0; i < notNullImages.length; i++) {
            final internalCompleter = Completer();
            internalCompleters.add(internalCompleter);

            final imageStream = notNullImages[i].image.resolve(ImageConfiguration.empty);
            imageStream.addListener(
              ImageStreamListener(
                (info, syncCall) => internalCompleter.complete(),
                onError: (info, syncCall) => internalCompleter.completeError(info),
              ),
            );
          }
          final mergedStream = Stream.fromFutures(internalCompleters.map((completer) => completer.future));

          final subscription = mergedStream.listen(
            (event) {},
            onDone: () {
              if (!widget.completer.isCompleted) {
                setState(() {});
                widget.completer.complete();
              }
            },
            onError: (e) => widget.completer.completeError(e.toString()),
          );
          return () => subscription.cancel();
        }
      },
      [widget.images],
    );

    return widget.child;
  }
}
