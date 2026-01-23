module dsm_dac #(
  parameter integer DATA_WIDTH   = 4,
  parameter integer ACC_WIDTH    = DATA_WIDTH + 3,
  parameter integer FEEDBACK_MAG = 1 << (DATA_WIDTH - 1)
) (
  input  wire i_clk,
  input  wire i_rst_n,
  input  wire i_en,
  input  wire signed [DATA_WIDTH-1:0] i_data,
  output wire o_dac_bitstream
);

  localparam integer DELTA_WIDTH = DATA_WIDTH + 1;
  localparam integer EFFECTIVE_ACC_WIDTH = DELTA_WIDTH + 2;

  localparam integer COMPUTED_ACC_WIDTH = ACC_WIDTH < EFFECTIVE_ACC_WIDTH ? EFFECTIVE_ACC_WIDTH : ACC_WIDTH;

  wire signed [DELTA_WIDTH-1:0]        w_delta_out;
  wire signed [COMPUTED_ACC_WIDTH-1:0] w_integrator_out;
  wire w_quantizer_out;

  delta_feedback #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDITIONAL_DELTA_WIDTH(DELTA_WIDTH - DATA_WIDTH),
    .FEEDBACK_MAG(FEEDBACK_MAG)
  ) u_delta_feedback (
    .i_data(i_data),
    .i_quantized_bit(w_quantizer_out),
    .o_delta(w_delta_out)
  );

  integrator #(
    .IN_WIDTH(DELTA_WIDTH), 
    .ACC_WIDTH(COMPUTED_ACC_WIDTH)
  ) u_integrator (
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_en(i_en),
    .i_data(w_delta_out),
    .o_data(w_integrator_out)
  );

  quantizer #(
    .DATA_WIDTH(COMPUTED_ACC_WIDTH)
  ) u_quantizer (
    .i_data(w_integrator_out),
    .o_data(w_quantizer_out)
  );

  assign o_dac_bitstream = w_quantizer_out;

endmodule