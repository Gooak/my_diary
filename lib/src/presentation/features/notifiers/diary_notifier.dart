import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/diary_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';

class DiaryNotifier extends AsyncNotifier<List<DiaryModel>> {
  @override
  Future<List<DiaryModel>> build() async {
    final userEmail = ref.watch(userNotifierProvider).value!.email ?? '';
    if (userEmail.isNotEmpty) {
      return await ref.read(getDiaryUseCaseProvider).getDiary(userEmail);
    } else {
      return [];
    }
  }

  // 다이어리 추가
  Future<void> addDiary(
      String nowDate, String text, String email, File? image) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      await ref.read(addDiaryUseCaseProvider).addDiary(
            email,
            DiaryModel(
              date: nowDate,
              text: text,
              imageUrl: '',
              imagePath: '',
              timestamp: Timestamp.now(),
            ),
            image,
          );
      ref.invalidateSelf();
    });
  }

  // 다이어리 업데이트
  Future<void> updateDiary(
      String text, String email, DiaryModel diary, File? image) async {
    diary.text = text;
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      await ref.read(updateDiaryUseCaseProvider).updateDiary(
            email,
            diary,
            image,
          );
      ref.invalidateSelf();
    });
  }

  //다이어리 삭제
  Future<void> deleteDiary(String email, DiaryModel diary) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      await ref
          .read(deleteDiaryUseCaseProvider)
          .deleteDiary(email, diary.id!, diary.imagePath);
      ref.invalidateSelf();
    });
  }
}
