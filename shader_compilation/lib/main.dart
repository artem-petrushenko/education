import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.shaderWarmUp = MyShaderWarmUp();
  runApp(const ShaderTrainingApp());
}

class ShaderTrainingApp extends StatelessWidget {
  const ShaderTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: HeavyShaderScene());
  }
}

class HeavyShaderScene extends StatefulWidget {
  const HeavyShaderScene({super.key});

  @override
  State<HeavyShaderScene> createState() => _HeavyShaderSceneState();
}

class _HeavyShaderSceneState extends State<HeavyShaderScene> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildHeavyCard(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final rotation = controller.value * 3.14 * 2;

        return Transform.rotate(
          angle: rotation + index,
          child: Opacity(
            opacity: 0.8,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  colors: [Colors.purple, Colors.blue, Colors.green, Colors.orange],
                ).createShader(rect);
              },
              blendMode: BlendMode.srcATop,
              child: ClipPath(
                clipper: StarClipper(),
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 20,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.white.withOpacity(0.8), Colors.transparent],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.flutter_dash, size: 60, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: List.generate(
          20,
          (index) => Positioned(
            left: (index * 40) % MediaQuery.of(context).size.width,
            top: (index * 60) % MediaQuery.of(context).size.height,
            child: buildHeavyCard(index),
          ),
        ),
      ),
    );
  }
}

class StarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * .5, 0);
    path.lineTo(w * .61, h * .35);
    path.lineTo(w, h * .38);
    path.lineTo(w * .68, h * .62);
    path.lineTo(w * .79, h);
    path.lineTo(w * .5, h * .75);
    path.lineTo(w * .21, h);
    path.lineTo(w * .32, h * .62);
    path.lineTo(0, h * .38);
    path.lineTo(w * .39, h * .35);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyShaderWarmUp extends ShaderWarmUp {
  @override
  Future<void> warmUpOnCanvas(Canvas canvas) async {
    final paint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF000000), Color(0xFFFFFFFF)],
          ).createShader(const Rect.fromLTWH(0, 0, 100, 100));

    canvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100), paint);
  }
}
