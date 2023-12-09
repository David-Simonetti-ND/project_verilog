module rsa_testbenc;
    reg clk = 1'd0;
    reg [7:0] data;
    reg input_data_type;
    wire is_multiplication_done;
    wire is_init_done;
    wire initialize;
    wire en_multiply;
    wire en_modulo;
    wire done;
    wire update_e;
    wire update_n;
    wire [15:0] output_data;
    reg testing;

    controller controller_inst(
      .clk(clk),
      .input_data_type(input_data_type),
      .is_multiplication_done(is_multiplication_done),
      .is_init_done(is_init_done),
      .initialize(initialize),
      .en_multiply(en_multiply),
      .en_modulo(en_modulo),
      .done(done),
      .update_e(update_e),
      .update_n(update_n)
    );

    datapath datapath_inst( 
      .data(data),
      .clk(clk),
      .initialize(initialize),
      .en_multiply(en_multiply),
      .en_modulo(en_modulo),
      .done(done),
      .update_e(update_e),
      .update_n(update_n),
      .is_multiplication_done(is_multiplication_done),
      .is_init_done(is_init_done),
      .output_data(output_data)
    );

    always
      #10 clk <= !clk;

    integer i;
    integer j;
    reg [31:0] arithmetic_temp;
    initial begin
      $display("Starting simulation");
      for (i = 0; i <= 255; i = i + 1) begin
        data = i;
        #20
        input_data_type = 1'd1;
        #20
        input_data_type = 1'd0;
        while (done == 0) begin
          #10 testing = 1;
        end
        #20
        arithmetic_temp = data;
        for (j = 1; j < 'd17; j = j + 1) begin
          arithmetic_temp = (arithmetic_temp * data) % 15'd3233;
        end
        $display("Input value: ", data, " Encoded value: ", output_data, " Expected value: ", arithmetic_temp);
      end
      $finish;
    end

endmodule