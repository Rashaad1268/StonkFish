import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:engine/engine.dart' as engine;

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  final board = engine.Board.startingPosition;
  var errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final boardSize = MediaQuery.of(context).size.height - 250;

    return Column(
      children: [
        Text(errorMessage, style: TextStyle(color: Colors.red.shade500)),
        Board(
          size: boardSize,
          settings: const BoardSettings(enablePremoves: false),
          data: BoardData(
              fen: board.toFen(),
              interactableSide: InteractableSide.both,
              orientation:
                  board.turn == engine.Side.white ? Side.white : Side.black,
              sideToMove:
                  board.turn == engine.Side.white ? Side.white : Side.black,
              onMove: (move, {isDrop, isPremove}) {},
              validMoves: IMap.fromEntries({
                'd2': ISet(const ['d4'])
              }.entries)),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 200,
            child: TextField(
              decoration: const InputDecoration(hintText: "Enter your move"),
              onSubmitted: (move) {
                if (move.length != 4) {
                  setState(() {
                    errorMessage = 'Invalid move bruh';
                  });
                  return;
                }

                try {
                  setState(() {
                    board.makeMove(move);
                  });
                } catch (error) {
                  if (error is ArgumentError) {
                    setState(() {
                      errorMessage = error.message;
                    });
                    return;
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
