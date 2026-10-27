import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color success;
  final Color danger;
  final Color onDanger;
  final Color subtleText;
  final Color heroStart;
  final Color heroEnd;
  final Color onHero;

  const AppColorsExtension({
    required this.success,
    required this.danger,
    required this.onDanger,
    required this.subtleText,
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
  });

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? danger,
    Color? onDanger,
    Color? subtleText,
    Color? heroStart,
    Color? heroEnd,
    Color? onHero,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      subtleText: subtleText ?? this.subtleText,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      onHero: onHero ?? this.onHero,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      subtleText: Color.lerp(subtleText, other.subtleText, t)!,
      heroStart: Color.lerp(heroStart, other.heroStart, t)!,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 28.0;

  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconXl = 48.0;

  static const double buttonHeight = 48.0;
  static const double avatarMd = 44.0;
  static const double pulseDot = 8.0;
  static const double illustrationSize = 170.0;
  static const double decorCircle = 160.0;
  static const double shadowBlur = 32.0;

  static const double opacitySubtle = 0.12;
  static const double opacityGlass = 0.2;
  static const double opacityGlow = 0.35;
  static const double opacityHint = 0.75;

  static const double borderDefault = 1.0;
  static const double borderThick = 2.0;

  static final ThemeData darkTheme = _buildTheme(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2DD4BF),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF5EEAD4),
      onPrimary: const Color(0xFF042F2E),
      surface: const Color(0xFF0B1220),
      onSurface: const Color(0xFFE6EDF7),
      surfaceContainerLow: const Color(0xFF121B2E),
      surfaceContainer: const Color(0xFF17223A),
      surfaceContainerHighest: const Color(0xFF223050),
      outline: const Color(0xFF33425F),
    ),
    appColors: const AppColorsExtension(
      success: Color(0xFF34D399),
      danger: Color(0xFFF87171),
      onDanger: Color(0xFF3B0A0A),
      subtleText: Color(0xFF94A3B8),
      heroStart: Color(0xFF0F766E),
      heroEnd: Color(0xFF4338CA),
      onHero: Color(0xFFFFFFFF),
    ),
  );

  static final ThemeData lightTheme = _buildTheme(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    ),
    appColors: const AppColorsExtension(
      success: Color(0xFF059669),
      danger: Color(0xFFDC2626),
      onDanger: Color(0xFFFFFFFF),
      subtleText: Color(0xFF5B6475),
      heroStart: Color(0xFF0F766E),
      heroEnd: Color(0xFF4338CA),
      onHero: Color(0xFFFFFFFF),
    ),
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required AppColorsExtension appColors,
  }) {
    final textTheme = _buildTextTheme(colorScheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarThemeData(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: colorScheme.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(
              color: colorScheme.outline.withValues(alpha: opacityGlow)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, buttonHeight),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, buttonHeight),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium)),
          side: BorderSide(color: colorScheme.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge)),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surfaceContainerHighest,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium)),
      ),
      extensions: [appColors],
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final base = GoogleFonts.interTextTheme(
      ThemeData(colorScheme: colorScheme, useMaterial3: true).textTheme,
    );
    TextStyle? display(TextStyle? s, FontWeight w) =>
        GoogleFonts.spaceGrotesk(textStyle: s?.copyWith(fontWeight: w));
    return base.copyWith(
      headlineLarge: display(base.headlineLarge, FontWeight.w700),
      headlineMedium: display(base.headlineMedium, FontWeight.w700),
      headlineSmall: display(base.headlineSmall, FontWeight.w600),
      titleLarge: display(base.titleLarge, FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
