module quantizer #(
  parameter integer DATA_WIDTH = 8
) (
  input  wire signed [DATA_WIDTH-1:0] i_data,
  output wire o_data
);

  assign o_data = (i_data >= 0) ? 1'b1 : 1'b0;

endmodule