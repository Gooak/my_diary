import 'package:upgrader/upgrader.dart';

class AppUpgradeMessages extends UpgraderMessages {
  @override
  String get title => '업데이트 알림';

  @override
  String get body => '최신버전으로 업데이트 해주세요!';

  @override
  String get prompt => '보다 나은 성능을 위해 업데이트를 부탁드립니다.';

  @override
  String get releaseNotes => '';
}
