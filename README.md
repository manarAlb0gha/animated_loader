# animated_loader

[![pub version](https://img.shields.io/pub/v/animated_loader)](https://pub.dev/packages/animated_loader)  
[![license](https://img.shields.io/pub/license/animated_loader)](LICENSE)  
[![stars on GitHub](https://img.shields.io/github/stars/yourusername/animated_loader?style=social)](https://github.com/yourusername/animated_loader/stargazers)

A highly-customizable Flutter loading indicator widget with both determinate and indeterminate modes, six built-in animation styles, theming support, accessibility labels, and builder-hooks for full control.

---

<p align="center">
  <!-- Replace with your own GIF or PNG in `screenshots/demo.gif` -->
  <img src="https://raw.githubusercontent.com/manarAlb0gha/animated_loader/main/screenshots/animated_loader_demo.gif" 
       alt="Animated Loader Demo" width="400" />
</p>

---

## Features

- Determinate circular progress (0.0 → 1.0)
- Six indeterminate animations:
    - `rotatingIcon`
    - `bouncingDots`
    - `expandingCircle`
    - `ringGradient`
    - `pulse`
    - `bar`
- Infinite or finite repeat cycles (`repeatCount`)
- Auto-reverse support
- Custom animation curve (`curve`)
- Custom size & color palette
- Accessibility label (`semanticsLabel`)
- Builder-hook for full custom widget injection
- Zero runtime dependencies beyond Flutter

---



## Installation

Add to your `pubspec.yaml`:
```yaml
dependencies:
  animated_loader: ^0.1.4
```

## Usage

```dart
import 'package:customizable_rating_bar/customizable_rating_bar.dart';
```

## API Reference

| Parameter        | Type           | Default                             | Description                                                                                 |
| ---------------- | -------------- | ----------------------------------- | ------------------------------------------------------------------------------------------- |
| `size`           | `double`       | `48`                                | Width and height of the loader.                                                             |
| `colors`         | `List<Color>`  | `[Colors.blue, Colors.red, Colors.green]` | Palette of colors used by the animation.                                   |
| `duration`       | `Duration`     | `Duration(seconds: 1)`              | Duration of one full animation cycle.                                                       |
| `curve`          | `Curve`        | `Curves.linear`                     | Animation easing curve.                                                                     |
| `loaderType`     | `LoaderType`   | `LoaderType.rotatingIcon`           | One of `rotatingIcon`, `bouncingDots`, `expandingCircle`, `ringGradient`, `pulse`, `bar`.   |
| `autoReverse`    | `bool`         | `false`                             | If true, the animation reverses back and forth.                                             |
| `repeatCount`    | `int?`         | `null` (infinite)                   | Number of animation cycles; `null` means infinite looping.                                  |
| `progress`       | `double?`      | `null`                              | 0.0–1.0 determinate progress (draws a circular progress).                                   |
| `semanticsLabel` | `String?`      | `'Loading'`                         | Accessibility label for screen readers.                                                     |#   a n i m a t e d _ l o a d e r 
 
 