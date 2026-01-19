module top_dsm_dac_older_1 #(
  parameter integer DATA_WIDTH = 4
) (
  input i_clk,
  input i_rst_n,
  input i_sample,
  input [DATA_WIDTH-1:0] i_data,
  output o_dac_out
);

  wire [DATA_WIDTH-1:0] w_delta_out;
  wire [DATA_WIDTH-1:0] w_integrator_out;
  wire w_quantizer_out;

  delta_feedback #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_delta_feedback (
    .i_data(i_data),
    .i_quantized_bit(w_quantizer_out),
    .o_delta(w_delta_out)
  );

  integrator #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_integrator (
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_sample(i_sample),
    .i_data(w_delta_out),
    .o_data(w_integrator_out)
  );

  quantizer #(
    .DATA_WIDTH(DATA_WIDTH),
  ) u_quantizer (
    .i_data(w_integrator_out),
    .o_data(w_quantizer_out)
  );

  assign o_dac_out = w_quantizer_out;

endmodule