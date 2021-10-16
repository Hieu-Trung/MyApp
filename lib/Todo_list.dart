import 'package:flutter/material.dart';
import 'package:myapp/Services/Database_services.dart';


class Todolist extends StatefulWidget{
  @override
  _TodolistState createState() => _TodolistState();
}
class _TodolistState extends State<Todolist>{
  bool isComplet = false;
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text("To Do",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              ),
              Divider(),
              SizedBox(height: 20.0),
              ListView.separated(
                separatorBuilder: (context,index) => Divider(color: Colors.white30,),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index){
                  return Dismissible(
                    key: Key(index.toString()),
                    background: Container(
                    padding: EdgeInsets.only(left:20),
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.delete),
                      color: Colors.red,
                  ),
                    onDismissed: (direction){
                      print("remove");
                    },
                    child: ListTile(
                    onTap: () {
                      setState(() {
                        isComplet = !isComplet;
                      });
                    },
                    leading: Container(
                      padding: EdgeInsets.all(2),
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle
                      ),
                      child: isComplet? Icon(
                        Icons.check,
                        color: Colors.white,)
                      :Container(),
                    ),
                    title: Text("title todo",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    )
                  );
                },
              ),
            ]
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return new SimpleDialog(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  title: Row(
                      children: [
                        Text("Add todo",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                          size: 30.0,
                          ),
                        onPressed: () => Navigator.pop(context),
                      )
                      ],
                  ),
                  children: [
                    Divider(),
                    TextFormField(
                      controller: todoTitleController,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                      ),
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "write todo...",
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Text("Add"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () async{
                          if (todoTitleController.text.isEmpty){
                            await DatabaseService().createNewTodo(todoTitleController.text.trim());
                            Navigator.pop(context);
                          }
                        },
                      ),
                    )
                  ],
                );
              },
          );
        }
      ),
    );
  }
}

