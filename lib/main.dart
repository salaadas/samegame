import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:core';


// TODO
//
// Add animation for the tiles
// tiles should be moving when clicked
//
// If possible do some particle when clicked too 

import "widget.dart";
import "dart:async";
import "dart:math";
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class AnimationWidget extends StatefulWidget {
  const AnimationWidget({super.key});
  AnimationWidgetState createState() => AnimationWidgetState();
}

class AnimationWidgetState extends State<AnimationWidget> {
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("tapping"),
      child: CustomPaint(
        child: Container(
          // width: 0.0,
          // height: 0.0
        ),
        painter: MyAnimation(particles)
      )
    );
  }

  late Timer timer;
  final List<Particle> particles = List<Particle>.generate(100, (index) => Particle(500, 500));
  
  void initState() {
    super.initState();
    final duration = Duration(milliseconds: 1000 ~/ 60);
    this.timer = Timer.periodic(duration, (timer) {
        setState(() {
            particles.forEach((p) {
                p.pos += Offset(p.dx, p.dy);
            });
        });
    });
  }
}

class Particle {
  final rand = Random();
  double rr(double start, double end) {
    return rand.nextDouble() * (end - start) + start;
  }

  Particle(double x, double y) {
    this.radius = rr(10, 3);
    this.color = Colors.red;
    final tx = x; // rr(0, 400);
    final ty = y; // rr(0, 400);
    this.pos = Offset(tx, ty);
    this.dx = rr(-0.1, 0.1);
    this.dy = rr(-0.1, 0.1);
  }

  late double radius;
  late Color color;
  late Offset pos;
  late double dx;
  late double dy;
}

class MyAnimation extends CustomPainter {
  List<Particle> particles;

  MyAnimation(this.particles);

  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final radius = 100.0;
    canvas.drawCircle(
      c,
      radius,
      Paint() ..color = Colors.blue ..style = PaintingStyle.fill
    );

    this.particles.forEach((p) {
        canvas.drawCircle(
          p.pos,
          p.radius,
          Paint() ..style = PaintingStyle.fill
        );
    });
  }
}





// ============================================================






class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFF181818),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // TRY THIS: Try changing the color here to a specific color (to
      //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      //   // change color while the other colors stay the same.
      //   backgroundColor: Colors.red[800],
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: GameWidget()
        // child: Stack(
        //   children: [
        //     GameWidget()
        //   ]
        // )
      ),
    );
  }
}
