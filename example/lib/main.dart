import 'package:flutter/material.dart';
import 'package:animated_loader/animated_loader.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Animated Loader Demo')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedLoader(
              loaderType: LoaderType.ringGradient,
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedLoader(loaderType: LoaderType.pulse),
            SizedBox(
              height: 20,
            ),
            AnimatedLoader(loaderType: LoaderType.bar),
            SizedBox(
              height: 20,
            ),
            AnimatedLoader(loaderType: LoaderType.bouncingDots),
            SizedBox(
              height: 20,
            ),
            AnimatedLoader(loaderType: LoaderType.expandingCircle),
            SizedBox(
              height: 20,
            ),
            AnimatedLoader(
              progress: 0.7,
            ),
          ],
        )),
      ),
    );
  }
}
