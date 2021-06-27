import 'package:qr_scanner/core/init/theme/dark/dark_text_theme.dart';
import 'package:qr_scanner/core/init/theme/dark/dark_theme_color.dart';

abstract class IDarkTheme {
  DarkThemeColor colorSchema = DarkThemeColor.instance;
  DarkTextTheme textTheme = DarkTextTheme.instance;
}
