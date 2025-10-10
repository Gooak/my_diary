import 'package:my_little_memory_diary/src/data/local_data_source/theme_data_source.dart';
import 'package:my_little_memory_diary/src/domain/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeDataSource _dataSource;
  ThemeRepositoryImpl(this._dataSource);

  // 테마 인덱스 가져오기
  @override
  int getThemeMode() {
    return _dataSource.getThemeMode();
  }

  // 새로운 테마 인덱스 넣기
  @override
  Future<void> setThemeMode(int index) async {
    await _dataSource.setThemeMode(index);
  }
}