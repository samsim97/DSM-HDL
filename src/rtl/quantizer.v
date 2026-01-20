module quantizer #(
  parameter integer STATE_WIDTH = 8
) (
  input  wire signed [STATE_WIDTH-1:0] i_state,
  output wire                          o_data
);

  // 1-bit comparator: output 1 when state is non-negative
  assign o_data = (i_state >= 0) ? 1'b1 : 1'b0;

endmodule