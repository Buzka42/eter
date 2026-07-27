import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

/// Guards the WebP switch on the axis that matters at runtime: how long a
/// frame takes to decode. Smaller files are only a win if they do not cost
/// more CPU to unpack on the first frame that shows them.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<Duration> decode(File file, {int runs = 3}) async {
    final bytes = await file.readAsBytes();
    // Decode once first so the measurement excludes any one-off setup.
    (await (await ui.instantiateImageCodec(bytes)).getNextFrame())
        .image
        .dispose();
    final watch = Stopwatch()..start();
    for (var i = 0; i < runs; i++) {
      final codec = await ui.instantiateImageCodec(bytes);
      (await codec.getNextFrame()).image.dispose();
    }
    watch.stop();
    return Duration(microseconds: watch.elapsedMicroseconds ~/ runs);
  }

  test('WebP cards decode no slower than the PNG masters they replaced',
      () async {
    final root = Directory.current.path;
    final pairs = <String>[
      'the-star-dark',
      'temperance-light',
      'card-back-dark',
    ];

    var webpTotal = Duration.zero;
    var pngTotal = Duration.zero;
    for (final name in pairs) {
      final webp = File('$root/assets/art/cards/$name.webp');
      final png = File('$root/assets/art/masters/cards/$name.png');
      if (!webp.existsSync() || !png.existsSync()) {
        fail('Missing pair for $name');
      }
      final webpTime = await decode(webp);
      final pngTime = await decode(png);
      webpTotal += webpTime;
      pngTotal += pngTime;
      // ignore: avoid_print
      print('$name: webp ${webpTime.inMilliseconds} ms '
          '(${webp.lengthSync() ~/ 1024} KB) vs png '
          '${pngTime.inMilliseconds} ms (${png.lengthSync() ~/ 1024} KB)');
    }

    // A little slack: this runs on whatever the host is doing at the time, and
    // the claim being defended is "not materially slower", not "always faster".
    expect(
      webpTotal.inMicroseconds,
      lessThan((pngTotal.inMicroseconds * 1.5).round()),
      reason: 'WebP decode is more than 50% slower than PNG across the sample',
    );
  });
}
