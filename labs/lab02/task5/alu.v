// alu.v
// 1-bit-opcode ALU: op=0 -> add, op=1 -> sub. 4-bit operands.
//
// FIX 1 (sensitivity list): the list was @(a, b) -- op was missing, so
//        changing op alone (operands held fixed) never re-triggered the
//        block and result went stale. Added op explicitly, as required.
// FIX 2 (blocking vs. non-blocking): the subtract path is a three-step
//        dependent chain (b_inv -> b_twos -> result). With <=, none of the
//        new values are visible to the later statements in the same pass,
//        so each step used its input's previous value and the whole chain
//        ran one evaluation behind. Combinational chains use blocking (=).

module alu (
  input      [3:0] a,
  input      [3:0] b,
  input            op,      // 0 = add, 1 = sub
  output reg [3:0] result
);

  reg [3:0] b_inv;
  reg [3:0] b_twos;

  always @(a, b, op) begin
    case (op)
      1'b0: begin
        result = a + b;                 // add
      end
      1'b1: begin
        b_inv  = ~b;                    // sub, via two's complement
        b_twos = b_inv + 1;
        result = a + b_twos;
      end
    endcase
  end

endmodule