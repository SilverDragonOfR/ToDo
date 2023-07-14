import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  final String? token;
  const AddTodoPage({this.token, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage>
{
  bool isEdit = false;
  TextEditingController titleController = TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.todo != null){
      isEdit = true;
      titleController.text = widget.todo?["title"];
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        appBar: AppBar
          (
          title: Text(isEdit ? "Edit To do" :"Add To do"),
        ),
        body: ListView
          (
          padding: EdgeInsets.all(20),
          children:
          [
            TextField
              (
              controller: titleController,
              decoration: InputDecoration(hintText: "Title"),
            ),
            SizedBox(height: 40,),
            ElevatedButton
              (
                onPressed: isEdit ? updateData : submitData,
                child: Padding
                  (
                  padding: EdgeInsets.all(10),
                  child: Text(style: TextStyle(fontSize: 20), isEdit ? "Update" : "Submit"),
                )
            )
          ],
        )
    );
  }

  void updateData() async
  {
    final title = titleController.text;
    final body =
    {
      "title": title,
    };
    final url = "https://todo-api-s7vj.onrender.com/todo/${widget.todo?["id"]}/";
    final uri = Uri.parse(url);
    final header =
    {
      "Authorization": "Token ${widget.token}"
    };
    final response = await http.put
      (
        uri,
        headers: header,
        body: body
    );

    if(response.statusCode==200){
      showSuccessMessage("Updated To Do");
    }
    else{
      showFailureMessage("Could not update - Error ${response.statusCode}");
    }
  }

  void submitData() async
  {
    final title = titleController.text;
    final body =
    {
      "title": title,
    };
    const url = "https://todo-api-s7vj.onrender.com/todo/create/";
    final uri = Uri.parse(url);
    final header =
    {
      "Authorization": "Token ${widget.token}"
    };
    final response = await http.post
      (
        uri,
        headers: header,
        body: body
    );

    if(response.statusCode==200){
      titleController.text = "";
      showSuccessMessage("Added To Do");
    }
    else{
      showFailureMessage("Could not add - Error ${response.statusCode}");
    }
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