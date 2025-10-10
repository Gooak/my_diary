# 나의 작은 추억 일기 📖✨

당신의 모든 순간을 소중하게, 심플한 감성 일기장  
추억카드를 쌓아 소중한 기억을 간직하고, 매일의 기분과 날씨, 할 일을 기록하며 온전히 나에게 집중하는 시간을 선물하는 모바일 다이어리 앱입니다.

---

# 스토어 업로드 이미지
<img src="https://github.com/Gooak/my_diary/assets/91882939/20060cdf-c51e-4738-add5-6463c6714e98" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/3e9876cd-99ea-4960-80bd-d258effbf020" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/6352a474-337c-4be6-b748-930da8b18446" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/f9465ef9-cba3-4f12-90a5-e7ad6431353f" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/521472f3-37ba-447a-b29b-bb3afbd6e3ae" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/d5bf8f7d-88a8-4183-b9f4-ba513776199e" width="200" height="400"/>
<img src="https://github.com/Gooak/my_diary/assets/91882939/ac727dd4-3fd4-467c-aca6-a6f3fec2dca2" width="200" height="400"/>

---

## 📌 주요 기능 (Features)

- **🗂️ 추억 카드**  
  잊고 싶지 않은 순간들을 심플한 카드 디자인으로 기록하고 모아보세요.

- **📅 캘린더 일기**  
  매일의 기분, 날씨, 짧은 일기를 기록하면 캘린더에 아이콘으로 표시되어 나의 감정 흐름을 한눈에 파악할 수 있습니다.

- **✅ 투두리스트 & 홈 위젯**  
  오늘의 할 일을 관리하고, 홈 화면 위젯으로 언제든지 확인하여 생산성을 높일 수 있습니다.

- **🎨 커스텀 테마**  
  다양한 색상 테마로 앱의 분위기를 바꿔 나만의 공간을 꾸밀 수 있습니다.

- **☁️ 구글 드라이브 백업/복원**  
  Google Drive API를 통해 소중한 투두리스트 데이터를 안전하게 백업하고 새 기기에서도 복원할 수 있습니다.

- **💰 인앱 광고**  
  Google Mobile Ads를 통한 수익 모델이 적용되어 있습니다.

---

## 🛠️ 기술 스택 및 아키텍처 (Tech Stack & Architecture)

본 프로젝트는 Flutter 앱 개발의 최신 트렌드와 안정적인 아키텍처를 적용하여 확장성과 유지보수성을 높이는 데 중점을 두었습니다.

### 아키텍처 (Architecture)

- **Clean Architecture**  
  Presentation - Domain - Data 3개의 계층으로 역할을 명확히 분리하여, 각 부분이 독립적으로 개발되고 테스트될 수 있도록 설계

- **MVVM (Model-View-ViewModel)**  
  Presentation Layer에서 Notifier(ViewModel)를 통해 UI와 비즈니스 로직을 분리하고, 단방향 데이터 흐름(UDF)을 구현

- **Repository Pattern**  
  데이터 소스(Firebase, Hive, Google Drive)를 추상화하여 데이터 접근 방식을 일원화하고, UseCase가 구체적인 구현에 의존하지 않도록 설계

### 사용된 기술 (Tech Stack)

- **Framework**: Flutter  
- **State Management**: Riverpod (Provider 대체)  
- **Data Storage**:
  - Cloud: Firebase (Auth, Cloud Firestore, Storage)  
  - Local: Hive (투두리스트, 앱 설정 등)  
- **Authentication**: Firebase Auth, Google Sign-In  
- **Cloud Service / Backup**: Google APIs (Google Drive)  
- **Native Integration**: home_widget (안드로이드 홈 위젯 연동)  
- **Asynchronous**: Future, Stream  

---

## 🔄 업데이트 내역 (What's New)
### ver 1.0.10+11
- 투두리스트를 보기 위한 홈 위젯 추가<br>
### ver 1.0.10+11
- 앱 출시 및 구글 광고 추가<br>
### ver 1.0.10+11
- 투두리스트 텍스트 색상 변경 버그 수정 및 디자인 부분 수정, 피드백 전송 글자 수 100제한<br>
### ver 1.0.10+11
-  추억카드, 하루 기분, 투두리스트 광고 위치 수정<br>
### ver 1.0.10+11
- 안드로이드 SDK Version 35이상 타겟팅 수정
### ver 1.0.10+11
- 아키텍처 대규모 리팩토링 및 상태 관리 시스템 교체
- 상태 관리 마이그레이션: Provider → Riverpod  
- 클린 아키텍처 도입: Presentation - Domain - Data 3계층 완전 적용  
- UseCase와 Repository 분리, UI와 결합도 최소화  
- 코드베이스 구조 개선, 기능 추가 및 유지보수 용이
- 안드로이드 앱 16KB 메모리 페이지 크기를 지원

---

## 📁 파일 구조 (Directory Structure)

```
lib/
├── main.dart                 # 앱의 시작점 (Entry Point)
├── app_route.dart            # 앱 내 화면 네비게이션 및 라우팅 관리
├── app_gate.dart             # 인증 상태에 따라 Home 또는 Signin 화면으로 분기
│
└── src/
    ├── core/                 # 앱 전반에서 사용되는 공통 모듈
    │   ├── provider/         # data_source, repository 의존성 주입 
    │   ├── services/         # 패키지 정보 등 외부 서비스 연동
    │   ├── utils/            # 날짜 포맷 등 유틸리티 함수
    │   └── constants.dart    # 앱의 상수 값 (env 파일)
    │
    ├── data/                 # Data Layer: 데이터 소스와의 통신
    │   ├── local/            # Hive 등 로컬 DB 관련 코드
    │   ├── local_data_source/  # 로컬 데이터 소스 추상화 및 구현
    │   ├── remote_data_source/ # Firebase, Google Drive 등 원격 데이터 소스
    │   └── repository/        # Repository 구현체
    │
    ├── domain/               # Domain Layer: 핵심 비즈니스 로직
    │   ├── enum/             # 앱의 비즈니스 규칙과 관련된 Enum
    │   ├── error/            # 커스텀 에러 및 예외 클래스
    │   ├── model/            # 순수한 데이터 모델 (Entity)
    │   ├── repository/       # Repository 인터페이스 (규칙)
    │   └── use_case/         # 비즈니스 로직 캡슐화 (UseCase)
    │
    └── presentation/         # Presentation Layer: UI 및 상태 관리
        ├── common/           # 여러 화면에서 재사용되는 공통 UI
        │   ├── theme/        # 앱의 디자인 테마 및 스타일
        │   └── widgets/      # 공용 위젯 (다이얼로그, 버튼 등)
        │
        └── features/         # 각 기능별 UI 및 상태 관리
            ├── main_page/    # 메인 화면 관련 폴더
            │   ├── calendar/
            │   ├── diary/
            │   └── my_page/
            ├── notifier/     # ViewModel (Riverpod Notifier)
            └── providers/    # notifier, usecase 의존성 주입
```


