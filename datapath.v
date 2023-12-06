module datapath
(
  input wire [7:0] data            ,
  input wire clk                   ,
  input wire initialize            ,
  input wire en_multiply           ,
  input wire en_modulo             ,
  input wire done                  ,
  output reg is_multiplication_done,
  output reg [12:0] output_data
);

    reg [15:0] n = 3233;
    reg [15:0] e = 17;
    reg [7:0] frozen_data;
    reg [31:0] arithmetic_temp;
    reg [15:0] iterations_left;
    always @(posedge clk) 
    begin
        if (initialize) {
            frozen_data = data;
            arithmetic_temp = frozen_data;
            iterations_left = e;
        }
        if (en_multiply) {
            arithmetic_temp = arithmetic_temp * frozen_data;
            iterations_left = iterations_left - 1;
        }
        if (en_modulo) {
            arithmetic_temp = arithmetic_temp % n;
        }
        if (done) {
            output_data = arithmetic_temp;
        }
        is_multiplication_done = (iterations_left == 0);
    end

endmodule