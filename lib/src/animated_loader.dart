// lib/src/animated_loader.dart
import 'dart:math';
import 'package:flutter/material.dart';

/// Defines the various built-in loader animation types.
enum LoaderType {
  /// A continuously rotating icon.
  rotatingIcon,

  /// A row of dots that bounce sequentially.
  bouncingDots,

  /// A circle that expands and fades.
  expandingCircle,

  /// A circular gradient ring that spins.
  ringGradient,

  /// A pulsing dot that grows and shrinks.
  pulse,

  /// A horizontal bar that fills and empties.
  bar,
}

/// A flexible, customizable loading indicator widget.
///
/// Supports determinate and indeterminate modes, multiple built-in
/// animation styles, and full control over size, colors, duration,
/// curves, and repetition.
///
/// Example:
/// ```dart
/// AnimatedLoader(
///   size: 80,
///   colors: [Colors.purple, Colors.orange],
///   duration: Duration(seconds: 2),
///   curve: Curves.easeInOut,
///   loaderType: LoaderType.bouncingDots,
///   autoReverse: true,
/// );
/// ```
class AnimatedLoader extends StatefulWidget {
  /// Width and height of the loader.
  final double size;

  /// Color palette for the animation. Usage depends on [loaderType].
  final List<Color> colors;

  /// Duration of one full animation cycle.
  final Duration duration;

  /// Curve applied to the animation.
  final Curve curve;

  /// Which built-in animation to display.
  final LoaderType loaderType;

  /// If true, the animation will reverse back and forth.
  final bool autoReverse;

  /// Number of cycles to run (null = infinite).
  final int? repeatCount;

  /// If non-null, draws a determinate circular progress (0.0 to 1.0).
  final double? progress;

  /// Accessibility label for the loader.
  final String? semanticsLabel;

  const AnimatedLoader({
    super.key,
    this.size = 48,
    this.colors = const [Colors.blue, Colors.red, Colors.green],
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.linear,
    this.loaderType = LoaderType.rotatingIcon,
    this.autoReverse = false,
    this.repeatCount,
    this.progress,
    this.semanticsLabel,
  });

  @override
  _AnimatedLoaderState createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.repeatCount != null) {
      int cycles = widget.repeatCount!;
      int completed = 0;
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          completed++;
          if (completed >= cycles) _controller.stop();
        }
      });
    }

    _controller.repeat(reverse: widget.autoReverse);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loader;

    // Determinate mode (circular progress)
    if (widget.progress != null) {
      loader = CustomPaint(
        painter: _ProgressPainter(
          progress: widget.progress!.clamp(0.0, 1.0),
          color: widget.colors.first,
          strokeWidth: widget.size * 0.1,
        ),
      );
    } else {
      // Choose an indeterminate animation style
      switch (widget.loaderType) {
        case LoaderType.rotatingIcon:
          loader = _buildRotatingIcon();
          break;
        case LoaderType.bouncingDots:
          loader = _buildBouncingDots();
          break;
        case LoaderType.expandingCircle:
          loader = _buildExpandingCircle();
          break;
        case LoaderType.ringGradient:
          loader = _buildGradientRing();
          break;
        case LoaderType.pulse:
          loader = _buildPulseDot();
          break;
        case LoaderType.bar:
          loader = _buildBar();
          break;
      }
    }

    return Semantics(
      label: widget.semanticsLabel ?? 'Loading',
      child: SizedBox.square(
        dimension: widget.size,
        child: loader,
      ),
    );
  }

  /// A rotating [Icons.autorenew] that cycles through [colors].
  Widget _buildRotatingIcon() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final index = (_controller.value * widget.colors.length).floor() %
            widget.colors.length;
        return Transform.rotate(
          angle: _animation.value * 2 * pi,
          child: Icon(
            Icons.autorenew,
            color: widget.colors[index],
            size: widget.size,
          ),
        );
      },
    );
  }

  /// A row of dots scaling up and down in sequence.
  Widget _buildBouncingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.colors.length, (i) {
        return ScaleTransition(
          scale: Tween(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                i / widget.colors.length,
                1.0,
                curve: widget.curve,
              ),
            ),
          ),
          child: Container(
            width: widget.size / (widget.colors.length * 1.5),
            height: widget.size / (widget.colors.length * 1.5),
            decoration: BoxDecoration(
              color: widget.colors[i],
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  /// A circle that expands then fades out.
  Widget _buildExpandingCircle() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final v = widget.autoReverse
            ? (_animation.value < 0.5
                ? _animation.value * 2
                : (1 - _animation.value) * 2)
            : _animation.value;
        final d = widget.size * v;
        return Center(
          child: Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              color: widget.colors.first.withValues(alpha: 1 - v),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  /// A spinning gradient ring using a [SweepGradient].
  Widget _buildGradientRing() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return CustomPaint(
          painter: _GradientRingPainter(
            animationValue: _animation.value,
            colors: widget.colors,
            strokeWidth: widget.size * 0.1,
          ),
        );
      },
    );
  }

  /// A single dot that pulses (scales in and out).
  Widget _buildPulseDot() {
    return Center(
      child: ScaleTransition(
        scale: Tween(begin: 0.5, end: 1.0).animate(_animation),
        child: Container(
          width: widget.size * 0.3,
          height: widget.size * 0.3,
          decoration: BoxDecoration(
            color: widget.colors.first,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  /// A horizontal bar that fills from left to right.
  Widget _buildBar() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final f = widget.autoReverse
            ? (_animation.value < 0.5
                ? _animation.value * 2
                : (1 - _animation.value) * 2)
            : _animation.value;
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: widget.size * f,
            height: widget.size * 0.2,
            color: widget.colors.first,
          ),
        );
      },
    );
  }
}

/// Painter for a determinate circular progress arc.
class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _ProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * pi, false, bgPaint);
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter old) =>
      old.progress != progress || old.color != color;
}

/// Painter for an indeterminate gradient ring.
class _GradientRingPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;
  final double strokeWidth;

  _GradientRingPainter({
    required this.animationValue,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;
    final gradient = SweepGradient(
      colors: colors,
      startAngle: 0,
      endAngle: 2 * pi,
      transform: GradientRotation(animationValue * 2 * pi),
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter old) =>
      old.animationValue != animationValue || old.colors != colors;
}
