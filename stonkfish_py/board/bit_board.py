import numpy as np
from stonkfish_py.chess_types import Color, BitBoard
from stonkfish_py import constants


# Use object because the numbers get too large
pawn_attacks = np.array([[0]*64, [0]*64], dtype=object)


def mask_pawn_attacks(color, square):
    assert color in (Color.white, Color.black), "Invalid color!"
    bitboard = BitBoard()
    attacks = 0

    bitboard = bitboard.set_bit(square)

    if color == Color.white:
        if (bitboard >> 7) & constants.not_a_file:
            attacks |= bitboard >> 7
        if (bitboard >> 9) & constants.not_h_file:
            attacks |= bitboard >> 9
    else:
        if (bitboard << 7) & constants.not_h_file:
            attacks |= bitboard << 7
        if (bitboard << 9) & constants.not_a_file:
            attacks |= bitboard << 9

    return BitBoard(attacks)


def init_leapers_attacks():
    for square in range(64):
        pawn_attacks[Color.white][square] = mask_pawn_attacks(Color.white, square)
        pawn_attacks[Color.black][square] = mask_pawn_attacks(Color.black, square)


def init():
    init_leapers_attacks()
