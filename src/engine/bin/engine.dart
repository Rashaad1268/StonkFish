import 'package:engine/engine.dart';
import 'package:engine/move_gen.dart';

void main(List<String> arguments) {
  initAttacks();

  var board = Board.empty;
  board.turn = Side.black;
  board.castlingRights = 0;
  // var board = Board.startingPosition;
  board.pieceBitBoards[PieceType.bQueen] = BitBoard(0).setBit(Squares.e5);
  board.pieceBitBoards[PieceType.wPawn] = BitBoard(0).setBit(Squares.e6);
  // board.pieceBitBoards[PieceType.bQueen]!.printBoard();
  // board.blackPieces.printBoard();
  // board.turn = Side.black;
  // board.castlingRights = 0;
  // board.pieceBitBoards[PieceType.bQueen] = BitBoard(0).setBit(Squares.d4);
  // board.pieceBitBoards[PieceType.bPawn] = BitBoard(0).setBit(Squares.e5);
  // board.enPassant = Squares.e6;
  board.printBoard();
  generateMoves(board);
  // board
  // generateMoves(board);
}
