import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_radio_notifier.g.dart';

@riverpod
class OrderRadioNotifier extends _$OrderRadioNotifier{
  @override
  bool build() {
    return true;
  }

  void changeBool(bool value)
  {
    state=value;
  }
}
