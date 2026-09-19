// tb.v
// Self-checking testbench for the 4-bit ALU.
// Covers: the same operand pair with op toggled (exposes the sensitivity
// -list bug), and both operations across changing operands (exposes the
// blocking/non-blocking bug in the subtract chain).

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] exp_result;
  integer    i, j, k;
  integer    errors;
  integer    total;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Apply one vector and check it against an independently computed value.
  task check;
    input [3:0] va;
    input [3:0] vb;
    input       vop;
    begin
      t_a  = va;
      t_b  = vb;
      t_op = vop;
      #5;

      // Expected result computed here, from the spec, not from the design.
      exp_result = vop ? (va - vb) : (va + vb);

      total = total + 1;

      if (t_result !== exp_result) begin
        $display("FAIL at time %0t: a=%0d b=%0d op=%b  got result=%0d  expected result=%0d",
                 $time, va, vb, vop, t_result, exp_result);
        errors = errors + 1;
      end
      else begin
        $display("PASS at time %0t: a=%0d b=%0d op=%b  result=%0d",
                 $time, va, vb, vop, t_result);
      end
    end
  endtask

  initial begin
    errors = 0;
    total  = 0;
    t_a    = 4'd0;
    t_b    = 4'd0;
    t_op   = 1'b0;
    #5;

    // --- Same operand pair, op toggled back and forth (sensitivity list) ---
    check(4'd9, 4'd5, 1'b0);
    check(4'd9, 4'd5, 1'b1);
    check(4'd9, 4'd5, 1'b0);
    check(4'd9, 4'd5, 1'b1);

    check(4'd3, 4'd7, 1'b0);
    check(4'd3, 4'd7, 1'b1);
    check(4'd3, 4'd7, 1'b0);

    // --- Subtraction with changing operands (blocking/non-blocking chain) ---
    check(4'd12, 4'd3,  1'b1);
    check(4'd4,  4'd4,  1'b1);
    check(4'd15, 4'd1,  1'b1);
    check(4'd0,  4'd1,  1'b1);   // wraps: 0 - 1 = 15 in 4 bits

    // --- Exhaustive sweep of both operations ---
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 16; j = j + 1)
        for (k = 0; k < 2; k = k + 1)
          check(i[3:0], j[3:0], k[0]);

    #5;
    $write("Simulation complete: ");
    $write("%0d/%0d vectors passed", total - errors, total);
    $display(", %0d errors.", errors);
    $finish;
  end

endmodule