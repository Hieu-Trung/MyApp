import 'package:cloud_firestore/cloud_firestore.dart' show CollectionReference, FirebaseFirestore, QuerySnapshot;
import 'package:myapp/Model/Todo.dart';

class DatabaseService{
  CollectionReference todosCollection = FirebaseFirestore.instance.collection("Todos");
  Future createNewTodo(String title) async {
    return await todosCollection.add({
      "title": title,
      "isComplet": false,
    });
  }
  Future completTask(uid) async{
    await todosCollection.doc(uid).update({"isComplet": true});
  }
  List<Todo>? todoFromFirestore(QuerySnapshot snapshot){
    if(null != snapshot){
      return snapshot.docs.map((e){
        return Todo(
          isComplet: (e.data()as dynamic) ['iscomplet'],
          title:  (e.data()as dynamic)["title"],
          uid: e.id,
        );
      }).toList();
    } else {
      return null;
    }
  }
  Stream<QuerySnapshot>listTodosA(){
    return todosCollection.snapshots();
  }
  }
  //Stream<List<Todo>> listTodos() {
  //  return todosCollection.snapshots().map(todoFromFirestore);
  //}
//}
