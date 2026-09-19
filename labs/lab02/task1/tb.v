// tb.v
// Applies all 8 combinations of I0, I1, S, 5 time units apart.

module tb;

  // DUT inputs are driven from a procedural block -> they must be variables.
  reg   t_i0, t_i1, t_s;
  // DUT output is driven by the DUT -> it must be a net.
  wire  t_y;

  integer i;
  integer errors;
  reg     exp_y;

  DUT DUT (
    .I0 (t_i0),
    .I1 (t_i1),
    .S  (t_s),
    .Y  (t_y)
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
    t_i0 = 0; t_i1 = 0; t_s = 0;

    // All 8 combinations of {t_i0, t_i1, t_s}, 5 time units apart.
    for (i = 0; i < 8; i = i + 1) begin
      #5;
      {t_i0, t_i1, t_s} = i[2:0];
      #1;                       // let the DUT settle before checking
      exp_y = t_s ? t_i1 : t_i0;
      if (t_y !== exp_y) begin
        $display("FAIL at time %0t: I0=%b I1=%b S=%b  got Y=%b expected Y=%b",
                 $time, t_i0, t_i1, t_s, t_y, exp_y);
        errors = errors + 1;
      end
      #4;                       // remainder of this 5-unit step
    end

    #5;
    $write("Simulation complete: ");
    $display("%0d/8 combinations passed, %0d errors.", 8 - errors, errors);
    $finish;
  end

  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y);

endmodule