module dsm_dac #(
  parameter integer DATA_WIDTH   = 16,
  parameter integer ACC_WIDTH    = DATA_WIDTH + 3
) (
  input  wire i_clk,
  input  wire i_rst_n,
  input  wire i_en,
  input  wire signed [DATA_WIDTH-1:0] i_data,
  output wire o_dac_bitstream
);

  localparam integer FEEDBACK_MAG = 1 << (DATA_WIDTH - 1);
  localparam integer ADDITIONAL_DELTA_WIDTH = 1;
  localparam integer DELTA_WIDTH  = DATA_WIDTH + ADDITIONAL_DELTA_WIDTH;

  // wire signed [DELTA_WIDTH:0] w_delta_out;
  wire signed [DELTA_WIDTH-1:0] w_delta_out;
  wire w_integrator_quantizer_out;

  delta_feedback #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDITIONAL_DELTA_WIDTH(ADDITIONAL_DELTA_WIDTH),
    .FEEDBACK_MAG(FEEDBACK_MAG)
  ) u_delta_feedback (
    .i_data(i_data),
    .i_quantized_bit(w_integrator_quantizer_out),
    .o_delta(w_delta_out)
  );

  integrator_quantizer #(
    .DATA_WIDTH(DELTA_WIDTH), 
    .ADDITIONAL_DELTA_WIDTH(ADDITIONAL_DELTA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
  ) u_integrator_quantizer (
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_en(i_en),
    .i_data(w_delta_out),
    .o_data(w_integrator_quantizer_out)
  );

  assign o_dac_bitstream = w_integrator_quantizer_out;

endmodule