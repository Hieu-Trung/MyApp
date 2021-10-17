import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hivetodoteach/model.dart';


const String todoBoxName ="todo";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(ModelAdapter());
  await Hive.openBox<Model>(todoBoxName);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
enum TodoFilter{ALL,COMPLETED, INCOMPLETED}
class _MyHomePageState extends State<MyHomePage> {

  Box<Model> todoBox;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  TodoFilter filter = TodoFilter.ALL;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoBox = Hive.box<Model>(todoBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        actions:<Widget> [
          PopupMenuButton<String>(
            onSelected: (value){
              if(value.compareTo("All") == 0){
                setState((){
                  filter = TodoFilter.ALL;
                });
              }else if(value.compareTo("Completed") == 0){
                setState((){
                  filter = TodoFilter.COMPLETED;
                });
              }else{
                setState((){
                  filter = TodoFilter.INCOMPLETED;
                });
              }
            },
            itemBuilder: (BuildContext context){
              return ["All", "Completed", "Incompleted"].map((option){
                return PopupMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          ValueListenableBuilder(
              valueListenable: todoBox.listenable(),
              builder: (context, Box<Model> todos, _){
                List<int> keys;
                if(filter == TodoFilter.ALL){
                  keys = todos.keys.cast<int>().toList();
                }else if(filter == TodoFilter.COMPLETED){
                  keys = todos.keys.cast<int>().where((key) => todos.get(key).isCompleted).toList();
                }else{
                  keys = todos.keys.cast<int>().where((key) => !todos.get(key).isCompleted).toList();
                }

                return ListView.separated(
                    itemBuilder: (_, index){
                      final int key = keys[index];
                      final Model todo = todos.get(key);
                      return ListTile(
                        title: Text(todo.title,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        ),
                        subtitle: Text(todo.detail,
                        style: TextStyle(
                          fontSize: 20
                        ),
                        ),
                        leading: Text("$key"),
                        trailing: Icon(
                          Icons.check,
                          color: todo.isCompleted ? Colors.green: Colors.red,
                        ),
                        onTap: (){
                          showDialog(
                              context: context,
                              builder:(BuildContext context){
                                return new Dialog(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text("Completed"),
                                          onPressed: (){
                                            Model mTodo = Model(
                                              title: todo.title,
                                              detail: todo.detail,
                                              isCompleted: true,
                                            );
                                            todoBox.put(key, mTodo);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, index) =>Divider(),
                    itemCount: keys.length,
                    shrinkWrap: true,
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder:(BuildContext context){
                return new Dialog(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(hintText: "Title"),
                          controller: titleController,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Detail"),
                          controller: detailController,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        FlatButton(
                          child: Text("Add"),
                          onPressed: (){
                            final String title = titleController.text;
                            final String detail = detailController.text;

                            Model todo = Model(title: title, detail: detail, isCompleted: false);

                            todoBox.add(todo);

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }
}