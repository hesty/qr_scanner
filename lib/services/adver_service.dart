
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'MobileId';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();
  factory AdvertService() => _instance;
  MobileAdTargetingInfo _targetingInfo;

  AdvertService._internal() {
    _targetingInfo = MobileAdTargetingInfo(
      testDevices: testDevice != null ? <String>[testDevice] : null,
      nonPersonalizedAds: true,
    );
  }

  showBanner() {
    BannerAd banner = BannerAd(
        adUnitId: 'ca-app-pub-4694190778906605/8642578056',
        size: AdSize.banner,
        targetingInfo: _targetingInfo);

    banner
      ..load()
      ..show(anchorOffset: 75);

    banner.dispose();
  }

  showIntesitial() {
    InterstitialAd interstitialAd = InterstitialAd(
        adUnitId: 'ca-app-pub-4694190778906605/5989312798',
        targetingInfo: _targetingInfo);

    interstitialAd
      ..load()
      ..show();

    interstitialAd.dispose();
  }
}
