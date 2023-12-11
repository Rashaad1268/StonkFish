import 'package:chessground/chessground.dart';
import 'package:engine/chess/enums.dart';
import 'package:engine/utils.dart';
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
  static final board = engine.Board.startingPosition();
  final stonkfishEngine = engine.Engine(board);
  List<engine.Move> legalMoves = [];

  var errorMessage = '';
  var engineDepth = 3;
  var gameOver = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final boardSize = MediaQuery.of(context).size.height - 250;
    legalMoves = board.generateLegalMoves();
    // print(legalMoves);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(errorMessage, style: TextStyle(color: Colors.red.shade500)),
        Board(
          size: boardSize,
          settings: const BoardSettings(
            pieceAssets: maestroPieceSet,
          ),
          data: BoardData(
            fen: board.toFen(),
            interactableSide: !gameOver
                ? InteractableSide.white
                : InteractableSide.none,
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

              stonkfishEngine.searchPosition(engineDepth);
              if (stonkfishEngine.bestMove != null) {
                board.makeMove(stonkfishEngine.bestMove!);
              }

              if (board.isSquareAttacked(
                  getLs1bIndex(board.pieceBitBoards[PieceType.bKing]!.value),
                  engine.Side.white)) {
                gameOver = true;
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
        SizedBox(
          width: 120,
          child: TextFormField(
            decoration: InputDecoration(labelText: "Depth is $engineDepth"),
            initialValue: engineDepth.toString(),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (value) {
              final newDepth = int.tryParse(value);

              if (newDepth != null && newDepth > 0 && newDepth <= 5) {
                setState(() {
                  engineDepth = newDepth;
                });
              }
            },
          ),
        )
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
