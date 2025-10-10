import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/domain/model/my_page_data_model.dart';

class MyPageNotifier extends AsyncNotifier<MyPageDataModel> {
  @override
  FutureOr<MyPageDataModel> build() {
    return MyPageDataModel.createEmtpy();
  }
}
