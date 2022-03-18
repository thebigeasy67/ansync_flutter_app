import 'package:ansync_flutter_app/Classes/grocery_item.dart';

abstract class GroceryListEvent {}

class AddToListEvent extends GroceryListEvent {
  GroceryItem item = GroceryItem.e();
  AddToListEvent(GroceryItem i) {
    item = i;
  }

  GroceryItem getItem() {
    return item;
  }
}

class RemoveFromListEvent extends GroceryListEvent {
  GroceryItem item = GroceryItem.e();
  RemoveFromListEvent(GroceryItem i) {
    item = i;
  }

  GroceryItem getItem() {
    return item;
  }
}

class EditListEvent extends GroceryListEvent {
  GroceryItem item = GroceryItem.e();
  EditListEvent(GroceryItem i) {
    item = i;
  }

  GroceryItem getItem() {
    return item;
  }
}

class SaveListEvent extends GroceryListEvent {
  GroceryItem item = GroceryItem.e();
  SaveListEvent(GroceryItem i) {
    item = i;
  }

  GroceryItem getItem() {
    return item;
  }
}
