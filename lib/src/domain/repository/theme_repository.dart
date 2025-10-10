abstract class ThemeRepository {
  //테마 인덱스 불러오기
  int getThemeMode();
  
  //테마 인덱스 저장하기
  Future<void> setThemeMode(int index);
}
