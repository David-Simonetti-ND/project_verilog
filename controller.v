module controller
(
  input wire clk                   ,
  input wire input_data_type ,
  input wire is_multiplication_done,
  input wire is_init_done          ,
  output reg initialize            ,
  output reg en_multiply           ,
  output reg en_modulo             ,
  output reg done                  
);

    // FSM states
    reg[2:0] WAITING=3'd0, INITIALIZE=3'd1, MULTIPLY=3'd2, MODULO=3'd3, DONE=3'd4;

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
        done = 0;
        next_state = WAITING;
        case(current_state)
            WAITING: begin
                if (input_data_type) 
                    next_state = INITIALIZE;
                else
                    next_state = WAITING;
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
                en_modulo = 1;
                next_state = MULTIPLY;
            end
            DONE: begin
                done = 1;
                next_state = WAITING;
            end
        endcase
    end
endmodule
