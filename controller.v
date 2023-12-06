module controller
(
  input wire clk                   ,
  input wire input_data_ready      ,
  input wire is_multiplication_done,
  output reg initialize            ,
  output reg en_multiply           ,
  output reg en_modulo             ,
  output reg done
);

    // FSM states
    localparam integer WAITING=3'd0, INITIALIZE=3'd1, MULTIPLY=3'd2, MODULO=3'd3, DONE=3'd4;

    reg [2:0] current_state = WAITING;
    reg [2:0] next_state;

    always @(posedge clk)
    begin
        initialize = 0;
        en_multiply = 0;
        en_modulo = 0;
        done = 0;
        case(current_state)
            WAITING:
                if (input_data_ready) {
                    next_state = INITIALIZE;
                }
                else {
                    next_state = WAITING;
                }
            INITIALIZE:
                initialize = 1;
                next_state = MULTIPLY;
            MULTIPLY:
                if (is_multiplication_done) {
                    next_state = DONE;
                }
                else {
                    en_multiply = 1;
                    next_state = MODULO;
                }
            MODULO:
                en_modulo = 1;
                next_state = MULTIPLY;
            DONE:
                done = 1;
                next_state = INITIALIZE;
        endcase
        current_state = next_state;
    end
endmodule