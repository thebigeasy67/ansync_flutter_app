import 'package:uuid/uuid.dart';

class GroceryItem {
  String _uuid = const Uuid().v1();

  String name = '';
  int amount = 0;
  bool editing = false;

  GroceryItem.e();

  GroceryItem(this.name, this.amount);

  String getUuid() {
    return _uuid;
  }

  void setUuid(String id) {
    _uuid = id;
  }

  factory GroceryItem.fromJson(Map<String, dynamic> item) {
    GroceryItem gi = GroceryItem(item['name'], int.parse(item['amount']));
    gi.editing = item['editing'] == 'true';
    gi.setUuid(item['id']);
    return gi;
  }
}
