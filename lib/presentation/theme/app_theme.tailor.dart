// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element, unnecessary_cast

part of 'app_theme.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

class AppTheme extends ThemeExtension<AppTheme> {
  const AppTheme({
    required this.backElevated,
    required this.backPrimary,
    required this.backSecondary,
    required this.blue,
    required this.gray,
    required this.grayLight,
    required this.green,
    required this.labelDisable,
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.optionalImportance,
    required this.overlaySupport,
    required this.red,
    required this.separatorSupport,
    required this.textBody,
    required this.textTitleLarge,
    required this.white,
  });

  final Color backElevated;
  final Color backPrimary;
  final Color backSecondary;
  final Color blue;
  final Color gray;
  final Color grayLight;
  final Color green;
  final Color labelDisable;
  final Color labelPrimary;
  final Color labelSecondary;
  final Color labelTertiary;
  final Color optionalImportance;
  final Color overlaySupport;
  final Color red;
  final Color separatorSupport;
  final TextStyle textBody;
  final TextStyle textTitleLarge;
  final Color white;

  static const AppTheme light = AppTheme(
    backElevated: Color(0xFFFFFFFF),
    backPrimary: Color(0xFFF7F6F2),
    backSecondary: Color(0xFFFFFFFF),
    blue: Color(0xFF007AFF),
    gray: Color(0xFF8E8E93),
    grayLight: Color(0xFFD1D1D6),
    green: Color(0xFF34C759),
    labelDisable: Color(0x26000000),
    labelPrimary: Color(0xFF000000),
    labelSecondary: Color(0x99000000),
    labelTertiary: Color(0x4D000000),
    optionalImportance: Color(0xFF793cd8),
    overlaySupport: Color(0x0F000000),
    red: Color(0xFFFF3B30),
    separatorSupport: Color(0x33000000),
    textBody: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      height: 1.25,
      fontWeight: FontWeight.w400,
    ),
    textTitleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 32,
      height: 1.2,
      fontWeight: FontWeight.w500,
    ),
    white: Color(0xFFFFFFFF),
  );

  static const AppTheme dark = AppTheme(
    backElevated: Color(0xFF3C3C3F),
    backPrimary: Color(0xFF161618),
    backSecondary: Color(0xFF252528),
    blue: Color(0xFF0A84FF),
    gray: Color(0xFF8E8E93),
    grayLight: Color(0xFF48484A),
    green: Color(0xFF32D74B),
    labelDisable: Color(0x26FFFFFF),
    labelPrimary: Color(0xFFFFFFFF),
    labelSecondary: Color(0x99FFFFFF),
    labelTertiary: Color(0x66FFFFFF),
    optionalImportance: Color(0xFF793cd8),
    overlaySupport: Color(0x52000000),
    red: Color(0xFFFF453A),
    separatorSupport: Color(0x33FFFFFF),
    textBody: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      height: 1.25,
      fontWeight: FontWeight.w400,
    ),
    textTitleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 32,
      height: 1.2,
      fontWeight: FontWeight.w500,
    ),
    white: Color(0xFFFFFFFF),
  );

  static const themes = [
    light,
    dark,
  ];

  @override
  AppTheme copyWith({
    Color? backElevated,
    Color? backPrimary,
    Color? backSecondary,
    Color? blue,
    Color? gray,
    Color? grayLight,
    Color? green,
    Color? labelDisable,
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? optionalImportance,
    Color? overlaySupport,
    Color? red,
    Color? separatorSupport,
    TextStyle? textBody,
    TextStyle? textTitleLarge,
    Color? white,
  }) {
    return AppTheme(
      backElevated: backElevated ?? this.backElevated,
      backPrimary: backPrimary ?? this.backPrimary,
      backSecondary: backSecondary ?? this.backSecondary,
      blue: blue ?? this.blue,
      gray: gray ?? this.gray,
      grayLight: grayLight ?? this.grayLight,
      green: green ?? this.green,
      labelDisable: labelDisable ?? this.labelDisable,
      labelPrimary: labelPrimary ?? this.labelPrimary,
      labelSecondary: labelSecondary ?? this.labelSecondary,
      labelTertiary: labelTertiary ?? this.labelTertiary,
      optionalImportance: optionalImportance ?? this.optionalImportance,
      overlaySupport: overlaySupport ?? this.overlaySupport,
      red: red ?? this.red,
      separatorSupport: separatorSupport ?? this.separatorSupport,
      textBody: textBody ?? this.textBody,
      textTitleLarge: textTitleLarge ?? this.textTitleLarge,
      white: white ?? this.white,
    );
  }

  @override
  AppTheme lerp(covariant ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) return this as AppTheme;
    return AppTheme(
      backElevated: Color.lerp(backElevated, other.backElevated, t)!,
      backPrimary: Color.lerp(backPrimary, other.backPrimary, t)!,
      backSecondary: Color.lerp(backSecondary, other.backSecondary, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      gray: Color.lerp(gray, other.gray, t)!,
      grayLight: Color.lerp(grayLight, other.grayLight, t)!,
      green: Color.lerp(green, other.green, t)!,
      labelDisable: Color.lerp(labelDisable, other.labelDisable, t)!,
      labelPrimary: Color.lerp(labelPrimary, other.labelPrimary, t)!,
      labelSecondary: Color.lerp(labelSecondary, other.labelSecondary, t)!,
      labelTertiary: Color.lerp(labelTertiary, other.labelTertiary, t)!,
      optionalImportance:
          Color.lerp(optionalImportance, other.optionalImportance, t)!,
      overlaySupport: Color.lerp(overlaySupport, other.overlaySupport, t)!,
      red: Color.lerp(red, other.red, t)!,
      separatorSupport:
          Color.lerp(separatorSupport, other.separatorSupport, t)!,
      textBody: TextStyle.lerp(textBody, other.textBody, t)!,
      textTitleLarge: TextStyle.lerp(textTitleLarge, other.textTitleLarge, t)!,
      white: Color.lerp(white, other.white, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppTheme &&
            const DeepCollectionEquality()
                .equals(backElevated, other.backElevated) &&
            const DeepCollectionEquality()
                .equals(backPrimary, other.backPrimary) &&
            const DeepCollectionEquality()
                .equals(backSecondary, other.backSecondary) &&
            const DeepCollectionEquality().equals(blue, other.blue) &&
            const DeepCollectionEquality().equals(gray, other.gray) &&
            const DeepCollectionEquality().equals(grayLight, other.grayLight) &&
            const DeepCollectionEquality().equals(green, other.green) &&
            const DeepCollectionEquality()
                .equals(labelDisable, other.labelDisable) &&
            const DeepCollectionEquality()
                .equals(labelPrimary, other.labelPrimary) &&
            const DeepCollectionEquality()
                .equals(labelSecondary, other.labelSecondary) &&
            const DeepCollectionEquality()
                .equals(labelTertiary, other.labelTertiary) &&
            const DeepCollectionEquality()
                .equals(optionalImportance, other.optionalImportance) &&
            const DeepCollectionEquality()
                .equals(overlaySupport, other.overlaySupport) &&
            const DeepCollectionEquality().equals(red, other.red) &&
            const DeepCollectionEquality()
                .equals(separatorSupport, other.separatorSupport) &&
            const DeepCollectionEquality().equals(textBody, other.textBody) &&
            const DeepCollectionEquality()
                .equals(textTitleLarge, other.textTitleLarge) &&
            const DeepCollectionEquality().equals(white, other.white));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(backElevated),
      const DeepCollectionEquality().hash(backPrimary),
      const DeepCollectionEquality().hash(backSecondary),
      const DeepCollectionEquality().hash(blue),
      const DeepCollectionEquality().hash(gray),
      const DeepCollectionEquality().hash(grayLight),
      const DeepCollectionEquality().hash(green),
      const DeepCollectionEquality().hash(labelDisable),
      const DeepCollectionEquality().hash(labelPrimary),
      const DeepCollectionEquality().hash(labelSecondary),
      const DeepCollectionEquality().hash(labelTertiary),
      const DeepCollectionEquality().hash(optionalImportance),
      const DeepCollectionEquality().hash(overlaySupport),
      const DeepCollectionEquality().hash(red),
      const DeepCollectionEquality().hash(separatorSupport),
      const DeepCollectionEquality().hash(textBody),
      const DeepCollectionEquality().hash(textTitleLarge),
      const DeepCollectionEquality().hash(white),
    );
  }
}

extension AppThemeBuildContextProps on BuildContext {
  AppTheme get appTheme => Theme.of(this).extension<AppTheme>()!;
  Color get backElevated => appTheme.backElevated;
  Color get backPrimary => appTheme.backPrimary;
  Color get backSecondary => appTheme.backSecondary;
  Color get blue => appTheme.blue;
  Color get gray => appTheme.gray;
  Color get grayLight => appTheme.grayLight;
  Color get green => appTheme.green;
  Color get labelDisable => appTheme.labelDisable;
  Color get labelPrimary => appTheme.labelPrimary;
  Color get labelSecondary => appTheme.labelSecondary;
  Color get labelTertiary => appTheme.labelTertiary;
  Color get optionalImportance => appTheme.optionalImportance;
  Color get overlaySupport => appTheme.overlaySupport;
  Color get red => appTheme.red;
  Color get separatorSupport => appTheme.separatorSupport;
  TextStyle get textBody => appTheme.textBody;
  TextStyle get textTitleLarge => appTheme.textTitleLarge;
  Color get white => appTheme.white;
}
