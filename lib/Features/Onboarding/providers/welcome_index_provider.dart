import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'welcome_index_provider.g.dart';
@riverpod
class Welcome_ind extends _$Welcome_ind
{
  @override
  int build()
  {
    return 0;
  }
  void changeIndex(int value)
  {
    state = value;
  }
}