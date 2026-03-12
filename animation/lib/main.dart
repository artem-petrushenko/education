import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HeroList(),
            Staggered(),
            NavigationList(),
            FadeList(),
            MyCustomAnimation(),
          ],
        ),
      ),
    );
  }
}

class HeroList extends StatelessWidget {
  const HeroList({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HeroDetails()),
        );
      },
      child: Hero(
        tag: 'imageHero',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: const FlutterLogo(
            size: 50,
          ),
        ),
      ),
    );
  }
}

class HeroDetails extends StatelessWidget {
  const HeroDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero'),
      ),
      body: Center(
        child: Hero(
          tag: 'imageHero',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const FlutterLogo(
              size: 300,
            ),
          ),
        ),
      ),
    );
  }
}

class Staggered extends StatefulWidget {
  const Staggered({super.key});

  @override
  State<Staggered> createState() => _StaggeredState();
}

class _StaggeredState extends State<Staggered> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _widthAnimation = Tween<double>(begin: 50, end: 100).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _heightAnimation = Tween<double>(begin: 100, end: 50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.3,
          0.8,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.6,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.isCompleted) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Container(
              width: _widthAnimation.value,
              height: _heightAnimation.value,
              color: _colorAnimation.value,
            ),
          );
        },
      ),
    );
  }
}

class NavigationList extends StatelessWidget {
  const NavigationList({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Navigate'),
      onPressed: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (context, animation, secondaryAnimation) => const NavigationDetails(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.bounceIn));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}

class NavigationDetails extends StatelessWidget {
  const NavigationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Back'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class FadeList extends StatefulWidget {
  const FadeList({super.key});

  @override
  State<FadeList> createState() => _FadeListState();
}

class _FadeListState extends State<FadeList> with TickerProviderStateMixin {

  bool isVisible = true;



  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: const Text('Fade Animation'),
    );
  }
}

class MyCustomAnimation extends StatefulWidget {
  const MyCustomAnimation({super.key});

  @override
  State<MyCustomAnimation> createState() => _MyCustomAnimationState();
}

class _MyCustomAnimationState extends State<MyCustomAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
      ),
    );
  }
}
