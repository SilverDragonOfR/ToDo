import 'package:first_project/screens/login_page.dart';
import 'package:first_project/screens/signup_page.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget
{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    void navigateToLogin(){
      final route = MaterialPageRoute(builder: (context) => LoginPage());
      Navigator.push(context, route);
    }
    void navigateToSignup(){
      final route = MaterialPageRoute(builder: (context) => SignupPage());
      Navigator.push(context, route);
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage("assets/images/center.png")),
            Text("Lets get started...", textAlign: TextAlign.center, style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.w200, fontSize: 30),),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: (){
                          navigateToLogin();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          foregroundColor: Colors.tealAccent,
                          side: BorderSide(color: Colors.tealAccent)
                        ),
                        child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("LOG IN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),))
                    ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: ElevatedButton(
                      onPressed: (){
                        navigateToSignup();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.tealAccent
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("SIGN UP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),))
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}