import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';

int getSquareRank(int square) => (square >> 3);

int getSquareFile(int square) => square & 0x7;

String squareToAlgebraic(int square) {
  assert(square >= 0 && square < 64);
  return squareToCoord[square];
}

int? squareFromAlgebraic(String str) {
  if (str.length > 2) return null;

  final file = kFileNames.indexOf(str[0]);
  final rank = int.tryParse(str[1]);

  if (rank == null) return null;

  final square = (8 - rank) * 8 + file;

  if (square > 63) {
    return null;
  }

  return square;
}

int countBits(BitBoard bitboard) {
  var count = 0;
  var val = bitboard.value;

  while (val != 0) {
    val &= val - 1;
    count++;
  }
  return count;
}

int? getLs1bIndex(BitBoard bitboard) {
  assert(bitboard.value != 0);
  return countBits((bitboard & -bitboard) - BitBoard(1));
}

BitBoard setOccupancy(int index, int bitsInMask, BitBoard attackMask) {
  var occupancy = BitBoard(0);

  // loop over the range of bits within attack mask
  for (int count = 0; count < bitsInMask; count++) {
    // get LS1B index of attacks mask
    int square = getLs1bIndex(attackMask)!;

    // pop LS1B in attack map
    attackMask = attackMask.popBit(square);

    // make sure occupancy is on board
    if ((index & (1 << count)) > 0) {
      // populate occupancy map
      occupancy |= BitBoard(1 << square);
    }
  }

  // return occupancy map
  return occupancy;
}

var randomState = 1804289383;

// generate 32-bit pseudo legal numbers
int getRandomNumber()
{
    // get current state
    var number = randomState;
    
    // XOR shift algorithm
    number ^= number << 13;
    number ^= number >> 17;
    number ^= number << 5;
    
    // update random number state
    randomState = number;
    
    // return random number
    return number;
}

int get64BitRandomNum()
{
    // define 4 random numbers
    int n1, n2, n3, n4;
    
    // init random numbers slicing 16 bits from MS1B side
    n1 = getRandomNumber() & 0xFFFF;
    n2 = getRandomNumber() & 0xFFFF;
    n3 = getRandomNumber() & 0xFFFF;
    n4 = getRandomNumber() & 0xFFFF;
    
    // return random number
    return n1 | (n2 << 16) | (n3 << 32) | (n4 << 48);
}

// generate magic number candidate
int generateMagicNumber()
{
    return get64BitRandomNum() & get64BitRandomNum() & get64BitRandomNum();
}


