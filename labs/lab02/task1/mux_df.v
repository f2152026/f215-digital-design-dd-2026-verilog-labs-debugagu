// mux_df.v
// 2-to-1 multiplexer, DATAFLOW style.
// FIX: a continuous assignment can only drive a NET, so Y must be a wire,
// not a reg. (`output reg Y` + `assign Y = ...` is illegal.)

module mux_df (
  input       I0,
  input       I1,
  input       S,
  output wire Y
);

  assign Y = S ? I1 : I0;

endmodule