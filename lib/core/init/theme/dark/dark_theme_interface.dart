import 'dark_text_theme.dart';
import 'dark_theme_color.dart';

abstract class IDarkTheme {
  DarkThemeColor colorSchema = DarkThemeColor.instance;
  DarkTextTheme textTheme = DarkTextTheme.instance;
}
