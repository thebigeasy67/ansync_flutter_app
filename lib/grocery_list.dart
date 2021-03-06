import 'dart:async';
import 'dart:convert';

import 'package:ansync_flutter_app/Classes/grocery_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Classes/grocery_list_event.dart';

class GroceryList {
  List<GroceryItem> _list = <GroceryItem>[];
  bool loaded = false;

  final _listStateController = StreamController<List<GroceryItem>>();
  StreamSink<List<GroceryItem>> get _inList => _listStateController.sink;

  Stream<List<GroceryItem>> get list => _listStateController.stream;

  final _listEventController = StreamController<GroceryListEvent>();

  Sink<GroceryListEvent> get listEventSink => _listEventController.sink;

  GroceryList() {
    init();
    _listEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(GroceryListEvent event) async {
    switch (event.runtimeType) {
      case AddToListEvent:
        _list.add((event as AddToListEvent).getItem());
        break;
      case RemoveFromListEvent:
        _list.remove((event as RemoveFromListEvent).getItem());
        break;
      case SaveListEvent:
        int index = _list.indexWhere(
            (e) => e.getUuid() == (event as SaveListEvent).getItem().getUuid());
        _list.replaceRange(
            index, index + 1, [(event as SaveListEvent).getItem()]);
        break;
      default:
        break;
    }

    print('_mapEventToState');
    _inList.add(_list);
    await save(_list);
  }

  // load saved data
  Future<bool> init() async {
    _list = await load();
    print('finished init');
    if (loaded) {
      listEventSink.add(LoadListEvent());
    }
    return true;
  }

  Future<List<GroceryItem>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String js = prefs.getString('grocery_list')!;
      loaded = true;

      var l = (json.decode(js) as List<dynamic>)
          .map<GroceryItem>((item) => GroceryItem.fromJson(item))
          .toList();

      return l;
    } on Exception catch (_, e) {
      print('error: $e');
      loaded = false;

      return <GroceryItem>[];
    }
  }

  //map in preparation for storage as json string
  static Map<String, dynamic> toMap(GroceryItem i) => {
        'id': i.getUuid(),
        'name': i.name,
        'amount': i.amount,
        'editing': i.editing,
      };

  Future save(List<GroceryItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    String js =
        json.encode(list.map<Map<String, dynamic>>((i) => toMap(i)).toList());
    print(js);

    return prefs.setString('grocery_list', js);
  }

  @override
  String toString() {
    String s = '';
    for (var element in _list) {
      s += element.toString();
    }
    return s;
  }

  void dispose() {
    dispose();
  }
}
