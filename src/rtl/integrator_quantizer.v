module integrator_quantizer #(
  parameter integer DATA_WIDTH = 16,
  parameter integer ADDITIONAL_DELTA_WIDTH = 1,
  parameter integer ACC_WIDTH = DATA_WIDTH + 2
) (
  input  wire i_clk,
  input  wire i_rst_n,
  input  wire i_en,
  input  wire signed [DATA_WIDTH-1:0] i_data,
  output wire o_data
);

  reg signed [ACC_WIDTH-1:0] r_data;
  wire signed [ACC_WIDTH-1:0] w_data_ext = {{(ACC_WIDTH-DATA_WIDTH){i_data[DATA_WIDTH-1]}}, i_data};

  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      r_data <= '0;
    end else if (i_en) begin
      r_data <= r_data + w_data_ext;
    end
  end

  assign o_data = (r_data >= 0) ? 1'b1 : 1'b0;

endmodule