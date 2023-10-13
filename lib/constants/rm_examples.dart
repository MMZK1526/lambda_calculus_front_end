enum RMExamples {
  constant,
  adder,
  multiplier,
  collatz,
  cycle,
  urm,
}

extension RMExamplesExtension on RMExamples {
  static List<RMExamples> allExamples() => [
        RMExamples.constant,
        RMExamples.adder,
        RMExamples.multiplier,
        RMExamples.collatz,
        RMExamples.cycle,
        RMExamples.urm,
      ];

  String get text {
    switch (this) {
      case RMExamples.constant:
        return 'Const';
      case RMExamples.adder:
        return 'Adder';
      case RMExamples.multiplier:
        return 'Multiplier';
      case RMExamples.collatz:
        return 'Collatz';
      case RMExamples.cycle:
        return 'Cycle';
      case RMExamples.urm:
        return 'Universal Register Machine';
      default:
        return 'Unknown';
    }
  }

  String get rm {
    switch (this) {
      case RMExamples.constant:
        return '''
# Copy the value from R1 into R0
R1- 1 2
R0+ 0
HALT''';
      case RMExamples.adder:
        return '''
# Computes R1 + R2 and stores the result in R0
R1- 1 2
R0+ 0
R2- 3 4
R0 2 # The '+' and '-' are optional
HALT # can also be H or ARRÊT''';
      case RMExamples.multiplier:
        return '''
# Computes R1 * R2 and stores the result in R0
1- 1 6
2- 2 4
3+ 3
0+ 1
3- 5 0
2+ 4
H''';
      case RMExamples.collatz:
        return '''
# Compute the length of the Collatz sequence starting from the value in R1
checkIs0: R1- checkIs1 end
checkIs1: R1- addBack1 reach1
addBack1: R1+ addBack2
addBack2: R1+ mod0
mod0:     R1- mod1     R2ToR1
mod1:     R1- div2     odd
div2:     R2+ mod0
R2ToR1:   R2- R1FromR2 countInc
R1FromR2: R1+ R2ToR1
countInc: R0+ checkIs0
odd:      R1+ clearR2
clearR2:  R2- R1Reset1 R1To3R2
R1Reset1: R1+ R1Reset2
R1Reset2: R1+ clearR2
R1To3R2:  R1- times3_1 R1Plus1
times3_1: R2+ times3_2
times3_2: R2+ times3_3
times3_3: R2+ R1To3R2
R1Plus1:  R1+ dumpR2
dumpR2:   R2- fillR1   countInc
fillR1:   R1+ dumpR2
reach1:   R0+ end
end:      H''';
      case RMExamples.cycle:
        return '''
L0: R1- L1 L3 # If R1 != 0, infinite cycle
L1: R0+ L2
L2: R1+ L0
L3: ARRÊT''';
      case RMExamples.urm:
        return '''
# The Universal Register Machine
R0R2i1: R9+ R0R2i2
R0R2i2: R2- R0R2i3 R0R2i4
R0R2i3: R9+ R0R2i1
R0R2i4: R9- R0R2i5 R0R2i6
R0R2i5: R2+ R0R2i4
R0R2i6: R0- R0R2i2 R1R8c1

R1R8c1: R8- R1R8c1 R1R8c2
R1R8c2: R1- R1R8c3 R1R8c5
R1R8c3: R8+ R1R8c4
R1R8c4: R9+ R1R8c2
R1R8c5: R9- R1R8c6 R8R4o1
R1R8c6: R1+ R1R8c5

R8R4o1: R4- R8R4o1 R8R4o2
R8R4o2: R8- R8R4o3 R2R0o1
R8R4o3: R8+ R8R4o4
R8R4o4: R8- R8R4o5 R8R4o6
R8R4o5: R9+ R8R4o4
R8R4o6: R9- R8R4o7 R8R4o9
R8R4o7: R9- R8R4o8 R3MMMM
R8R4o8: R8+ R8R4o6
R8R4o9: R4+ R8R4o4

R2R0o1: R0- R2R0o1 R2R0o2
R2R0o2: R2- R2R0o3 END
R2R0o3: R2+ R2R0o4
R2R0o4: R2- R2R0o5 R2R0o6
R2R0o5: R9+ R2R0o4
R2R0o6: R9- R2R0o7 R2R0o9
R2R0o7: R9- R2R0o8 END
R2R0o8: R2+ R2R0o6
R2R0o9: R0+ R2R0o4

R3MMMM: R3- R8R4o1 R4R5o1

R4R5o1: R5- R4R5o1 R4R5o2
R4R5o2: R4- R4R5o3 R2R0o1
R4R5o3: R4+ R4R5o4
R4R5o4: R4- R4R5o5 R4R5o6
R4R5o5: R9+ R4R5o4
R4R5o6: R9- R4R5o7 R4R5o9
R4R5o7: R9- R4R5o8 R2R6o1
R4R5o8: R4+ R4R5o6
R4R5o9: R5+ R4R5o4

R2R6o1: R6- R2R6o1 R2R6o2
R2R6o2: R2- R2R6o3 R5MMM1
R2R6o3: R2+ R2R6o4
R2R6o4: R2- R2R6o5 R2R6o6
R2R6o5: R9+ R2R6o4
R2R6o6: R9- R2R6o7 R2R6o9
R2R6o7: R9- R2R6o8 R5MMM1
R2R6o8: R2+ R2R6o6
R2R6o9: R6+ R2R6o4

R5MMM1: R5- R5MMM2 R6PPPP

R5MMM2: R5- R6R7i1 R4PPPP

R6R7i1: R9+ R6R7i2
R6R7i2: R7- R6R7i3 R6R7i4
R6R7i3: R9+ R6R7i1
R6R7i4: R9- R6R7i5 R6R7i6
R6R7i5: R7+ R6R7i4
R6R7i6: R6- R6R7i2 R2R6o1

R6PPPP: R6+ R4R3c1

R4R3c1: R3- R4R3c1 R4R3c2
R4R3c2: R4- R4R3c3 R4R3c5
R4R3c3: R3+ R4R3c4
R4R3c4: R9+ R4R3c2
R4R3c5: R9- R4R3c6 R6R2i1
R4R3c6: R4+ R4R3c5

R4PPPP: R4+ R4R3o1

R4R3o1: R3- R4R3o1 R4R3o2
R4R3o2: R4- R4R3o3 R6MMMM
R4R3o3: R4+ R4R3o4
R4R3o4: R4- R4R3o5 R4R3o6
R4R3o5: R9+ R4R3o4
R4R3o6: R9- R4R3o7 R4R3o9
R4R3o7: R9- R4R3o8 R6MMMM
R4R3o8: R4+ R4R3o6
R4R3o9: R3+ R4R3o4

R6MMMM: R6- R6R2i1 R4R3c1

R6R2i1: R9+ R6R2i2
R6R2i2: R2- R6R2i3 R6R2i4
R6R2i3: R9+ R6R2i1
R6R2i4: R9- R6R2i5 R6R2i6
R6R2i5: R2+ R6R2i4
R6R2i6: R6- R6R2i2 R7R6o1

R7R6o1: R6- R7R6o1 R7R6o2
R7R6o2: R7- R7R6o3 R1R8c1
R7R6o3: R7+ R7R6o4
R7R6o4: R7- R7R6o5 R7R6o6
R7R6o5: R9+ R7R6o4
R7R6o6: R9- R7R6o7 R7R6o9
R7R6o7: R9- R7R6o8 R6R2i1
R7R6o8: R7+ R7R6o6
R7R6o9: R6+ R7R6o4

END: HALT''';
      default:
        return '# Unknown Register Machine!';
    }
  }
}
