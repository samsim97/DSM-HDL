module input_fsm #(
  parameter integer DATA_WIDTH = 16,
  parameter integer HOLD_CYCLES = 1000
) (
  input  wire i_clk,
  input  wire i_rst_n,
  output wire signed [DATA_WIDTH-1:0] o_data
);

  localparam [1:0] INCREMENTING = 2'b00;
  localparam [1:0] DECREMENTING = 2'b01;
  localparam [1:0] HOLDING_LOW  = 2'b10;
  localparam [1:0] HOLDING_HIGH = 2'b11;

  reg signed [DATA_WIDTH-1:0] r_data, r_data_n;
  reg [31:0] clk_cycle_count, clk_cycle_count_n;
  reg [1:0] r_current_state, r_next_state;

  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      r_current_state  <= INCREMENTING;
      r_data           <= '0;
      clk_cycle_count  <= 32'd0;
    end else begin
      r_current_state  <= r_next_state;
      r_data           <= r_data_n;
      clk_cycle_count  <= clk_cycle_count_n;
    end
  end

  always @(*) begin
    r_next_state        = r_current_state;
    r_data_n            = r_data;
    clk_cycle_count_n   = clk_cycle_count;

    case (r_current_state)
      INCREMENTING: begin
        r_data_n = r_data + 1;
        if (clk_cycle_count == HOLD_CYCLES) begin
          r_next_state      = HOLDING_HIGH;
          clk_cycle_count_n = 32'd0;
        end else begin
          clk_cycle_count_n = clk_cycle_count + 1;
        end
      end

      DECREMENTING: begin
        r_data_n = r_data - 1;
        if (clk_cycle_count == HOLD_CYCLES) begin
          r_next_state      = HOLDING_LOW;
          clk_cycle_count_n = 32'd0;
        end else begin
          clk_cycle_count_n = clk_cycle_count + 1;
        end
      end

      HOLDING_LOW: begin
        if (clk_cycle_count == HOLD_CYCLES) begin
          r_next_state      = INCREMENTING;
          clk_cycle_count_n = 32'd0;
        end else begin
          clk_cycle_count_n = clk_cycle_count + 1;
        end
      end

      HOLDING_HIGH: begin
        if (clk_cycle_count == HOLD_CYCLES) begin
          r_next_state      = DECREMENTING;
          clk_cycle_count_n = 32'd0;
        end else begin
          clk_cycle_count_n = clk_cycle_count + 1;
        end
      end

      default: begin
        r_next_state      = INCREMENTING;
        r_data_n          = '0;
        clk_cycle_count_n = 32'd0;
      end
    endcase
  end

  assign o_data = r_data;

endmodule