// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class GoogleAd extends StatefulWidget {
//   const GoogleAd({super.key});

//   @override
//   State<GoogleAd> createState() => _GoogleAd();
// }

// class _GoogleAd extends State<GoogleAd> {
//   late BannerAd banner;
//   @override
//   void initState() {
//     super.initState();
//     banner = BannerAd(
//       listener: BannerAdListener(
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {},
//         onAdLoaded: (_) {},
//       ),
//       size: AdSize.banner,
//       adUnitId: androidId,
//       request: const AdRequest(),
//     )..load();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     banner.dispose();
//   }

//   final androidId = kReleaseMode ? 'ca-app-pub-2418397088815529/2757171994' : 'ca-app-pub-3940256099942544/6300978111'; //진짜 id
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10, top: 10),
//       height: 60,
//       child: AdWidget(ad: banner),
//     );
//   }
// }
