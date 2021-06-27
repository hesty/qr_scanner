class DarkThemeColor {
static DarkThemeColor? _instance;
static DarkThemeColor get instance {
_instance ??= _instance = DarkThemeColor._init();
return _instance!;
}
DarkThemeColor._init();


}