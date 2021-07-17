class RegexpConstans {
  static RegexpConstans? _instance;
  static RegexpConstans get instance {
    _instance ??= _instance = RegexpConstans._init();
    return _instance!;
  }

  RegexpConstans._init();

  RegExp get urlRegExp => RegExp(
      r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?');
  RegExp get emailRegExp => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  RegExp get telNumberRegExp => RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
}
