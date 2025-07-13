// test/animated_loader_test.dart
import 'package:animated_loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimatedLoader Widget', () {
    testWidgets(
        'renders exactly one _ProgressPainter CustomPaint when progress is non-null',
        (WidgetTester tester) async {
      // 1. Pump an AnimatedLoader in determinate mode
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedLoader(
                progress: 0.5,
                colors: [Colors.orange],
                size: 100,
              ),
            ),
          ),
        ),
      );

      // 2. Find the loader itself
      final loader = find.byType(AnimatedLoader);
      expect(loader, findsOneWidget);

      // 3. Inside that loader, expect exactly one CustomPaint
      final paints = find.descendant(
        of: loader,
        matching: find.byType(CustomPaint),
      );
      expect(paints, findsOneWidget);
    });

    testWidgets('renders rotating icon when loaderType is rotatingIcon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedLoader(
                loaderType: LoaderType.rotatingIcon,
                colors: [Colors.green, Colors.blue],
                size: 80,
                duration: Duration(milliseconds: 500),
              ),
            ),
          ),
        ),
      );

      final loader = find.byType(AnimatedLoader);
      expect(loader, findsOneWidget);

      // There should be exactly one Icon inside the loader
      final icons = find.descendant(of: loader, matching: find.byType(Icon));
      expect(icons, findsOneWidget);

      // Advance the animation
      await tester.pump(const Duration(milliseconds: 250));
      expect(icons, findsOneWidget);
    });

    testWidgets('renders correct number of dots for bouncingDots mode',
        (WidgetTester tester) async {
      const colors = [Colors.red, Colors.yellow, Colors.green, Colors.blue];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedLoader(
                loaderType: LoaderType.bouncingDots,
                colors: colors,
                size: 60,
                duration: Duration(milliseconds: 400),
              ),
            ),
          ),
        ),
      );

      final loader = find.byType(AnimatedLoader);
      expect(loader, findsOneWidget);

      // Inside the loader: one Row
      final row = find.descendant(of: loader, matching: find.byType(Row));
      expect(row, findsOneWidget);

      // Inside that Row: exactly colors.length ScaleTransitions
      final dots = find.descendant(
        of: row,
        matching: find.byType(ScaleTransition),
      );
      expect(dots, findsNWidgets(colors.length));
    });

    testWidgets('renders exactly one ScaleTransition for pulse mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedLoader(
                loaderType: LoaderType.pulse,
                colors: [Colors.purple],
                size: 50,
                duration: Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
      );

      final loader = find.byType(AnimatedLoader);
      expect(loader, findsOneWidget);

      // Should find one ScaleTransition inside the loader
      final pulses = find.descendant(
        of: loader,
        matching: find.byType(ScaleTransition),
      );
      expect(pulses, findsOneWidget);

      // Its child is the dot Container
      final dot = find.descendant(of: pulses, matching: find.byType(Container));
      expect(dot, findsOneWidget);
    });

    testWidgets('applies semanticsLabel to Semantics node',
        (WidgetTester tester) async {
      const label = 'Loading data…';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedLoader(
                semanticsLabel: label,
              ),
            ),
          ),
        ),
      );

      // This will find the one Semantics node that exposes our custom label.
      expect(find.bySemanticsLabel(label), findsOneWidget);
    });
  });
}
