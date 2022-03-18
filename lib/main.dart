import 'package:ansync_flutter_app/Classes/grocery_item.dart';
import 'package:ansync_flutter_app/Classes/grocery_list_event.dart';
import 'package:ansync_flutter_app/grocery_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _list = GroceryList();
  bool submitAttempt = false;
  bool saveAttempt = false;
  bool editing = false;
  TextEditingController name = TextEditingController();
  TextEditingController nameEditing = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController amountEditing = TextEditingController();

  void clearText() {
    name.clear();
    amount.clear();
    FocusScope.of(context).unfocus();
  }

  bool isValid() {
    return !submitAttempt || (name.text.isNotEmpty && amount.text.isNotEmpty);
  }

  bool isEditingValid() {
    return !saveAttempt ||
        (nameEditing.text.isNotEmpty && amountEditing.text.isNotEmpty);
  }

  bool fieldValid(TextEditingController c) {
    return !submitAttempt || c.text.isNotEmpty;
  }

  Widget makeWidget(GroceryItem groceryItem, BuildContext context) {
    if (groceryItem.editing) {
      nameEditing.text = groceryItem.name;
      amountEditing.text = groceryItem.amount.toString();
    }

    Widget w = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: groceryItem.editing
          ? [
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: nameEditing,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Edit Item',
                      errorText: !fieldValid(nameEditing) ? '' : null,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: amountEditing,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: '#',
                        errorText: !fieldValid(amountEditing) ? '' : null,
                      ),
                    )),
              ),
              Flexible(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => setState(() {
                      saveAttempt = true;
                      if (isEditingValid()) {
                        groceryItem.editing = false;

                        groceryItem.name = nameEditing.text;
                        groceryItem.amount = int.parse(amountEditing.text);
                        _list.listEventSink.add(SaveListEvent(groceryItem));
                        saveAttempt = false;
                        FocusScope.of(context).unfocus();
                        editing = false;
                      }
                    }),
                    icon: const Icon(Icons.save),
                  ))
            ]
          : [
              Text(
                groceryItem.name + ":  ",
                style: Theme.of(context).textTheme.button,
              ),
              Text(
                groceryItem.amount.toString(),
                style: Theme.of(context).textTheme.button,
              ),
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      if (!editing) {
                        groceryItem.editing = true;
                        editing = true;
                        _list.listEventSink.add(EditListEvent(groceryItem));
                      }
                    }),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      _list.listEventSink.add(RemoveFromListEvent(groceryItem));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ],
    );

    return w;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: _list.list,
          initialData: const <GroceryItem>[],
          builder: (BuildContext context1,
              AsyncSnapshot<List<GroceryItem>> snapshot) {
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context2, int index) {
                  return Container(
                    height: 50,
                    margin: const EdgeInsets.all(2),
                    color: Colors.lightBlue[200],
                    child: Center(
                      child: makeWidget(snapshot.data![index], context1),
                    ),
                  );
                });
          }),
      bottomSheet: Row(
        children: [
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter Item',
                  errorText: !fieldValid(name) ? '' : null,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '#',
                    errorText: !fieldValid(amount) ? '' : null,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
            child: FloatingActionButton(
              onPressed: () => setState(() {
                submitAttempt = true;
                if (isValid()) {
                  _list.listEventSink.add(AddToListEvent(
                      GroceryItem(name.text, int.parse(amount.text))));
                  clearText();
                  submitAttempt = false;
                }
              }),
              tooltip: 'Add Item',
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
