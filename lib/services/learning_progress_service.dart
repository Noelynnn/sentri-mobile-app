import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LearningProgressService {
  static const String _savedLessonsKey = 'saved_lessons';
  static const String _completedLessonsKey = 'completed_lessons';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Set<String>> getSavedLessons() async {
    return _readLessonSet(_savedLessonsKey);
  }

  Future<Set<String>> getCompletedLessons() async {
    return _readLessonSet(_completedLessonsKey);
  }

  Future<bool> isLessonSaved(String title) async {
    final savedLessons = await getSavedLessons();
    return savedLessons.contains(title);
  }

  Future<bool> isLessonCompleted(String title) async {
    final completedLessons = await getCompletedLessons();

    return completedLessons.contains(title);
  }

  Future<void> toggleSavedLesson(String title) async {
    final savedLessons = await getSavedLessons();

    if (savedLessons.contains(title)) {
      savedLessons.remove(title);
    } else {
      savedLessons.add(title);
    }

    await _writeLessonSet(
      _savedLessonsKey,
      savedLessons,
    );
  }

  Future<void> markLessonCompleted(String title) async {
    final completedLessons = await getCompletedLessons();

    completedLessons.add(title);

    await _writeLessonSet(
      _completedLessonsKey,
      completedLessons,
    );
  }

  Future<void> unmarkLessonCompleted(String title) async {
    final completedLessons = await getCompletedLessons();

    completedLessons.remove(title);

    await _writeLessonSet(
      _completedLessonsKey,
      completedLessons,
    );
  }

  Future<Set<String>> _readLessonSet(String key) async {
    final storedValue = await _storage.read(key: key);

    if (storedValue == null || storedValue.isEmpty) {
      return <String>{};
    }

    try {
      final decoded = jsonDecode(storedValue);

      if (decoded is! List) {
        return <String>{};
      }

      return decoded.map((item) => item.toString()).toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> _writeLessonSet(
    String key,
    Set<String> lessons,
  ) async {
    await _storage.write(
      key: key,
      value: jsonEncode(lessons.toList()),
    );
  }
}
