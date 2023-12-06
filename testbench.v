module rsa_testbenc;
    reg clk = 1'd0;
    reg [7:0] data;
    reg input_data_ready;
    wire is_multiplication_done;
    wire initialize;
    wire en_multiply;
    wire en_modulo;
    wire done;
    wire [15:0] output_data;
    reg testing;

    controller controller_inst(
      .clk(clk),
      .input_data_ready(input_data_ready),
      .is_multiplication_done(is_multiplication_done),
      .initialize(initialize),
      .en_multiply(en_multiply),
      .en_modulo(en_modulo),
      .done(done)
    );

    datapath datapath_inst( 
      .data(data),
      .clk(clk),
      .initialize(initialize),
      .en_multiply(en_multiply),
      .en_modulo(en_modulo),
      .done(done),
      .is_multiplication_done(is_multiplication_done),
      .output_data(output_data)
    );

    always
      #10 clk <= !clk;

    initial begin
      data = 8'd65;
      input_data_ready = 1'd0;
      $display("Starting");
      input_data_ready = 1'd1;
      #20
      input_data_ready = 1'd0;
      while (done == 0) begin
        #10 testing = 1;
      end
      #50
      $display("Encoded value: ", output_data);
      $finish;
    end

endmodule