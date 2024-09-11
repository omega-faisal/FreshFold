import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'order_item_total_provider.g.dart';
@riverpod
class OrderItemTotalProvider extends _$OrderItemTotalProvider
{
  @override
  int build()
  {
    return 0;
  }
  void changeTotal(int value)
  {
    state = value;
  }
}