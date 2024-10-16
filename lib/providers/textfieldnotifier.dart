import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldStateNotifier extends StateNotifier<String> {
  TextFieldStateNotifier() : super('');

  void updateText(String text) {
    state = text;
  }

  void clearText() {
    state = '';
  }
}

final textFieldProvider = StateNotifierProvider<TextFieldStateNotifier, String>(
  (ref) => TextFieldStateNotifier(),
);