// and_df.v
// Dataflow AND with a delay on the continuous assignment.

module and_df (
  input  a,
  input  b,
  output y
);

  assign #5 y = a & b;

endmodule