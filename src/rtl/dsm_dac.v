module dsm_dac #(
  parameter integer DATA_WIDTH = 16,
  parameter integer ACC_WIDTH  = DATA_WIDTH + 3
) (
  input  wire i_clk,
  input  wire i_rst_n,
  input  wire i_en,
  input  wire signed [DATA_WIDTH-1:0] i_data,
  output wire o_dac_bitstream
);

  localparam integer ADDITIONAL_DELTA_WIDTH        = 1;
  localparam integer DELTA_WIDTH                   = DATA_WIDTH + ADDITIONAL_DELTA_WIDTH;
  localparam signed [DELTA_WIDTH-1:0] FEEDBACK_MAG = 1 << (DATA_WIDTH - 1);

  wire signed [DELTA_WIDTH-1:0] w_delta_out;
  // Scale i_data to DELTA_WIDTH
  wire signed [DELTA_WIDTH-1:0] w_delta_data_in_ext = {{(DELTA_WIDTH-DATA_WIDTH){i_data[DATA_WIDTH-1]}}, i_data};

  reg signed [ACC_WIDTH-1:0] r_int_data;
  // Scale w_delta_out to ACC_WIDTH
  wire signed [ACC_WIDTH-1:0] w_int_data_ext = {{(ACC_WIDTH-DELTA_WIDTH){w_delta_out[DELTA_WIDTH-1]}}, w_delta_out};
  wire w_quantize_bit;

  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      r_int_data <= '0;
    end else if (i_en) begin
      r_int_data <= r_int_data + w_int_data_ext;
    end
  end

  assign w_delta_out     = w_delta_data_in_ext - (w_quantize_bit ? FEEDBACK_MAG : -FEEDBACK_MAG);
  assign w_quantize_bit  = (r_int_data >= 0) ? 1'b1 : 1'b0;
  assign o_dac_bitstream = w_quantize_bit;

endmodule