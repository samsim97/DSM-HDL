module integrator #(
  parameter integer IN_WIDTH = 4,
  parameter integer ACC_WIDTH = IN_WIDTH + 2
) (
  input  wire i_clk,
  input  wire i_rst_n,
  input  wire i_sample,
  input  wire signed [IN_WIDTH-1:0] i_data,
  output wire signed [ACC_WIDTH-1:0] o_data
);

  reg signed [ACC_WIDTH-1:0] r_data;
  wire signed [ACC_WIDTH-1:0] w_data_ext = {{(ACC_WIDTH-IN_WIDTH){i_data[IN_WIDTH-1]}}, i_data};

  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      r_data <= '0;
    end else if (i_sample) begin
      r_data <= r_data + w_data_ext;
    end
  end

  assign o_data = r_data;

endmodule