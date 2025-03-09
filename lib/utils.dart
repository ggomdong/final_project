import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/view_models/settings_view_model.dart';

bool isDarkMode(WidgetRef ref) => ref.watch(settingsProvider).darkMode;

List<String> moodEmojiList = [
  "😀",
  "😍",
  "🥳",
  "😱",
  "😭",
  "🤯",
  "😡",
];

void showFirebaseErrorSnack(BuildContext context, Object? error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ?? "Something went wrong.",
      ),
    ),
  );
}
