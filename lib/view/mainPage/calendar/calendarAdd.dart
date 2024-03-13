import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_little_memory_diary/common/googleAd.dart';
import 'package:my_little_memory_diary/common/googleFrontAd.dart';
import 'package:my_little_memory_diary/components/design.dart';
import 'package:my_little_memory_diary/components/snackBar.dart';
import 'package:my_little_memory_diary/model/calendar_model.dart';
import 'package:my_little_memory_diary/viewModel/calendar_view_model.dart';
import 'package:my_little_memory_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CalendarAdd extends StatefulWidget {
  const CalendarAdd({super.key, required this.event});
  final CalendarModel? event;

  @override
  State<CalendarAdd> createState() => _CalendarAddState();
}

class _CalendarAddState extends State<CalendarAdd> with WidgetsBindingObserver {
  String weather = '';
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late BannerAd banner;
  var weatherList = <Map<String, String>>[
    {'weather': 'images/sunny.png', 'weatherName': '맑음', 'weatherId': 'sunny'},
    {'weather': 'images/cloud.png', 'weatherName': '구름', 'weatherId': 'cloud'},
    {'weather': 'images/rain.png', 'weatherName': '먹구름', 'weatherId': 'rain'},
    {'weather': 'images/rainning.png', 'weatherName': '비', 'weatherId': 'rainning'},
    {'weather': 'images/snowy.png', 'weatherName': '눈', 'weatherId': 'snowy'},
  ];
  DateTime nowDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    GoogleFrontAd.initialize();
    WidgetsBinding.instance.addObserver(this);
    if (widget.event != null) {
      weather = widget.event!.weather;
      textController.text = widget.event!.mood;
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  void didChangePlatformBrightness() async {
    super.didChangePlatformBrightness();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final calendarProvider = Provider.of<CalendarViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '오늘 기분',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'CalendarAdd',
        onPressed: () async {
          if (weather == '') {
            showCustomSnackBar(context, '날씨를 선택해주세요');
            return;
          } else if (_formKey.currentState!.validate()) {
            final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
            await calendarProvider.setEvent(
                userProvider.user!.email!,
                date,
                CalendarModel(
                    date: date,
                    weather: weather,
                    mood: textController.text,
                    timestamp: Timestamp.now(),
                    calendarCount: widget.event == null ? calendarProvider.calendarCount + 1 : widget.event!.calendarCount!));
            await calendarProvider.getEventList(userProvider.user!.email!, nowDate, countCheck: true);
            if (context.mounted) {
              Navigator.pop(context);
              GoogleFrontAd.loadInterstitialAd();
            }
          } else {
            showCustomSnackBar(context, '오늘 기분을 적어주세요');
          }
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(
              width: 5,
            ),
            Text('저장')
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('날씨 선택'),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: weatherList.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 5,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.width / 5),
                                color: weather == weatherList[index]["weatherId"].toString() ? Theme.of(context).colorScheme.primaryContainer : null),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(size.width / 5),
                              onTap: () {
                                weather = weatherList[index]["weatherId"].toString();
                                setState(() {});
                              },
                              child: ExtendedImage.asset(
                                weatherList[index]["weather"].toString(),
                                width: size.width / 5,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(weatherList[index]["weatherName"].toString())
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('오늘의 기분'),
                const SizedBox(
                  height: 5,
                ),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    height: 200,
                    width: size.width,
                    child: TextFormField(
                      maxLines: null,
                      expands: true,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: textController,
                      maxLength: 50,
                      decoration:
                          DesignInputDecoration(hintText: '오늘 하루의 기분을 적어주세요 (최대 50글자)', icon: null, circular: 5, hintCount: null).inputDecoration,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '오늘 기분을 적어주세요';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const GoogleAd(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
