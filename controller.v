module controller
(
  input wire clk                   ,
  input wire [2:0] input_data_type ,
  input wire is_multiplication_done,
  input wire is_init_done          ,
  input wire is_mod_done           ,
  output reg initialize            ,
  output reg en_multiply           ,
  output reg en_modulo             ,
  output reg update_e              ,
  output reg update_n              ,
  output reg done                  
);

    // FSM states
    reg[2:0] WAITING=3'd0, INITIALIZE=3'd1, MULTIPLY=3'd2, MODULO=3'd3, DONE=3'd4, UPDATE_N_STATE=3'd5, UPDATE_E_STATE=3'd6;
    reg[1:0] NONE=2'd0, INPUT_DATA_READY=2'd1, N_READY=2'd2, E_READY=2'd3;

    reg [2:0] current_state = 3'd0;
    reg [2:0] next_state = 3'd0;
    initial begin
        initialize = 1'd0;
        en_multiply = 1'd0;
        en_modulo = 1'd0;
        done = 1'd0;
    end

    always @(posedge clk) begin
		current_state <= next_state;
    end

    always @(*) begin
        initialize = 0;
        en_multiply = 0;
        en_modulo = 0;
        update_e = 0;
        update_n = 0;
        done = 0;
        next_state = WAITING;
        case(current_state)
            WAITING: begin
                if (input_data_type == NONE) 
                    next_state = WAITING;
                else if(input_data_type == INPUT_DATA_READY)
                    next_state = INITIALIZE;
                else if (input_data_type == N_READY)
                    next_state = UPDATE_N_STATE;
                else if(input_data_type == E_READY)
                    next_state = UPDATE_E_STATE;
            end
            INITIALIZE: begin
                initialize = 1;
                if (is_init_done)
                    next_state = MULTIPLY;
                else
                    next_state = INITIALIZE;
            end
            MULTIPLY: begin
                if (is_multiplication_done) 
                    next_state = DONE;
                else begin
                    en_multiply = 1;
                    next_state = MODULO;
                end
            end
            MODULO: begin
                if (is_mod_done)
                    next_state = MULTIPLY;
                else begin
                    en_modulo = 1;
                    next_state = MODULO;
                end
            end
            DONE: begin
                done = 1;
                next_state = WAITING;
            end
            UPDATE_N_STATE: begin
                update_n = 1;
                next_state = WAITING;
            end
            UPDATE_E_STATE: begin
                update_e = 1;
                next_state = WAITING;
            end
        endcase
    end
endmodule
