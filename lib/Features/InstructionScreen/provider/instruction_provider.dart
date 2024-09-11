import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to manage the string state
class InstructionProvider extends StateNotifier<String> {
  InstructionProvider() : super('');

  void updateString(String newString) {
    state = newString;
  }
}

// Provider to expose the StringNotifier
final instructionProvider = StateNotifierProvider<InstructionProvider, String>((ref) => InstructionProvider());
