module delta_feedback
#(
  parameter integer DATA_WIDTH = 4
) (
  // delta IO
  input  [DATA_WIDTH-1:0] i_data,
  output [DATA_WIDTH-1:0] o_delta,

  // feedback IO
  input i_quantized_bit,

);

  assign o_delta = i_data - (i_quantized_bit ? {DATA_WIDTH{1'b1}} : {DATA_WIDTH{1'b0}});

endmodule