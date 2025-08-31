# 나의 작은 추억 일기 my_little_memory_diary
>심플한 디자인으로 추억카드를 쌓아가고<br>
오늘 있었던 하루를 기분, 날씨, 일기로 나타내어 캘린더에 나타냅니다.<br>
투두리스트로 해야할 일을 적어놓고 바탕화면 위젯에 나타내도록 합니다.<br>



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

# 스토어 업로드 이미지
<img src="https://github.com/Gooak/my_diary/assets/91882939/20060cdf-c51e-4738-add5-6463c6714e98" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/3e9876cd-99ea-4960-80bd-d258effbf020" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/6352a474-337c-4be6-b748-930da8b18446" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/f9465ef9-cba3-4f12-90a5-e7ad6431353f" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/521472f3-37ba-447a-b29b-bb3afbd6e3ae" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/d5bf8f7d-88a8-4183-b9f4-ba513776199e" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/ac727dd4-3fd4-467c-aca6-a6f3fec2dca2" width="200" height="400"/>

---

### 💡 프로젝트 개요 및 목표

- **프로젝트명:** 나의 작은 추억 일기 (my_little_memory_diary)
- **목표:** 사용자가 자신의 추억, 일상, 기분, 해야 할 일 등을 쉽고 편리하게 기록하고 관리하며, 개인적인 데이터를 안전하게 보관하고 활용할 수 있도록 돕는 모바일 애플리케이션을 제공합니다.

---

### 📌 주요 기능

- **추억 카드:** 심플한 디자인으로 사용자만의 추억을 카드 형태로 기록하고 쌓을 수 있습니다.
- **일기 작성 및 캘린더 연동:** 매일의 기분, 날씨, 일기 내용을 기록하면 캘린더에 자동으로 표시되어 한눈에 일상을 파악할 수 있습니다.
- **투두리스트 관리:** 해야 할 일을 기록하고, 안드로이드 홈 화면 위젯을 통해 바로 확인할 수 있어 생산성 관리에 유용합니다.
- **개인화 테마:** 사용자가 원하는 색상 테마로 앱 디자인을 변경하여 자신만의 공간으로 커스터마이징할 수 있습니다.
- **구글 드라이브 백업:** 중요한 투두리스트 데이터를 구글 드라이브 API를 활용하여 안전하게 백업하고 복원할 수 있습니다.
- **앱 내 광고:** Google Mobile Ads를 통한 수익 모델이 적용되어 있습니다.

---

### 💻 기술 스택

- **프레임워크:** Flutter (크로스 플랫폼 모바일 앱 개발)
- **상태 관리:** Provider
- **데이터 저장:**
    - **클라우드:** Firebase (인증, 회원 정보, 추억 카드, 일기 등 주요 데이터 관리)
    - **로컬:** Hive (투두리스트, 색상 테마 등 앱 내부 데이터 저장)
- **인증:** Firebase Auth, Google Sign-In
- **클라우드 서비스:** Firebase Storage, Cloud Firestore
- **데이터 동기화/백업:** Google APIs (Google Drive 백업)
- **광고:** Google Mobile Ads
- **기타:** table_calendar, home_widget (안드로이드 위젯 연동), firebase_messaging, firebase_crashlytics 등 다수의 라이브러리 활용.

---

### ⚙️ 아키텍처 및 특징

- **아키텍처 패턴:** MVVM (Model-View-ViewModel) 패턴을 기반으로 하여 코드의 유지보수성과 확장성을 높였습니다.
- **디자인 시스템:** Material3 테마를 사용하여 일관되고 현대적인 사용자 경험을 제공합니다.
- **하이브리드 데이터 관리:** Firebase를 통한 클라우드 기반 데이터 동기화와 Hive를 통한 로컬 데이터 저장을 병행하여 안정성과 유연성을 확보했습니다.
- **네이티브 기능 연동:** `home_widget` 라이브러리를 통해 네이티브 플랫폼(안드로이드)의 홈 위젯 기능을 활용하여 투두리스트를 실시간으로 업데이트합니다.
- **지속적인 개선:** 앱 출시 후에도 버그 수정, 디자인 개선, 광고 위치 최적화 등 꾸준한 업데이트를 진행하여 사용자 경험을 개선하고 있습니다.

# 업데이트
  1.0.4+5<br>
  -> 투두리스트를 보기 위한 홈 위젯 추가<br>
  1.0.5+6<br>
  -> 앱 출시 및 구글 광고 추가<br>
  1.0.6+7<br>
  -> 투두리스트 텍스트 색상 변경 버그 수정 및 디자인 부분 수정, 피드백 전송 글자 수 100제한<br>
  1.0.7+8<br>
  -> 추억카드, 하루 기분, 투두리스트 광고 위치 수정<br>
  1.0.9+10<br>
  -> 안드로이드 SDK Version 35이상 타겟팅 수정
