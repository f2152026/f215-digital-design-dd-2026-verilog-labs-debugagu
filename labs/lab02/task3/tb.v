// tb.v
// Self-checking testbench for comp2: sweeps all 16 input combinations,
// computes the expected outputs independently, and counts mismatches.

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  reg        exp_gt, exp_lt, exp_eq;
  integer    i, j;
  integer    errors;
  integer    total;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    total  = 0;
    t_a    = 2'b00;
    t_b    = 2'b00;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #5;

        // Expected values, derived from the specification -- NOT copied
        // from the design, so a bug in the design cannot hide here.
        exp_gt = (i >  j);
        exp_lt = (i <  j);
        exp_eq = (i == j);

        total = total + 1;

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
        else begin
          $display("PASS at time %0t: A=%b B=%b  GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq);
        end
      end
    end

    #5;
    $write("Simulation complete: ");
    $write("%0d/%0d combinations passed", total - errors, total);
    $display(", %0d errors.", errors);
    $finish;
  end

endmodule
