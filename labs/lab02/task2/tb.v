// tb.v
// Self-checking testbench for the parameterized ROM, with a parameter override.

module tb;

  localparam TB_WIDTH = 8;
  localparam TB_DEPTH = 8;

  // 3 bits comfortably covers both DEPTH=4 and DEPTH=8.
  reg  [2:0]          t_sel;
  wire [TB_WIDTH-1:0] t_dout;

  integer i;
  integer errors;
  reg [TB_WIDTH-1:0] exp_dout;

  // Parameters can ONLY be configured here, with #(...) at instantiation.
  lut #(.WIDTH(TB_WIDTH), .DEPTH(TB_DEPTH)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    t_sel  = 0;
    #5;

    for (i = 0; i < TB_DEPTH; i = i + 1) begin
      t_sel = i[2:0];
      #5;
      exp_dout = i * i;         // expected value computed independently
      if (t_dout !== exp_dout) begin
        $display("FAIL at time %0t: sel=%0d  got dout=%0d  expected dout=%0d",
                 $time, t_sel, t_dout, exp_dout);
        errors = errors + 1;
      end
      else begin
        $display("PASS at time %0t: sel=%0d  dout=%0d", $time, t_sel, t_dout);
      end
    end

    #5;
    $write("Simulation complete: ");
    $write("%0d/%0d addresses passed", TB_DEPTH - errors, TB_DEPTH);
    $display(", %0d errors.", errors);
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule