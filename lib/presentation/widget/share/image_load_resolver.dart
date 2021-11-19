import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImageLoadResolver extends HookWidget {
  final Widget child;
  final List<Image?> images;
  final Completer completer;

  const ImageLoadResolver({
    required this.child,
    required this.images,
    required this.completer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        final notNullImages = images.whereType<Image>().toList();
        if (notNullImages.isEmpty) {
          completer.complete();
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
          onDone: () => completer.complete(),
          onError: (e) => completer.completeError(''),
        );
        return () => subscription.cancel();
      },
      [images],
    );

    return child;
  }
}
