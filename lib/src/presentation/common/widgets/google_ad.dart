import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_little_memory_diary/src/core/constants.dart';

class GoogleAd extends StatefulWidget {
  const GoogleAd({super.key});

  @override
  State<GoogleAd> createState() => _GoogleAd();
}

class _GoogleAd extends State<GoogleAd> {
  late BannerAd banner;
  @override
  void initState() {
    super.initState();
    banner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      size: AdSize.banner,
      adUnitId: id!,
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    banner.dispose();
  }

  final id = kReleaseMode ? googleAdReleaseBannerId : googleAdDebugBannerId;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      height: 60,
      child: AdWidget(ad: banner),
    );
  }
}
