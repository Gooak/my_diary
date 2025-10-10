import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/provider/repository_providers.dart';
import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';
import 'package:my_little_memory_diary/src/domain/use_case/diary/add_diary_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/diary/delete_diary_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/diary/get_diary_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/diary/update_diary_use_case.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/diary_notifier.dart';

//diary 유스케이스
final getDiaryUseCaseProvider = Provider<GetDiaryUseCase>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  return GetDiaryUseCase(repository);
});
final addDiaryUseCaseProvider = Provider<AddDiaryUseCase>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  final imageRepository = ref.watch(imageStorageRepositoryProvider);
  return AddDiaryUseCase(repository, imageRepository);
});
final updateDiaryUseCaseProvider = Provider<UpdateDiaryUseCase>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  final imageRepository = ref.watch(imageStorageRepositoryProvider);
  return UpdateDiaryUseCase(repository, imageRepository);
});
final deleteDiaryUseCaseProvider = Provider<DeleteDiaryUseCase>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  final imageRepository = ref.watch(imageStorageRepositoryProvider);
  return DeleteDiaryUseCase(repository, imageRepository);
});

//diary 프로바이더
final diaryNotifierProvider =
    AsyncNotifierProvider<DiaryNotifier, List<DiaryModel>>(() {
  return DiaryNotifier();
});
