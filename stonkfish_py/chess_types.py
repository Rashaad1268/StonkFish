from enum import IntEnum, Enum, auto


# WARNING: This is a HUGE enum
class Squares(IntEnum):
    a8 = 0  # DON'T CHANGE THIS TO auto()
    # or else the auto numbering will start from 1 AND WILL CAUSE MAJOR ISSUES
    b8 = auto()
    c8 = auto()
    d8 = auto()
    e8 = auto()
    f8 = auto()
    g8 = auto()
    h8 = auto()
    a7 = auto()
    b7 = auto()
    c7 = auto()
    d7 = auto()
    e7 = auto()
    f7 = auto()
    g7 = auto()
    h7 = auto()
    a6 = auto()
    b6 = auto()
    c6 = auto()
    d6 = auto()
    e6 = auto()
    f6 = auto()
    g6 = auto()
    h6 = auto()
    a5 = auto()
    b5 = auto()
    c5 = auto()
    d5 = auto()
    e5 = auto()
    f5 = auto()
    g5 = auto()
    h5 = auto()
    a4 = auto()
    b4 = auto()
    c4 = auto()
    d4 = auto()
    e4 = auto()
    f4 = auto()
    g4 = auto()
    h4 = auto()
    a3 = auto()
    b3 = auto()
    c3 = auto()
    d3 = auto()
    e3 = auto()
    f3 = auto()
    g3 = auto()
    h3 = auto()
    a2 = auto()
    b2 = auto()
    c2 = auto()
    d2 = auto()
    e2 = auto()
    f2 = auto()
    g2 = auto()
    h2 = auto()
    a1 = auto()
    b1 = auto()
    c1 = auto()
    d1 = auto()
    e1 = auto()
    f1 = auto()
    g1 = auto()
    h1 = auto()


class Color(IntEnum):
    white = 0
    black = 1


class BitBoard(int):
    def set_bit(self, square):
        return BitBoard(self | (1 << square))

    def get_bit(self, square):
        return BitBoard(self & (1 << square))

    def pop_bit(self, square):
        return BitBoard(self ^ (1 << square) if self.get_bit(square) else 0)

    def print_board(self):
        print()

        for rank in range(8):
            for file in range(8):
                square = rank * 8 + file

                if not file:
                    print(8 - rank, end='   ')

                print(1 if self.get_bit(square) else 0, end=' ')

            print()

        print('\n    a b c d e f g h\n')
        print(f'     Bitboard: {self}\n', )
