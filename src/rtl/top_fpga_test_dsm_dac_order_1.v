module dsm_dac;

  parameter integer DATA_WIDTH = 16;
  localparam integer FEEDBACK_MAG = 1 << (DATA_WIDTH - 1);
  localparam integer NUM_SAMPLES = 300;
  localparam integer OSR = 64;

  reg r_clk = 0;
  reg r_rst_n = 0;
  reg r_sample = 1;
  reg signed [DATA_WIDTH-1:0] r_data_in = 0;
  wire w_bit_out;

  input_fsm #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_input_fsm (
    .i_clk(r_clk),
    .i_rst_n(r_rst_n),
    .o_data(r_data_in)
  );

  dsm_dac #(
    .DATA_WIDTH(DATA_WIDTH),
    .FEEDBACK_MAG(FEEDBACK_MAG)
  ) dut (
    .i_clk(r_clk),
    .i_rst_n(r_rst_n),
    .i_en(r_sample),
    .i_data(r_data_in),
    .o_dac_bitstream(w_bit_out)
  );

endmodule