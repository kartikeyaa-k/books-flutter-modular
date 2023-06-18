import 'package:flutter/material.dart';
import 'package:worldofbooks/core/theme/primary_style.dart';
import 'package:worldofbooks/features/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    /// Create an animation controller for the splash screen
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    /// Create a fade-in animation for the splash screen
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    /// Start the animation
    _animationController.forward();

    /// In this simple application
    /// We navigate user to [HomeScreen] when the animation is completed
    /// Duration for animation is set when creating the controller
    ///
    ///
    /// postFrameCallbak is not really necessary here
    /// but to take extra precautions
    /// we make sure that the build is not dirty state when navigation is called
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          navigateToNextPage();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryAppColor,
                primaryAppColor.withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(children: [
            Center(
                child: FadeTransition(
              opacity: _animation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      color: secondaryAppColor,
                      height: 50,
                      width: 50,
                    ),
                    Text('World Of Books',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: secondaryAppColor,
                                letterSpacing: -0.60)),
                  ],
                ),
              ),
              // your splash screen UI goes here
            )),
          ])),
    );
  }

  void navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          return const HomeScreen();
        },
      ),
    );
  }
}
