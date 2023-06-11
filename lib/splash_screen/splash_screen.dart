

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../authentication/login.dart';
import '../global/global.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget{
  static const id = 'SplashScreen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;

  startTimer() {
    Timer(
      const Duration(seconds: 5),
          () async {
        //if the user is already authenticate send user to home screen
        if (firebaseAuth.currentUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const HomeScreen(),
            ),
          );
        }
        // //if not send to auth screen
        else {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const LoginScreen()));
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);
    _coffeeController.addListener(() {
      if (_coffeeController.value > 0.7) {
        _coffeeController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 3), () {
          animateCafeText = true;
          setState(() {});
        });
      }
    });

    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF8DEDA3),
      body: Stack(
        children: [
          // White Container top half
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: copAnimated ? screenHeight / 1.9 : screenHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset(-1.0, 0.0),
                end: FractionalOffset(5.0, -1.0),
                colors: [
                  Color(0xFFFFFFFF),
                  Color.fromARGB(255, 241, 235, 229),
                ],
              ),
              borderRadius: BorderRadius.circular(copAnimated ? 40.0 : 0.0),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Visibility(
                        visible: !copAnimated,
                        child: Lottie.asset(
                          'assets/stocklottie.json',
                          controller: _coffeeController,
                          onLoaded: (composition) {
                            _coffeeController
                              ..duration = composition.duration
                              ..forward();
                          },
                        ),
                      ),
                    ),
                    // Visibility(
                    //   visible: copAnimated,
                    //   child: Image.asset(
                    //     'images/image0.png',
                    //     height: 300.0,
                    //   ),
                    // ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: animateCafeText ? 1 : 0,
                        duration: const Duration(seconds: 2),
                        // child: Text(
                        //   'Stocks'.toUpperCase(),
                        //   style: const TextStyle(
                        //     fontSize: 27,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Text bottom part
          Visibility(visible: copAnimated,
              child: const _BottomPart()),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Find The Stocks for You',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'We make it simple to find Stock',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50.0),

            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
