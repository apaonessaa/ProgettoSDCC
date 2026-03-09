import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff902500),
      surfaceTint: Color(0xffab350f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb33b15),
      onPrimaryContainer: Color(0xffffdad0),
      secondary: Color(0xff8e4c39),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfffea991),
      onSecondaryContainer: Color(0xff793b29),
      tertiary: Color(0xff745b00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc8a84a),
      onTertiaryContainer: Color(0xff4f3d00),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff251915),
      onSurfaceVariant: Color(0xff59413b),
      outline: Color(0xff8c7169),
      outlineVariant: Color(0xffe0bfb7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3c2d29),
      inversePrimary: Color(0xffffb5a0),
      primaryFixed: Color(0xffffdbd1),
      onPrimaryFixed: Color(0xff3b0900),
      primaryFixedDim: Color(0xffffb5a0),
      onPrimaryFixedVariant: Color(0xff862200),
      secondaryFixed: Color(0xffffdbd1),
      onSecondaryFixed: Color(0xff390b01),
      secondaryFixedDim: Color(0xffffb5a0),
      onSecondaryFixedVariant: Color(0xff713524),
      tertiaryFixed: Color(0xffffe08b),
      onTertiaryFixed: Color(0xff241a00),
      tertiaryFixedDim: Color(0xffe5c362),
      onTertiaryFixedVariant: Color(0xff584400),
      surfaceDim: Color(0xffedd5cf),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ed),
      surfaceContainer: Color(0xffffe9e4),
      surfaceContainerHigh: Color(0xfffbe3dd),
      surfaceContainerHighest: Color(0xfff6ddd7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff691800),
      surfaceTint: Color(0xffab350f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb33b15),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff5c2515),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffa05a46),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff443400),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff856a0d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff1a0e0b),
      onSurfaceVariant: Color(0xff47312b),
      outline: Color(0xff654d46),
      outlineVariant: Color(0xff826760),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3c2d29),
      inversePrimary: Color(0xffffb5a0),
      primaryFixed: Color(0xffbf441d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff9d2c04),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffa05a46),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff824330),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff856a0d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff685200),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd9c2bc),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ed),
      surfaceContainer: Color(0xfffbe3dd),
      surfaceContainerHigh: Color(0xfff0d8d1),
      surfaceContainerHighest: Color(0xffe4cdc6),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff581300),
      surfaceTint: Color(0xffab350f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8b2300),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4f1c0c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff743826),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff382a00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5b4700),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff3b2721),
      outlineVariant: Color(0xff5b443d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3c2d29),
      inversePrimary: Color(0xffffb5a0),
      primaryFixed: Color(0xff8b2300),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff631600),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff743826),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff582212),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5b4700),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff403100),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcab4ae),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffede8),
      surfaceContainer: Color(0xfff6ddd7),
      surfaceContainerHigh: Color(0xffe7cfc9),
      surfaceContainerHighest: Color(0xffd9c2bc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb5a0),
      surfaceTint: Color(0xffffb5a0),
      onPrimary: Color(0xff5f1500),
      primaryContainer: Color(0xffb33b15),
      onPrimaryContainer: Color(0xffffdad0),
      secondary: Color(0xffffb5a0),
      onSecondary: Color(0xff552010),
      secondaryContainer: Color(0xff713524),
      onSecondaryContainer: Color(0xfff4a088),
      tertiary: Color(0xffe5c362),
      onTertiary: Color(0xff3d2f00),
      tertiaryContainer: Color(0xffc8a84a),
      onTertiaryContainer: Color(0xff4f3d00),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1c110d),
      onSurface: Color(0xfff6ddd7),
      onSurfaceVariant: Color(0xffe0bfb7),
      outline: Color(0xffa88a82),
      outlineVariant: Color(0xff59413b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff6ddd7),
      inversePrimary: Color(0xffab350f),
      primaryFixed: Color(0xffffdbd1),
      onPrimaryFixed: Color(0xff3b0900),
      primaryFixedDim: Color(0xffffb5a0),
      onPrimaryFixedVariant: Color(0xff862200),
      secondaryFixed: Color(0xffffdbd1),
      onSecondaryFixed: Color(0xff390b01),
      secondaryFixedDim: Color(0xffffb5a0),
      onSecondaryFixedVariant: Color(0xff713524),
      tertiaryFixed: Color(0xffffe08b),
      onTertiaryFixed: Color(0xff241a00),
      tertiaryFixedDim: Color(0xffe5c362),
      onTertiaryFixedVariant: Color(0xff584400),
      surfaceDim: Color(0xff1c110d),
      surfaceBright: Color(0xff453632),
      surfaceContainerLowest: Color(0xff160b08),
      surfaceContainerLow: Color(0xff251915),
      surfaceContainer: Color(0xff291d19),
      surfaceContainerHigh: Color(0xff352723),
      surfaceContainerHighest: Color(0xff40312d),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd2c6),
      surfaceTint: Color(0xffffb5a0),
      onPrimary: Color(0xff4c0f00),
      primaryContainer: Color(0xffef663d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd2c6),
      onSecondary: Color(0xff471507),
      secondaryContainer: Color(0xffca7d67),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffcd975),
      onTertiary: Color(0xff302400),
      tertiaryContainer: Color(0xffc8a84a),
      onTertiaryContainer: Color(0xff2a1f00),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1c110d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff7d5cc),
      outline: Color(0xffcbaba2),
      outlineVariant: Color(0xffa78a82),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff6ddd7),
      inversePrimary: Color(0xff892200),
      primaryFixed: Color(0xffffdbd1),
      onPrimaryFixed: Color(0xff280500),
      primaryFixedDim: Color(0xffffb5a0),
      onPrimaryFixedVariant: Color(0xff691800),
      secondaryFixed: Color(0xffffdbd1),
      onSecondaryFixed: Color(0xff280500),
      secondaryFixedDim: Color(0xffffb5a0),
      onSecondaryFixedVariant: Color(0xff5c2515),
      tertiaryFixed: Color(0xffffe08b),
      onTertiaryFixed: Color(0xff171000),
      tertiaryFixedDim: Color(0xffe5c362),
      onTertiaryFixedVariant: Color(0xff443400),
      surfaceDim: Color(0xff1c110d),
      surfaceBright: Color(0xff51413d),
      surfaceContainerLowest: Color(0xff0f0504),
      surfaceContainerLow: Color(0xff271b17),
      surfaceContainer: Color(0xff322521),
      surfaceContainerHigh: Color(0xff3e2f2b),
      surfaceContainerHighest: Color(0xff4a3a36),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece7),
      surfaceTint: Color(0xffffb5a0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffaf98),
      onPrimaryContainer: Color(0xff1e0300),
      secondary: Color(0xffffece7),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffaf98),
      onSecondaryContainer: Color(0xff1e0300),
      tertiary: Color(0xffffefca),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe1bf5f),
      onTertiaryContainer: Color(0xff100a00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1c110d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece7),
      outlineVariant: Color(0xffdcbbb3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff6ddd7),
      inversePrimary: Color(0xff892200),
      primaryFixed: Color(0xffffdbd1),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb5a0),
      onPrimaryFixedVariant: Color(0xff280500),
      secondaryFixed: Color(0xffffdbd1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb5a0),
      onSecondaryFixedVariant: Color(0xff280500),
      tertiaryFixed: Color(0xffffe08b),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe5c362),
      onTertiaryFixedVariant: Color(0xff171000),
      surfaceDim: Color(0xff1c110d),
      surfaceBright: Color(0xff5d4c48),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff291d19),
      surfaceContainer: Color(0xff3c2d29),
      surfaceContainerHigh: Color(0xff473834),
      surfaceContainerHighest: Color(0xff53433f),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}