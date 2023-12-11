import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:engine/engine.dart' as engine;
import 'package:ui/pieces.dart';
import '../utils.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  static final board = engine.Board.fromFen(
      '6k1/2br1p1p/6p1/2B4B/p1b5/2N5/r4PPP/4R1K1 w - - 0 1');
  final stonkfishEngine = engine.Engine(board);
  List<engine.Move> legalMoves = [];
  var errorMessage = '';

  @override
  void initState() {
    super.initState();
    print(board.toFen());
  }

  @override
  Widget build(BuildContext context) {
    final boardSize = MediaQuery.of(context).size.height - 250;
    legalMoves = board.generateLegalMoves();
    // print(legalMoves);

    return Column(
      children: [
        Text(errorMessage, style: TextStyle(color: Colors.red.shade500)),
        Board(
          size: boardSize,
          settings: const BoardSettings(
            pieceAssets: maestroPieceSet,
          ),
          data: BoardData(
            fen: board.toFen(),
            interactableSide: InteractableSide.both,
            // orientation: board.turn!.isWhite ? Side.white : Side.black,
            orientation: Side.white,
            isCheck: board.isCheck,
            sideToMove: board.turn.isWhite ? Side.white : Side.black,
            validMoves: getMoves(legalMoves),
          ),
          onMove: (move, {isDrop, isPremove}) {
            try {
              setState(() {
                final moveToMake = legalMoves.firstWhere((m) =>
                    engine.squareToAlgebraic(m.from) == move.from &&
                    engine.squareToAlgebraic(m.to) == move.to &&
                    getPromotedPiece(role: move.promotion, side: board.turn) ==
                        m.promotedPiece);
                board.makeMove(moveToMake);
              });

              stonkfishEngine.searchPosition(4);
              if (stonkfishEngine.bestMove != null) {
                board.makeMove(stonkfishEngine.bestMove!);
              }
            } catch (error) {
              if (error is ArgumentError) {
                setState(() {
                  errorMessage = error.message;
                });
              }
            }
          },
        ),
      ],
    );
  }
}

IMap<String, ISet<String>> getMoves(List<engine.Move> moves) {
  // Convert the moves returned by the engine into a IMap so it can be passed into chessground
  final newMoves = <String, ISet<String>>{};

  for (final move in moves) {
    final from = engine.squareToAlgebraic(move.from);
    final to = engine.squareToAlgebraic(move.to);

    if (newMoves[from] == null) {
      newMoves[from] = ISet([to]);
    } else {
      newMoves[from] = ISet([...newMoves[from]!, to]);
    }
  }

  return IMap.fromEntries(newMoves.entries);
}
