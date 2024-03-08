// import 'package:flutter/foundation.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class GoogleFrontAd {
//   static const androidId = kReleaseMode ? "ca-app-pub-2418397088815529/6737629668" : "ca-app-pub-3940256099942544/1033173712";
//   static late InterstitialAd _interstitialAd;

//   static Future<void> initialize() async {
//     await InterstitialAd.load(
//       adUnitId: androidId,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;
//         },
//         onAdFailedToLoad: (LoadAdError error) {},
//       ),
//     );
//   }

//   static void loadInterstitialAd() async {
//     _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) {},

//       /// 광고가 로드되면 호출되는 이벤트
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         /// 사용자가 광고를 종료하면 호출되는 이벤트
//         ad.dispose();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         ad.dispose();
//       },
//       onAdImpression: (InterstitialAd ad) {},
//     );
//     _interstitialAd.show();
//   }
// }
