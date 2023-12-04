import "dart:math";
import 'package:touchable/touchable.dart';
import "dart:io";
import "logic.dart";
import "dart:core";
import "dart:ui";
import "package:flutter/material.dart";
// import "package:just_audio/just_audio.dart";

// late var audio_player;
// late var duration;

// void set_up_audio() async {
//   audio_player = AudioPlayer();
//   duration = await audio_player.setUrl(
//     "asset:///audio/breaking.m4a"
//   );
// }

class GameState {
  static const WIDTH = 20, HEIGHT = 10;
  int score = 0, marked_tiles = 0;
  List<int> board = List<int>.filled(WIDTH * HEIGHT, 0);
  List<Offset> delta_table = List<Offset>.filled(WIDTH * HEIGHT, Offset(0, 0));

  Offset GetDeltaAt(int x, int y) {
    return Offset(x.toDouble(), y.toDouble());
  }

  GameState() {
    // set_up_audio();
    Reset();
  } 

  int GetWidth() => WIDTH;

  int GetHeight() => HEIGHT;

  // Colors are 1, 2, 3, 4
  int F() => Random().nextInt(4) + 1;

  void Reset() {
    score = marked_tiles = 0;
    board = List<int>.filled(WIDTH * HEIGHT, 0);
    for (var i = 0; i < WIDTH * HEIGHT; ++i) {
      int tmp = F();
      // print("Putting ${tmp} into pos ${i}");
      board[i] = tmp;
    }
  }

  int GetScore() => score;

  // Positive: base,
  // Negative: marked,
  // Zero: Removed
  int GetTileState(int x, int y) {
    return (x < 0 || y < 0 || x > WIDTH - 1 || y > HEIGHT - 1)
        ? 0
        : board[WIDTH * y + x];
  }

  // flood-fill selection
  int Mark(int x, int y, int color) {
    if (GetTileState(x, y) <= 0 || color != GetTileState(x, y))
      return 0;
    board[WIDTH * y + x] = -color;
    return 1 +
    Mark(x - 1, y    , color) +
    Mark(x    , y - 1, color) +
    Mark(x + 1, y    , color) +
    Mark(x    , y + 1, color);
  }

  void Swap(int x1, int y1, int x2, int y2) {
    int pos1 = WIDTH * y1 + x1;
    int pos2 = WIDTH * y2 + x2;
    int temp = board[pos1];
    board[pos1] = board[pos2];
    board[pos2] = temp;
  }

  int Points() => (marked_tiles * marked_tiles - 4 * marked_tiles + 4);

  bool IsGameOver() => marked_tiles < 0;

  bool Click(int x, int y) {
    // print("marking at ${x} ${y} = ${GetTileState(x, y)} (${marked_tiles})");

    // Reset if game over
    if (IsGameOver()) Reset();

    // Check if tiles is was previous marked and also more than 1 tile is
    // currently being selected
    //
    // => Remove them
    if (GetTileState(x, y) < 0 && marked_tiles > 1) {
      // audio_player.play();

      // Removed marked tiles
      for (int i = 0; i < WIDTH * HEIGHT; ++i) {
        board[i] = board[i] < 0 ? 0 : board[i];
      }

      // Cascade tiles down to fill empty spaces
      for (x = WIDTH; x-- > 0; ) {
        for (bool c = true; c; ) {
          c = false;
          for (y = 0; ++y < HEIGHT; ) {
            if (!(GetTileState(x, y) != 0) && (GetTileState(x, y - 1) != 0)) {
              Swap(x, y, x, y - 1);
              c = true;
            }
          }
        }
      }

      // Cascade tiles left
      for (bool c = true; c; ) {
        c = false;
        for (x = 0; ++x < WIDTH;) {
          if (!(GetTileState(x - 1, HEIGHT - 1) != 0) && (GetTileState(x, HEIGHT - 1) != 0)) {
            c = true;
            for (y = HEIGHT; y-->0; ) {
              Swap(x, y, x - 1, y);
            }
          }
        }
      }

      score += Points();

      // Determine game over
      marked_tiles = -1;
      for (x = WIDTH; x-- > 0; ) {
        for (y = HEIGHT; y-- > 0; ) {
          marked_tiles = Mark(x, y, GetTileState(x, y)) > 1 ? 0 : marked_tiles;
        }
      }
    }

    // Reset
    for (int i = 0; i < WIDTH * HEIGHT; ++i)
        board[i] = board[i].abs();
    marked_tiles = marked_tiles < 0 ? marked_tiles : Mark(x, y, GetTileState(x, y));
    // print("value at ${x} ${y} = ${GetTileState(x, y)} (${marked_tiles})");
    return true;
  }
}
