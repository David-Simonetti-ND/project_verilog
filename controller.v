module controller
(
  //input wire [7:0] data      ,
  input wire input_data_ready      ,
  input wire is_multiplication_done,
  output reg initialize            ,
  output reg en_multiply           ,
  output reg en_modulo             ,
  output reg done
);

    // FSM states
    localparam integer WAITING=0, INITIALIZE=1, MULTIPLY=2, MODULO=3, DONE=4;

    reg [2:0] current_state = WAITING;
    reg [2:0] next_state;

    always @* begin
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