import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/tokens.dart';

/// The living Cloud — spec 04 §1 / 06. Drives shaders/cloud.frag.
///
/// Pulse: beat period = 60/BPM when live HR present, else 2.4 s.
/// Envelope rises for 35% of the period (easeAir), decays for 65%.
class CalorieCloud extends StatefulWidget {
  const CalorieCloud({
    super.key,
    required this.fill,
    required this.pulsing,
    this.bpm,
    this.burst = 0.0,
  });

  final double fill; // 0..1.25 daily progress vs goal
  final bool pulsing; // burn rate above threshold
  final double? bpm; // live HR, locks beat to heartbeat
  final double burst; // 0..1 milestone burst envelope (parent-driven)

  @override
  State<CalorieCloud> createState() => _CalorieCloudState();
}

class _CalorieCloudState extends State<CalorieCloud>
    with SingleTickerProviderStateMixin {
  static Future<ui.FragmentProgram>? _programCache;
  ui.FragmentShader? _shader;
  late final Ticker _ticker;
  double _t = 0;

  @override
  void initState() {
    super.initState();
    _programCache ??= ui.FragmentProgram.fromAsset('shaders/cloud.frag');
    _programCache!.then((p) {
      if (mounted) setState(() => _shader = p.fragmentShader());
    });
    _ticker = createTicker((elapsed) {
      setState(() => _t = elapsed.inMicroseconds / 1e6);
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shader?.dispose();
    super.dispose();
  }

  double _pulseEnvelope() {
    if (!widget.pulsing) return 0;
    final bpm = widget.bpm;
    final period = (bpm != null && bpm > 30) ? 60 / bpm : 2.4;
    final phase = (_t % period) / period;
    if (phase < 0.35) {
      return EterMotion.easeAir.transform(phase / 0.35);
    }
    final x = (phase - 0.35) / 0.65;
    return 1 - EterMotion.easeAir.transform(x) * 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final night = Theme.of(context).brightness == Brightness.dark;
    final shader = _shader;
    if (shader == null) {
      // Shader still loading (or unsupported): layered-PNG fallback, spec 04.
      return Center(
        child: AnimatedOpacity(
          duration: EterMotion.durEmphasis,
          opacity: 0.55 + 0.4 * widget.fill.clamp(0.0, 1.0),
          child: Image.asset('assets/art/cloud-hero-cutout.png',
              width: 280, fit: BoxFit.contain),
        ),
      );
    }
    return CustomPaint(
      painter: _CloudPainter(
        shader: shader,
        time: _t,
        fill: widget.fill,
        pulse: _pulseEnvelope(),
        night: night ? 1.0 : 0.0,
        burst: widget.burst,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _CloudPainter extends CustomPainter {
  _CloudPainter({
    required this.shader,
    required this.time,
    required this.fill,
    required this.pulse,
    required this.night,
    required this.burst,
  });

  final ui.FragmentShader shader;
  final double time, fill, pulse, night, burst;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width) // uSize.x
      ..setFloat(1, size.height) // uSize.y
      ..setFloat(2, time) // uTime
      ..setFloat(3, fill.clamp(0.0, 1.25)) // uFill
      ..setFloat(4, pulse) // uPulse
      ..setFloat(5, night) // uNight
      ..setFloat(6, burst); // uBurst
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_CloudPainter old) =>
      old.time != time ||
      old.fill != fill ||
      old.pulse != pulse ||
      old.burst != burst ||
      old.night != night;
}
