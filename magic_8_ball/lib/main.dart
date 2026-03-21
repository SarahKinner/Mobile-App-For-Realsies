//Items needed to randomly generate numbers and grab the library
import 'dart:math';
import 'package:flutter/material.dart';

//Starts up the app
void main() {
  runApp(Magic8BallApp());
}

//Main app and this part doesn't change
class Magic8BallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic 8 Ball',
      home: Magic8BallScreen(),
    );
  }
}

//This basically allows for the screen to change since the answer changes
class Magic8BallScreen extends StatefulWidget {
  @override
  _Magic8BallScreenState createState() => _Magic8BallScreenState();
}

//Where the changes happen
class _Magic8BallScreenState extends State<Magic8BallScreen>
    with SingleTickerProviderStateMixin {
  int answerIndex = 1; // Current triangle answer
  double opacity = 1.0; // For fading triangle

  //This handles the shaking animation
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for the shake
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600), // total shake time
    );

    // Tween for subtle left-right shake around center
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -20), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -20, end: 20), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 20, end: 0), weight: 1),
    ]).animate(_controller);

    // When shake finishes, reveal new answer
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          answerIndex = Random().nextInt(4) + 1; // pick new triangle
          opacity = 1.0; // fade it in
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //What happens when the button is pressed
  void revealAnswer() {
    setState(() {
      opacity = 0.0; // fade out old triangle
    });

    _controller.forward(from: 0); // start shake
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

            // Animated shake
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0), // left-right only
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 8-ball image
                  Image.asset(
                    'assets/magic_8_ball.png',
                    width: 500,
                  ),

                  // Triangle answer (fade in/out)
                  AnimatedOpacity(
                    opacity: opacity,
                    duration: Duration(milliseconds: 300),
                    child: Image.asset(
                      'assets/triangle$answerIndex.png',
                      width: 500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Reveal button
            ElevatedButton(
              onPressed: revealAnswer,
              child: Text("Reveal the answer to you"),
            ),
          ],
        ),
      ),
    );
  }
}