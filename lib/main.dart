import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Compass',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const CompassScreen(),
    );
  }
}

class CompassScreen extends StatelessWidget {
  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass App'),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 4,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        color: Colors.black,
        child: const Center(
          child: CompassWidget(),
        ),
      ),
    );
  }
}

class CompassWidget extends StatefulWidget {
  const CompassWidget({super.key});

  @override
  _CompassWidgetState createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error reading heading', style: TextStyle(color: Colors.white));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.white);
        }

        double? direction = snapshot.data?.heading;
        if (direction == null) {
          return const Text("Device does not have sensors!", style: TextStyle(color: Colors.white));
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.white.withValues(alpha: 0.2), blurRadius: 10, spreadRadius: 5),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: (direction * (math.pi / 180) * -1),
                    child: Image.asset(
                      'assets/compass.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
                const Icon(Icons.navigation, size: 50, color: Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "${direction.toStringAsFixed(2)}°",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
