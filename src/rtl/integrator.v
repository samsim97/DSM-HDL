module integrator #(
  parameter integer DATA_WIDTH = 4
) (
  input i_clk,
  input i_rst_n,
  input i_sample,
  input [DATA_WIDTH-1:0]  i_data,
  output [DATA_WIDTH-1:0] o_data
);

  reg [DATA_WIDTH-1:0] r_data;

  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      r_data <= 0;
    end else if (i_sample) begin
      r_data <= r_data + i_data;
    end
  end

  assign o_data = r_data;

endmodule