from board import bit_board
from chess_types import Squares, Color


def main():
    bit_board.init()
    for i in range(64):
        bit_board.pawn_attacks[1][i].print_board()


if __name__ == '__main__':
    main()
