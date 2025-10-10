import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/data/local_data_source/theme_data_source.dart';
import 'package:my_little_memory_diary/src/data/local_data_source/todo_data_source.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/auth_data_source.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/calendar_data_source.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/diary_data_source.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/backup_drive_data_source.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/image_storage_data_source.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/user_data_source.dart';
import 'package:my_little_memory_diary/src/data/repository/auth_repository_impl.dart';
import 'package:my_little_memory_diary/src/data/repository/backup_drive_repository_impl.dart';
import 'package:my_little_memory_diary/src/data/repository/calendar_repository_impl.dart';
import 'package:my_little_memory_diary/src/data/repository/diary_repository_impl.dart';
import 'package:my_little_memory_diary/src/data/repository/image_repository_impl.dart';
import 'package:my_little_memory_diary/src/data/repository/theme_repository_impl.dart';
import 'package:my_little_memory_diary/src/data/repository/todo_repository_impl.dart';
import 'package:my_little_memory_diary/src/data/repository/user_repository_impl.dart';
import 'package:my_little_memory_diary/src/domain/repository/auth_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/calendar_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/diary_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/backup_drive_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/image_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/theme_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/todo_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/user_repository.dart';

//auth 프로바이더
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return AuthDataSourceImpl();
});
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// user 프로바이더
final userDataSourceProvider = Provider<UserDataSource>((ref) {
  return UserDataSourceImpl();
});
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return UserRepositoryImpl(dataSource);
});

// 테마 프로바이더
final themeDataSourceProvider = Provider<ThemeDataSource>((ref) {
  return ThemeDataSourceImpl();
});
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  final dataSource = ref.watch(themeDataSourceProvider);
  return ThemeRepositoryImpl(dataSource);
});

//calendar 프로바이더
final calendarDataSourceProvider = Provider<CalendarDataSource>((ref) {
  return CalendarDataSourceImpl();
});
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final dataSource = ref.watch(calendarDataSourceProvider);
  return CalendarRepositoryImpl(dataSource);
});

//다이어리 프로바이더
final diaryDataSourceProvider = Provider<DiaryDataSource>((ref) {
  return DiaryDataSourceImpl();
});
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final dataSource = ref.watch(diaryDataSourceProvider);
  return DiaryRepositoryImpl(dataSource);
});

//투두리스트 프로바이더
final todoDataSourceProvider = Provider<TodoDataSource>((ref) {
  return TodoDataSourceImpl();
});
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dataSource = ref.watch(todoDataSourceProvider);
  return TodoRepositoryImpl(dataSource);
});

//이미지 프로바이더
final imageStorageDataSourceProvider = Provider<ImageStorageDataSource>((ref) {
  return ImageStorageDataSourceImpl();
});
final imageStorageRepositoryProvider = Provider<ImageRepository>((ref) {
  final dataSource = ref.watch(imageStorageDataSourceProvider);
  return ImageRepositoryImpl(dataSource);
});

//구글 드라이브 프로바이더
final backupDriveDataSourceProvider = Provider<BackupDriveDataSource>((ref) {
  return BackupDriveDataSourceImpl();
});
final backupDriveRepositoryProvider = Provider<BackupDriveRepository>((ref) {
  final dataSource = ref.watch(backupDriveDataSourceProvider);
  return BackupDriveRepositoryImpl(dataSource);
});
