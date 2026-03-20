import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(Magic8BallApp());
}

class Magic8BallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic 8 Ball',
      home: Magic8BallScreen(),
    );
  }
}

class Magic8BallScreen extends StatefulWidget {
  @override
  _Magic8BallScreenState createState() => _Magic8BallScreenState();
}

class _Magic8BallScreenState extends State<Magic8BallScreen> {
  int answerIndex = 1; // Current triangle image
  double opacity = 1.0; // Controls fade animation

  // Function to change the answer with animation
  void revealAnswer() async {
    // Step 1: Fade OUT
    setState(() {
      opacity = 0.0;
    });

    // Wait for fade-out animation
    await Future.delayed(Duration(milliseconds: 500));

    // Step 2: Change the answer
    setState(() {
      answerIndex = Random().nextInt(4) + 1;
    });

    // Step 3: Fade IN
    setState(() {
      opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Magic 8 Ball'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Stack lets us layer the triangle on top of the 8-ball
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/magic_8_ball.png',
                  width: 500,
                ),

                // AnimatedOpacity creates the fade effect
                AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 500),
                  child: Image.asset(
                    'assets/triangle$answerIndex.png',
                    width: 500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Your "stupid" button 😄
            ElevatedButton(
              onPressed: revealAnswer,
              child: Text("Reveal the answer to you 🔮"),
            ),
          ],
        ),
      ),
    );
  }
}