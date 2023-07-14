import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget
{
  final String? token;
  const TodoListPage({this.token});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage>
{
  bool isLoading = false;
  String timeOfDay = "Day";
  String username = "";
  List items = [];
  List visibleItems = [];

  @override
  void initState(){
    super.initState();
    if(DateFormat('a').format(DateTime.now())=="AM"){
      timeOfDay = "Morning";
    }else{
      timeOfDay = "Evening";
    }
    getUsername();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        appBar: AppBar(
          leadingWidth: 100,
          leading: Container(
            width: 100,
            height: 10,
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.tealAccent
              ),
              child: const Text("Logout"),
            ),
          ),
          title: const Text("To Do App", style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),),
        ),
        body: Visibility(
          visible: isLoading,
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: Column(
              children: [
                const SizedBox(height: 60,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text("Good $timeOfDay! $username", style: const TextStyle(color: Colors.tealAccent, fontSize: 24),)
                ),
                const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextField(
                    onChanged: (value) => runFilter(value),
                    decoration: const InputDecoration(labelText: "Search", suffixIcon: Icon(Icons.search)),
                  ),
                ),
                const SizedBox(height: 40,),
                Expanded(
                  child: ListView.builder(
                      itemCount: visibleItems.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index){
                        final id = visibleItems[index]["id"];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text("${index+1}")),
                            title: Padding(padding: const EdgeInsets.only(left: 30),child: Text(visibleItems[index]["title"])),
                            trailing: PopupMenuButton(
                              onSelected: (value){
                                if(value=="Edit"){
                                  navigateToEditPage(visibleItems[index]);
                                }
                                else if(value=="Delete"){
                                  deleteById(id.toString());
                                }
                              },
                              itemBuilder: (context){
                                return [
                                  const PopupMenuItem(value: "Edit",child: Text("Edit")),
                                  const PopupMenuItem(value: "Delete",child: Text("Delete"))
                                ];
                              },
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: navigateToAddPage,
            label: const Text("ADD"),
        )
    );
  }

  void getUsername() async {
    const url = "https://todo-api-s7vj.onrender.com/auth/profile/";
    final uri = Uri.parse(url);
    final header =
    {
      "Authorization": "Token ${widget.token}"
    };
    final response = await http.get(
        uri,
        headers: header
    );
    if(response.statusCode==200){
      Map json = jsonDecode(response.body) as Map;
      setState(() {
        username = json["name"];
      });
    }
  }

  void runFilter(String enteredKeyword){
    List results = [];
    if(enteredKeyword.isEmpty){
      results = items;
    }
    else{
      results = items.where(
          (todo) => todo["title"].toString().toLowerCase().contains(enteredKeyword.toLowerCase())
      ).toList();
    }
    setState(() {
      visibleItems = results;
    });
  }

  void navigateToAddPage()
  {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(token: widget.token));
    Navigator.push(context, route).then((value) => {fetchTodo()});
  }
  void navigateToEditPage(Map item)
  {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(token: widget.token,todo: item));
    Navigator.push(context, route).then((value) => {fetchTodo()});
  }

  Future<void> deleteById(String id) async{
    final url = "https://todo-api-s7vj.onrender.com/todo/$id/";
    final uri = Uri.parse(url);
    final header =
    {
      "Authorization": "Token ${widget.token}"
    };
    final response = await http.delete(
        uri,
        headers: header
    );
    if(response.statusCode==204){
      showSuccessMessage("Deleted to do");
      fetchTodo();
    }
    else{
      showFailureMessage("Could not delete - Error ${response.statusCode}");
    }
  }

  Future<void> fetchTodo() async{
    setState(() {
      isLoading = true;
    });
    const url = "https://todo-api-s7vj.onrender.com/todo/";
    final uri = Uri.parse(url);
    final header =
    {
      "Authorization": "Token ${widget.token}"
    };
    final response = await http.get(
      uri,
      headers: header
    );
    if(response.statusCode==200){
      final json = jsonDecode(response.body) as List;
      setState(() {
        items = json;
        visibleItems = items;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(
      content: Text(message,)
      ,backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showFailureMessage(String message){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}