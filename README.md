# my_little_memory_diary

나의 작은 추억 일기
<br>
 
>심플한 디자인으로 추억카드를 쌓아가고<br>
오늘 있었던 하루를 기분, 날씨, 일기로 나타내어 캘린더에 나타냅니다.<br>
투두리스트로 해야할 일을 적어놓고 바탕화면 위젯에 나타내도록 합니다.<br>
Flutter version 3.19.1
<br>
<br>

# Flutter 사용 라이브러리
- flutter_easyloading: ^3.0.5
- firebase_core: ^2.25.4
- provider: ^6.1.1
- firebase_auth: ^4.17.4
- firebase_storage: ^11.6.5
- cloud_firestore: ^4.15.4
- firebase_cached_image: ^0.5.3
- firebase_messaging: ^14.7.15
- google_sign_in: ^6.2.1
- sign_in_button: ^3.2.0
- table_calendar: ^3.0.9
- flutter_localization: ^0.2.0
- image_picker: ^1.0.7
- extended_image: ^8.2.0
- firebase_crashlytics: ^3.4.15
- dio: ^5.4.1
- image_gallery_saver: ^2.0.3
- google_mobile_ads: ^4.0.0
- upgrader: ^9.0.0
- hive: ^2.2.3
- hive_flutter: ^1.1.0
- hive_generator: ^2.0.1
- build_runner: ^2.4.8
- flutter_speed_dial: ^7.0.0
- url_launcher: ^6.2.5
- package_info_plus: ^5.0.1
- fl_chart: ^0.66.2
- home_widget: ^0.4.1
- googleapis: ^13.1.0
- googleapis_auth: ^1.5.0
- path_provider: ^2.1.2
- restart_app: ^1.2.1

# 스토어 등록 이미지
![image](https://github.com/Gooak/my_diary/assets/91882939/6b7dde71-6fca-401a-872f-fc33a7e1763e)
![image](https://github.com/Gooak/my_diary/assets/91882939/2e03008a-7ff9-4972-992e-00a684aa888e)
![image](https://github.com/Gooak/my_diary/assets/91882939/8ae2d587-2e89-47cc-8261-2def0586dd26)
![image](https://github.com/Gooak/my_diary/assets/91882939/55f291a7-a784-4cd8-a268-a3ce72e06f51)
![image](https://github.com/Gooak/my_diary/assets/91882939/69bc1473-bfe9-40d1-9cb9-3a091968074f)
![image](https://github.com/Gooak/my_diary/assets/91882939/fd8b8678-0ae4-4b6e-85f1-2dd4ec3f7444)
![image](https://github.com/Gooak/my_diary/assets/91882939/fe6953fc-6276-405b-9957-3291bbec0933)


# 기술설명
기본적으로 mvvm 패턴을 가지는 형식으로 상태관리로 provider를 선택하였으며
firebase의 로그인, 회원 정보, 추억카드, 일기등을 기록한다.
google 연동하여 로그인 할 수 있도록 만들었고
디자인은 기본적으로 material3테마를 가져가며 provider와 hive를 통해 사용자가 색상테마를 바꿀 수 있도록 만들었다.
투두리스트는 hive를 사용하여 앱 내부에 저장하도록 만들었고, 이를 백업할 수 있도록 구글드라이브API를 사용하였다.
투두리스트를 홈 위젯으로 보여주기 위해 home_widget를 써서 디자인을 하고 네이티브 통신을 해 홈 위젯에 투두리스트를 보여질 수 있게 하였다.



# 버전별 업데이트
  1.0.3+4
  -> 투두리스트를 보기 위한 홈 위젯 추가
  1.0.4+5
  -> 앱 출시 및 구글 광고 추가
