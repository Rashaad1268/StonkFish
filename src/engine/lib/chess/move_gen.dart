import 'package:engine/chess/board_copy.dart';
import 'package:engine/engine.dart';

extension MoveGeneration on Board {
  List<Move> generatePseudoLegalMoves({Side? side}) {
    /* 
    If `side` is specified, generate moves for that side.
    Else generate moves for the side with the current turn 
  */
    final moves = <Move>[];
    final side0 = side ?? turn;

    for (var piece
        in (side0.isWhite ? PieceType.whitePieces : PieceType.blackPieces)) {
      int sourceSquare;
      int targetSquare;

      var bitboard =
          pieceBitBoards[piece]!; // Create a new bitboard from the value

      if (piece.side.isWhite) {
        // gen white pawn moves and white castling moves here
        if (piece == PieceType.wPawn) {
          // loop over white pawns within white pawn bitboard
          while (bitboard.notEmpty()) {
            // init source square
            sourceSquare = getLs1bIndex(bitboard.value);

            // init target square
            targetSquare = sourceSquare - 8;

            // generate quite pawn moves
            // if (!(targetSquare < Squares.a8) && !get_bit(occupancies[both], targetSquare))
            if (!(targetSquare < Squares.a8) &&
                allPieces.getBit(targetSquare) != 1) {
              // pawn promotion
              if (sourceSquare >= Squares.a7 && sourceSquare <= Squares.h7) {
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.wQueen,
                    flags: 0));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.wRook,
                    flags: 0));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.wBishop,
                    flags: 0));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.wKnight,
                    flags: 0));
              } else {
                // one square ahead pawn move
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    flags: 0));

                // two squares ahead pawn move
                if ((sourceSquare >= Squares.a2 &&
                        sourceSquare <= Squares.h2) &&
                    allPieces.getBit(targetSquare - 8) != 1) {
                  moves.add(Move(
                      piece: piece,
                      from: sourceSquare,
                      to: targetSquare - 8,
                      flags: MoveFlags.doublePush));
                }
              }
            }

            // init pawn attacks bitboard
            var attacks = pawnAttacks[piece.side == Side.white ? 0 : 1]
                    [sourceSquare] &
                blackPieces;

            // generate pawn captures
            while (attacks.notEmpty()) {
              // init target square
              targetSquare = getLs1bIndex(attacks.value);

              // pawn promotion
              if (sourceSquare >= Squares.a7 && sourceSquare <= Squares.h7) {
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.wQueen,
                    flags: MoveFlags.promotionCapture));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.wRook,
                    flags: MoveFlags.promotionCapture));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.wBishop,
                    flags: MoveFlags.promotionCapture));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.wKnight,
                    flags: MoveFlags.promotionCapture));
              } else {
                // one square ahead pawn move
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    flags: MoveFlags.capture));
              }

              // pop ls1b of the pawn attacks
              attacks = attacks.popBit(targetSquare);
            }

            // generate enpassant captures
            if (enPassant != null) {
              // lookup pawn attacks and bitwise AND with enpassant square (bit)
              final enpassantAttacks =
                  pawnAttacks[piece.side.isWhite ? 0 : 1][sourceSquare].value &
                      (1 << enPassant!);

              // make sure enpassant capture available
              if (enpassantAttacks != 0) {
                // init enpassant capture target square
                int targetEnpassant = getLs1bIndex(enpassantAttacks);
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetEnpassant,
                    flags: MoveFlags.enPassant));
                // print(
                // "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetEnpassant)} pawn enpassant capture");
              }
            }

            // pop ls1b from piece bitboard copy
            bitboard = bitboard.popBit(sourceSquare);
          }
        } else if (piece == PieceType.wKing) {
          /*
          This generates the moves based on the Board.castlingRights attribute
          it does not validate if the position of the king or if the king moved
        */
          // king side castling is available
          if ((castlingRights & CastlingRights.wKingSide) != 0) {
            // make sure square between king and king's rook are empty
            // if (!get_bit(occupancies[both], f1) && !get_bit(occupancies[both], g1))
            if (allPieces.getBit(Squares.f1) != 1 &&
                allPieces.getBit(Squares.g1) != 1) {
              // make sure king and the f1 squares are not under attacks
              if (!isSquareAttacked(Squares.e1, Side.black) &&
                  !isSquareAttacked(Squares.f1, Side.black)) {
                moves.add(Move(
                    piece: piece,
                    from: Squares.e1,
                    to: Squares.g1,
                    flags: MoveFlags.kingSideCastle));
                // print("e1g1  castling move\n");
              }
            }
          }

          // queen side castling is available
          if ((castlingRights & CastlingRights.wQueenSide) != 0) {
            // make sure square between king and queen's rook are empty
            // if (!get_bit(occupancies[both], d1) && !get_bit(occupancies[both], c1) && !get_bit(occupancies[both], b1))
            if (allPieces.getBit(Squares.d1) != 1 &&
                allPieces.getBit(Squares.c1) != 1 &&
                allPieces.getBit(Squares.b1) != 1) {
              // make sure king and the d1 squares are not under attacks
              if (!isSquareAttacked(Squares.e1, Side.black) &&
                  !isSquareAttacked(Squares.d1, Side.black)) {
                moves.add(Move(
                    piece: piece,
                    from: Squares.e1,
                    to: Squares.c1,
                    flags: MoveFlags.queenSideCastle));
                // print("e1c1  castling move\n");
              }
            }
          }
        }

        // loop over source squares of piece bitboard copy
      } else {
        // pick up black pawn bitboards index
        if (piece == PieceType.bPawn) {
          // loop over white pawns within white pawn bitboard
          while (bitboard.notEmpty()) {
            // init source square
            sourceSquare = getLs1bIndex(bitboard.value);

            // init target square
            targetSquare = sourceSquare + 8;

            // generate quite pawn moves
            // if (!(targetSquare > Squares.h1) && !get_bit(occupancies[both], targetSquare))
            if (!(targetSquare > Squares.h1) && !allPieces.has(targetSquare)) {
              // pawn promotion
              if (sourceSquare >= Squares.a2 && sourceSquare <= Squares.h2) {
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.bQueen,
                    flags: 0));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.bRook,
                    flags: 0));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.bBishop,
                    flags: 0));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.bKnight,
                    flags: 0));
                // print(
                // "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} q pawn promotion\n");
                // print(
                // "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} r pawn promotion\n");
                // print(
                // "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} b pawn promotion\n");
                // print(
                // "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} n pawn promotion\n");
              } else {
                // one square ahead pawn move
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    flags: 0));
                // print(
                // "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn push\n");

                // two squares ahead pawn move
                if ((sourceSquare >= Squares.a7 &&
                        sourceSquare <= Squares.h7) &&
                    !allPieces.has(targetSquare + 8)) {
                  moves.add(Move(
                      piece: piece,
                      from: sourceSquare,
                      to: targetSquare + 8,
                      flags: MoveFlags.doublePush));
                  // print(
                  // "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare + 8)} double pawn push\n");
                }
              }
            }

            // init pawn attacks bitboard
            var attacks = pawnAttacks[piece.side == Side.white ? 0 : 1]
                    [sourceSquare] &
                whitePieces;

            // generate pawn captures
            while (attacks.notEmpty()) {
              // init target square
              targetSquare = getLs1bIndex(attacks.value);

              // pawn promotion
              if (sourceSquare >= Squares.a2 && sourceSquare <= Squares.h2) {
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.bQueen,
                    flags: MoveFlags.promotionCapture));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.bRook,
                    flags: MoveFlags.promotionCapture));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.bBishop,
                    flags: MoveFlags.promotionCapture));
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetSquare,
                    promotedPiece: PieceType.bKnight,
                    flags: MoveFlags.promotionCapture));
              } else {
                // one square ahead pawn move
                moves.add(Move(
                    from: sourceSquare,
                    to: targetSquare,
                    piece: piece,
                    flags: MoveFlags.capture));
              }

              // pop ls1b of the pawn attacks
              attacks = attacks.popBit(targetSquare);
            }

            // generate enpassant captures
            if (enPassant != null) {
              // lookup pawn attacks and bitwise AND with enpassant square (bit)
              final enpassantAttacks =
                  pawnAttacks[piece.side == Side.white ? 0 : 1][sourceSquare] &
                      BitBoard(1 << enPassant!);

              // make sure enpassant capture available
              if (enpassantAttacks.notEmpty()) {
                // init enpassant capture target square
                int targetEnpassant = getLs1bIndex(enpassantAttacks.value);
                moves.add(Move(
                    piece: piece,
                    from: sourceSquare,
                    to: targetEnpassant,
                    flags: MoveFlags.enPassant));
                // print(
                // "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetEnpassant)} pawn enpassant capture\n");
              }
            }

            // pop ls1b from piece bitboard copy
            bitboard = bitboard.popBit(sourceSquare);
          }
        }

        // castling moves
        if (piece == PieceType.bKing) {
          // king side castling is available
          if ((castlingRights & CastlingRights.bKingSide) != 0) {
            // make sure square between king and king's rook are empty
            // if (!get_bit(occupancies[both], f8) && !get_bit(occupancies[both], g8))
            if (!allPieces.has(Squares.f8) && !allPieces.has(Squares.g8)) {
              // make sure king and the f8 squares are not under attacks
              if (!isSquareAttacked(Squares.e8, Side.white) &&
                  !isSquareAttacked(Squares.f8, Side.white)) {
                moves.add(Move(
                    piece: piece,
                    from: Squares.e8,
                    to: Squares.g8,
                    flags: MoveFlags.kingSideCastle));
                // print("e8g8  castling move\n");
              }
            }
          }

          // queen side castling is available
          if ((castlingRights & CastlingRights.bQueenSide) != 0) {
            // make sure square between king and queen's rook are empty
            // if (!get_bit(occupancies[both], d8) && !get_bit(occupancies[both], c8) && !get_bit(occupancies[both], b8))
            if (!allPieces.has(Squares.d8) &&
                !allPieces.has(Squares.c8) &&
                !allPieces.has(Squares.b8)) {
              // make sure king and the d8 squares are not under attacks
              if (!isSquareAttacked(Squares.e8, Side.white) &&
                  !isSquareAttacked(Squares.d8, Side.white)) {
                moves.add(Move(
                    piece: piece,
                    from: Squares.e8,
                    to: Squares.c8,
                    flags: MoveFlags.queenSideCastle));
                // print("e8c8  castling move: \n");
              }
            }
          }
        }
      }

      // gen moves of rest of the pieces
      if (piece.isKnight) {
        // loop over source squares of piece bitboard copy
        while (bitboard.notEmpty()) {
          // init source square
          sourceSquare = getLs1bIndex(bitboard.value);

          // init piece attacks in order to get set of target squares
          var attacks = knightAttacks[sourceSquare] & ~piecesOf(piece.side);

          // loop over target squares available from generated attacks
          while (attacks.notEmpty()) {
            // init target square
            targetSquare = getLs1bIndex(attacks.value);

            // quite move
            // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
            if (!piecesOf(piece.side.opposite()).has(targetSquare)) {
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: 0));
              // print(
              // "(N) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} Piece quiet move\n");
            } else {
              // capture move
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: MoveFlags.capture));
              // print(
              // "(N) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}  piece capture\n");
            }

            // pop ls1b in current attacks set
            attacks = attacks.popBit(targetSquare);
          }

          // pop ls1b of the current piece bitboard copy
          bitboard = bitboard.popBit(sourceSquare);
        }
      } else if (piece.isBishop) {
        // loop over source squares of piece bitboard copy
        while (bitboard.notEmpty()) {
          // init source square
          sourceSquare = getLs1bIndex(bitboard.value);

          // init piece attacks in order to get set of target squares
          var attacks =
              getBishopAttacks(sourceSquare, allPieces) & ~piecesOf(piece.side);

          // loop over target squares available from generated attacks
          while (attacks.notEmpty()) {
            // init target square
            targetSquare = getLs1bIndex(attacks.value);

            // quite move
            // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
            if (!piecesOf(piece.side.opposite()).has(targetSquare)) {
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: 0));
              // print(
              // "(B) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}  piece quiet move\n",
              // );
            } else {
              // capture move
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: MoveFlags.capture));
              // print(
              // "(B) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}  piece capture\n",
              // );
            }

            // pop ls1b in current attacks set
            attacks = attacks.popBit(targetSquare);
          }

          // pop ls1b of the current piece bitboard copy
          bitboard = bitboard.popBit(sourceSquare);
        }
      } else if (piece.isRook) {
        // loop over source squares of piece bitboard copy
        while (bitboard.notEmpty()) {
          // init source square
          sourceSquare = getLs1bIndex(bitboard.value);

          // init piece attacks in order to get set of target squares
          var attacks =
              getRookAttacks(sourceSquare, allPieces) & ~piecesOf(piece.side);

          // loop over target squares available from generated attacks
          while (attacks.notEmpty()) {
            // init target square
            targetSquare = getLs1bIndex(attacks.value);

            // quite move
            // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
            if (!piecesOf(piece.side.opposite()).has(targetSquare)) {
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: 0));
              // print(
              // "(R) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece quiet move\n");
            } else {
              // capture move
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: MoveFlags.capture));
              // print(
              // "(R) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece capture\n");
            }

            // pop ls1b in current attacks set
            attacks = attacks.popBit(targetSquare);
          }

          // pop ls1b of the current piece bitboard copy
          bitboard = bitboard.popBit(sourceSquare);
        }
      } else if (piece.isQueen) {
        // loop over source squares of piece bitboard copy
        while (bitboard.notEmpty()) {
          // init source square
          sourceSquare = getLs1bIndex(bitboard.value);

          // init piece attacks in order to get set of target squares
          var attacks =
              getQueenAttacks(sourceSquare, allPieces) & ~piecesOf(piece.side);

          // loop over target squares available from generated attacks
          while (attacks.notEmpty()) {
            // init target square
            targetSquare = getLs1bIndex(attacks.value);

            // quite move
            // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
            if (!piecesOf(piece.side.opposite()).has(targetSquare)) {
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: 0));
              // print(
              // "(Q) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece quiet move\n");
            } else {
              // capture move
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: MoveFlags.capture));
              // print(
              // "(Q) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece capture\n");
            }

            // pop ls1b in current attacks set
            attacks = attacks.popBit(targetSquare);
          }

          // pop ls1b of the current piece bitboard copy
          bitboard = bitboard.popBit(sourceSquare);
        }
      } else if (piece.isKing) {
        // loop over source squares of piece bitboard copy
        while (bitboard.notEmpty()) {
          // init source square
          sourceSquare = getLs1bIndex(bitboard.value);

          // init piece attacks in order to get set of target squares
          var attacks = kingAttacks[sourceSquare] & ~piecesOf(piece.side);

          // loop over target squares available from generated attacks
          while (attacks.notEmpty()) {
            // init target square
            targetSquare = getLs1bIndex(attacks.value);

            // quite move
            // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
            if (!piecesOf(piece.side.opposite()).has(targetSquare)) {
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: 0));
              // print(
              // "(K) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece quiet move\n");
            } else {
              // capture move
              moves.add(Move(
                  piece: piece,
                  from: sourceSquare,
                  to: targetSquare,
                  flags: MoveFlags.capture));
              // print(
              // "(K) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece capture\n");
            }

            // pop ls1b in current attacks set
            attacks = attacks.popBit(targetSquare);
          }

          // pop ls1b of the current piece bitboard copy
          bitboard = bitboard.popBit(sourceSquare);
        }
      }
    }
    return moves;
  }

  List<Move> generateLegalMoves({List<Move>? pseudoLegalMoves}) {
    // Optionally let the user specify a pseudoLegalMoves cache to generate legal moves from
    List<Move> moves = [];

    final copyOfBoard = toCopy();
    final currentTurn = copyOfBoard.turn;

    // print((pseudoLegalMoves ?? generatePseudoLegalMoves()));
    // print((pseudoLegalMoves ?? generatePseudoLegalMoves()).length);
    // return moves;
    for (final move in (pseudoLegalMoves ?? generatePseudoLegalMoves())) {
      makeMove(move, validate: false);

      if (!(currentTurn.isWhite ? whiteIsChecked : blackIsChecked)) {
        moves.add(move);
      }

      revertTo(copyOfBoard);
    }

    return moves;
  }
}
