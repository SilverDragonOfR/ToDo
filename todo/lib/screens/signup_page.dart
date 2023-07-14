import 'dart:convert';
import 'package:first_project/screens/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signup", style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40,),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_2_outlined),
                      labelText: "Name",
                      hintText: "abc",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 40,),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: "E-mail",
                      hintText: "abc@email.com",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 40,),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.verified_user_outlined),
                      labelText: "Username",
                      hintText: "iamabc",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 40,),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password_outlined),
                      labelText: "Password",
                      hintText: "********",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.remove_red_eye_sharp)
                      )
                  ),
                ),
                SizedBox(height: 80,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: (){
                        handleSignup();
                      },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Text("SIGNUP", style: TextStyle(fontSize: 16),)
                      )
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  void handleSignup() async {
    String name = nameController.text;
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    final body =
    {
      "name": name,
      "email": email,
      "username": username,
      "password": password
    };
    const url = "https://todo-api-s7vj.onrender.com/auth/register/";
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body: body
    );

    if(response.statusCode==200){
      final json = jsonDecode(response.body) as Map;
      String token = json["token"];
      navigateTodoList(token);
      showSuccessMessage("Successfully Signed Up");
    }
    else{
      showFailureMessage("Could not sign up - Error ${response.statusCode}");
    }
  }

  void navigateTodoList(String token) {
    final route = MaterialPageRoute(builder: (context) => TodoListPage(token: token));
    Navigator.pushReplacement(context, route);
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