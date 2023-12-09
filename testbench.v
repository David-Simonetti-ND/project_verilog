module rsa_testbenc;
    reg clk = 1'd0;
    reg [12:0] data;
    reg [2:0] input_data_type;
    wire is_multiplication_done;
    wire is_init_done;
    wire is_mod_done;
    wire initialize;
    wire en_multiply;
    wire en_modulo;
    wire update_e;
    wire update_n;
    wire done;
    wire [15:0] output_data;
    reg testing;

    controller controller_inst(
      .clk(clk),
      .input_data_type(input_data_type),
      .is_multiplication_done(is_multiplication_done),
      .is_init_done(is_init_done),
      .is_mod_done(is_mod_done),
      .initialize(initialize),
      .en_multiply(en_multiply),
      .en_modulo(en_modulo),
      .update_e(update_e),
      .update_n(update_n),
      .done(done)
    );

    datapath datapath_inst( 
      .data(data),
      .clk(clk),
      .initialize(initialize),
      .en_multiply(en_multiply),
      .en_modulo(en_modulo),
      .update_e(update_e),
      .update_n(update_n),
      .done(done),
      .is_multiplication_done(is_multiplication_done),
      .is_init_done(is_init_done),
      .is_mod_done(is_mod_done),
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
        if (output_data != arithmetic_temp) begin
          $display("Error: incorrect encrypted value");
          $finish;
        end
      end
      $display("Changing the values of e and n to 17 and 323 respectively");
      data = 13'd17;
      #20
      input_data_type = 3'd3;
      #20
      input_data_type = 3'd0;
      #20
      data = 13'd323;
      #20
      input_data_type = 3'd2;
      #20
      input_data_type = 3'd0;
      #20
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
        arithmetic_temp = data;
        for (j = 1; j < 'd17; j = j + 1) begin
          arithmetic_temp = (arithmetic_temp * data) % 15'd323;
        end
        $display("Input value: ", data, " Encoded value: ", output_data, " Expected value: ", arithmetic_temp);
        if (output_data != arithmetic_temp) begin
          $display("Error: incorrect encrypted value");
          $finish;
        end
      end
      $finish;
    end

endmodule