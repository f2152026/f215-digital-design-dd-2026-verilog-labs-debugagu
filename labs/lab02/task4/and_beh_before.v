// and_beh_before.v
// Behavioral AND, delay placed BEFORE the assignment.
// The block waits 5 time units first, THEN evaluates a & b using whatever
// a and b happen to be at that later moment.

module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    #5 y = a & b;
  end

endmodule