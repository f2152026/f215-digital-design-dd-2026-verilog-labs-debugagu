// comp2.v
// 2-bit unsigned magnitude comparator.
// Given two 2-bit values A and B, exactly one of GT, LT, EQ should be 1
// for any input combination.
//
// This module has a bug that a *self-checking* testbench should catch on
// its own -- you should not need to inspect the code below to find it.
// Write your testbench first, let it tell you something is wrong, THEN
// come back and fix this file.

module comp2 (
  input  [1:0] A,
  input  [1:0] B,
  output       GT,
  output       LT,
  output       EQ
);

  assign EQ = (A == B);
  assign GT = (A >= B);
  assign LT = (A <  B);

endmodule
// comp2.v
// 2-bit unsigned magnitude comparator.
// FIX: GT used >= , so GT and EQ were both high whenever A == B (4 of the
// 16 combinations). Strict > is what "greater than" means.

module comp2 (
  input  [1:0] A,
  input  [1:0] B,
  output       GT,
  output       LT,
  output       EQ
);

  assign EQ = (A == B);
  assign GT = (A >  B);
  assign LT = (A <  B);

endmodule