module datapath
(
  input wire [12:0] data            ,
  input wire clk                   ,
  input wire initialize            ,
  input wire en_multiply           ,
  input wire en_modulo             ,
  input wire update_e              ,
  input wire update_n              ,
  input wire done                  ,
  output wire is_multiplication_done,
  output wire is_init_done          ,
  output wire is_mod_done           ,
  output reg [15:0] output_data
);

    reg [31:0] n = 3233;
    reg [31:0] e = 17;
    reg [7:0] frozen_data;
    reg [31:0] arithmetic_temp;
    reg [31:0] iterations_left;
    always @(posedge clk) 
    begin
        if (initialize) begin
            frozen_data <= data[7:0];
            arithmetic_temp <= {24'b0, data[7:0]};
            iterations_left <= e;
        end
        if (en_multiply) begin
            arithmetic_temp <= arithmetic_temp * frozen_data;
            iterations_left <= iterations_left - 1;
        end
        if (en_modulo) begin
            if (arithmetic_temp >= n)
                arithmetic_temp <= arithmetic_temp - n;
        end
        if (done) 
            output_data <= arithmetic_temp[15:0];
        if (update_e)
            e <= {19'd0, data};
        if (update_n)
            n <= {19'd0, data};
    end

    assign is_multiplication_done = (iterations_left == 1);
    assign is_init_done = (iterations_left == e);
    assign is_mod_done = (n > arithmetic_temp);

endmodule
