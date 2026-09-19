// and_beh_intra.v
// Behavioral AND with an INTRA-assignment delay.
// a & b is evaluated immediately with the current values; only the write
// of that already-computed result into y is delayed by 5 time units.

module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    y = #5 a & b;
  end

endmodule