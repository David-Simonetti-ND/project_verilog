module rsa_testbenc;
    reg clk = 1'd0;
    reg [12:0] data;
    reg [2:0] input_data_type;
    wire is_multiplication_done;
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
      .output_data(output_data)
    );

    always
      #10 clk <= !clk;

    integer i;
    initial begin
      $display("Starting simulation");
      for (i = 0; i <= 255; i = i + 1) begin
        data = i;
        #20
        input_data_type = 3'd1;
        #20
        input_data_type = 3'd0;
        while (done == 0) begin
          #10 testing = 1;
        end
        #20
        $display("Input value: ", data, " Encoded value: ", output_data, " Expected value: X");
      end
      $display("Changing the values of e and n to 3 and 15 respectively");
      data = 13'd3;
      #20
      input_data_type = 3'd2;
      #20
      input_data_type = 3'd0;
      #20
      data = 13'd15;
      #20
      input_data_type = 3'd3;
      #20
      input_data_type = 3'd0;
      #20
      for (i = 0; i < 15; i = i + 1) begin
        data = i;
        #20
        input_data_type = 3'd1;
        #20
        input_data_type = 3'd0;
        while (done == 0) begin
          #10 testing = 1;
        end
        #20
        $display("Input value: ", data, " Encoded value: ", output_data, " Expected value: X");
      end
      $finish;
    end

endmodule