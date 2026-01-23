module delta_feedback #(
  parameter integer DATA_WIDTH = 16,
  parameter integer ADDITIONAL_DELTA_WIDTH = 1,
  parameter integer FEEDBACK_MAG = 1 << (DATA_WIDTH - 1)
) (
  input  wire signed [DATA_WIDTH-1:0] i_data,
  input  wire i_quantized_bit,
  output wire signed [DATA_WIDTH-1+ADDITIONAL_DELTA_WIDTH:0] o_delta
);

  localparam integer DELTA_WIDTH = DATA_WIDTH + ADDITIONAL_DELTA_WIDTH;

  wire signed [DELTA_WIDTH-1:0] w_data_ext = {{(DELTA_WIDTH-DATA_WIDTH){i_data[DATA_WIDTH-1]}}, i_data};

  assign o_delta = w_data_ext - (i_quantized_bit ? FEEDBACK_MAG : -FEEDBACK_MAG);

endmodule