import 'package:first_project/screens/welcome_page.dart';
import 'package:flutter/material.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
{
  bool animate = false;

  @override
  void initState() {
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedPositioned(
                duration: Duration(milliseconds: 1600),
                top: animate ? 10 : -120,
                left: animate ? 10 : -120,
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 1600),
                    opacity: animate ? 1 : 0,
                    child: Image(image: AssetImage("assets/images/hero.png")))
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: 1600),
                top: 200,
                left: animate ? 100 : -230,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 1600),
                  opacity: animate ? 1 : 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("To Do!", style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold ,color: Colors.cyan),),
                      Text("  Short notes making App", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200))
                    ],
                  ),
                )
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: 1600),
                bottom: animate ? 100 : -200,
                left : 100,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 1600),
                  opacity: animate ? 1 : 0,
                  child: Container(
                      child: Image(image: AssetImage("assets/images/lower.png"))
                  ),
                )
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: 1600),
                bottom: 60,
                right: animate ? 120 : -60,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 1600),
                  opacity: animate ? 1 : 0,
                  child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.cyan
                      ),
                  ),
                )
            ),
          ],
        ),
      )
    );
  }

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      animate = true;
    });
    await Future.delayed(Duration(milliseconds: 3500));
    final route = MaterialPageRoute(builder: (context) => WelcomeScreen());
    Navigator.pushReplacement(context, route);
  }
}
