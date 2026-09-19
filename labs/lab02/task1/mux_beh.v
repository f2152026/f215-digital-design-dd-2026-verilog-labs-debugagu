// mux_beh.v
// 2-to-1 multiplexer, BEHAVIORAL style.
// FIX: a procedural assignment inside always @(*) can only target a
// VARIABLE, so Y must be a reg, not a wire.

module mux_beh (
  input      I0,
  input      I1,
  input      S,
  output reg Y
);

  always @(*) begin
    if (S)
      Y = I1;
    else
      Y = I0;
  end

endmodule
