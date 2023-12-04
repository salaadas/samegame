import "dart:math";
// import 'package:touchable/touchable.dart';
import "dart:io";
import "logic.dart";
import "dart:core";
import "dart:ui";
import "package:flutter/material.dart";

final double TILE_SIZE = 52;
final double MARKER_OFFSET = 16;

class GameWidget extends StatefulWidget {
  const GameWidget({super.key});
  State<GameWidget> createState() => GameWidgetState();
}

class GameWidgetState extends State<GameWidget> with TickerProviderStateMixin {
  final GameState state = GameState();

  late AnimationController animation_controller;

  void initState() {
    super.initState();
    animation_controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
  }

  void HandleReset() {
    state.Reset();
    setState(() {});
  }

  int DarkenColor(int c) => ((c & 0xfefefe) >> 1) | 0xff000000;
  int LightenColor(int c) => ((c & 0x7f7f7f) << 1) | 0xff000000;

  Color GetColor(int x, int y) {
    int c = state.GetTileState(x, y);
    const List<int> color_map = [0x00223225, 0xff73c936, 0xFF527570, 0xFF88719d, 0xFFffdd33];
    if (c >= 0)      return Color(color_map[c]);
    else             return Color(DarkenColor(color_map[c * -1]));
    return                  Color(0xFFFF0000);
  }

  int GetColorHex(int x, int y) {
    const List<int> color_map = [0x00223225, 0xff73c936, 0xFF527570, 0xFF88719d, 0xFFffdd33];    
    int c = state.GetTileState(x, y);
    if (c >= 0) return color_map[c];
    else        return color_map[c * -1];
  }

  void HandleTap(int x, int y) {
    if (state.Click(x, y)) {
      setState(() {});
    }
  }

  // Widget build(BuildContext context) {
  //   return AspectRatio(
  //     aspectRatio: GameState.WIDTH / GameState.HEIGHT,
  //     child:
  //     CanvasTouchDetector(
  //       builder: (context) => 
  //       CustomPaint(
  //         child: Container(),
  //         painter: MyPainter(context, this)
  //       ),
  //       gesturesToOverride: [GestureType.onTapDown],
  //     )
  //   );
  // }

  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: state.GetWidth() / state.GetHeight(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              for (int y = 0; y <= state.GetHeight(); ++y)
              Expanded(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: state.IsGameOver() ? 7 : 0, sigmaY: state.IsGameOver() ? 7 : 0),
                  child: Row(
                    children: [
                      for (int x = 0; x < state.GetWidth(); ++x)
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: LayoutBuilder(
                            builder: (BuildContext ctx, BoxConstraints cons) {
                              double hhh = cons.maxHeight;
                              return TextButton(
                                onPressed: () => HandleTap(x, y),
                                child: state.GetTileState(x, y) < 0 ?
                                Container(
                                  width: hhh * 0.4,
                                  height: hhh * 0.4,
                                  color: Color(LightenColor(GetColorHex(x, y)))
                                )
                                :
                                Container(),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                                  backgroundColor: MaterialStateProperty.all(GetColor(x, y)),
                                )
                              );
                            }
                          )
                        )
                      )
                  ])
                )
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Score: ${state.GetScore()}",
                        style: const TextStyle(
                          fontSize: 36,
                          color: const Color(0xFFfefefe)
                        )
                      )
                    ),
                    const Spacer(),

                    if (state.IsGameOver())
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Game Over",
                        style: const TextStyle(
                          fontSize: 36,
                          color: const Color(0xFFfeaaaa)
                        )
                      )
                    ),
                    if (state.IsGameOver())
                    const Spacer(),
                    
                    ElevatedButton(
                      onPressed: () => HandleReset(),
                      child: const Text(
                        "New",
                        style: const TextStyle(
                          fontSize: 36
                        )
                      )
                    )
                  ]
                )
              )
          ])
        ]
    ));
  }
}

// class MyPainter extends CustomPainter {
//   MyPainter(this.context, this.gws);

//   final GameWidgetState gws;
//   final BuildContext context;

//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }


//   void paint(Canvas c, Size size) {
//     TouchyCanvas canvas = TouchyCanvas(context, c);

//     for (int row = 0; row < GameState.HEIGHT; ++row) {
//       for (int col = 0; col < GameState.WIDTH; ++col) {
//         int cc = col;
//         int rr = row;
//         final offset = Offset(TILE_SIZE * (cc), TILE_SIZE * rr);
//         final size = Size(TILE_SIZE, TILE_SIZE);
//         Rect tile = offset & size;

//         var rect_animation = Tween<Offset>(begin: offset, end: gws.state.GetDeltaAt(col, row));


//         canvas.drawRect(
//           tile,
//           Paint() ..color = gws.GetColor(col, row),
//           onTapDown: (tap_detail) {
//             print("${col} ${row}");
//             gws.HandleTap(col, row);
//           }
//         );
//       }
//     }
//   }
// }
