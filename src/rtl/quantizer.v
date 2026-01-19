module quantizer #(
  parameter integer DATA_WIDTH = 4,
) (
  input [DATA_WIDTH-1:0] i_data,
  output o_data
);

  assign o_data = (i_data >= 0) ? 1'b1 : 1'b0;

  // always @(*) begin
  //   if (i_data >= (2**DATA_WIDTH)/2) begin
  //     o_data = 1'b1;
  //   end else begin
  //     o_data = 1'b0;
  //   end
  // end

endmodule