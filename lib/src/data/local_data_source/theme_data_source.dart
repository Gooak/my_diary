import 'package:hive/hive.dart';

abstract class ThemeDataSource {
  int getThemeMode();
  Future<void> setThemeMode(int themeMode);
}

class ThemeDataSourceImpl implements ThemeDataSource {
  
  @override
  int getThemeMode(){
    final box = Hive.box<int>('AppTheme');
    return box.get('AppTheme', defaultValue: 0) ?? 0;
  }

  @override
  Future<void> setThemeMode(int themeMode) async {
    final box = Hive.box<int>('AppTheme');
    await box.put('AppTheme', themeMode);
  }
}