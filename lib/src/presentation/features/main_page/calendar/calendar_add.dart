import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_little_memory_diary/src/core/services/loading_service.dart';
import 'package:my_little_memory_diary/src/enum/mood_enum.dart';
import 'package:my_little_memory_diary/src/enum/weather_enum.dart';
import 'package:my_little_memory_diary/src/core/utils/date_helper.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/google_ad.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/google_front_ad.dart';
import 'package:my_little_memory_diary/src/presentation/common/theme/design_input_decoration.dart';
import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/calendar_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';

class CalendarAdd extends ConsumerStatefulWidget {
  const CalendarAdd(
      {super.key, required this.selectedDay, required this.event});
  final CalendarModel? event;
  final DateTime selectedDay;

  @override
  ConsumerState<CalendarAdd> createState() => _CalendarAddState();
}

class _CalendarAddState extends ConsumerState<CalendarAdd>
    with WidgetsBindingObserver {
  late WeatherEnum weather;
  late MoodEnum mood;
  late DateTime date;

  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late BannerAd banner;
  List<WeatherEnum> weatherList = WeatherEnum.values.toList();
  List<MoodEnum> moodList = MoodEnum.values.toList();

  bool isNewEvent = true;

  @override
  void initState() {
    super.initState();
    GoogleFrontAd.initialize();
    WidgetsBinding.instance.addObserver(this);
    if (widget.event != null) {
      weather = weatherList.firstWhere((e) => e.name == widget.event!.weather);
      mood = moodList.firstWhere((e) => e.name == widget.event!.moodImage);
      textController.text = widget.event!.mood;
      date = DateHelper.toDateKeyFromString(widget.event!.date);
      isNewEvent = false;
    } else {
      weather = weatherList.first;
      mood = moodList.first;
      date = widget.selectedDay;
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final calendarNotifier = ref.watch(calendarNotifierProvider.notifier);
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
          LoadingOverlayService.runWithLoading(context, () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            if (!_formKey.currentState!.validate()) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('오늘 기분을 적어주세요')),
              );
            } else {
              await calendarNotifier.setEvent(
                ref.read(userNotifierProvider).value!.email!,
                CalendarModel(
                  date: calendarNotifier.formmated.format(date),
                  weather: weather.name,
                  mood: textController.text,
                  moodImage: mood.name,
                  timestamp: Timestamp.now(),
                ),
                isNewEvent,
              );
              if (context.mounted) {
                Navigator.of(context).pop(date);
                GoogleFrontAd.loadInterstitialAd();
              }
            }
          });
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      weatherList.length,
                      (index) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(size.width / 5),
                                  color: weather == weatherList[index]
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(size.width / 5),
                                onTap: () {
                                  weather = weatherList[index];
                                  setState(() {});
                                },
                                child: ExtendedImage.asset(
                                  weatherList[index].path,
                                  width: size.width / 5,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(weatherList[index].koreaName.toString())
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('기분 선택'),
                const SizedBox(
                  height: 5,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      moodList.length,
                      (index) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(size.width / 5),
                                  color: mood == moodList[index]
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(size.width / 5),
                                onTap: () {
                                  mood = moodList[index];
                                  setState(() {});
                                },
                                child: ExtendedImage.asset(
                                  moodList[index].path,
                                  width: size.width / 5,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(moodList[index].koreaName.toString())
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('일기'),
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
                      decoration: DesignInputDecoration(
                              hintText: '오늘 하루 일을 적어주세요 (최대 50글자)',
                              icon: null,
                              circular: 5,
                              hintCount: null)
                          .inputDecoration,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '오늘 하루 일을 적어주세요';
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
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
