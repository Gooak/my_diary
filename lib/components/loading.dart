import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading() async {
  await EasyLoading.show(
    maskType: EasyLoadingMaskType.black,
  );
}

void dismissLoading() async {
  await EasyLoading.dismiss();
}
