`timescale 1ns / 1ps

module testeAssincrono;
  
    //Inputs
    reg clkCPU;
    reg clkPER1;
    reg clkPER2;
    reg rst; // testar com cada um com o seu reset
  
    //Outputs
  	wire [1:0] sendCPU1;
  	wire [1:0] sendCPU2;
    wire [15:0] dataCPU1;
    wire [15:0] dataCPU2;
  	wire [1:0] ackPER1;
  	wire [1:0] ackPER2;
  
    // Instantiate the Unit Under Test (UUT)
    assCPU cpu (
        .inAck1(ackPER1),
        .inAck2(ackPER2),
        .outSend1(sendCPU1),
        .outSend2(sendCPU2),
        .outData1(dataCPU1),
        .outData2(dataCPU2),
        .clkCPU(clkCPU),
        .rstCPU(rst)
    );
  
    assPeriferico per1 (
        .outAck(ackPER1),
        .inSend(sendCPU1),
        .inData(dataCPU1),
        .clkPER(clkPER1),
        .rstPER(rst)
    );

    assPeriferico per2 (
        .outAck(ackPER2),
        .inSend(sendCPU2),
        .inData(dataCPU2),
        .clkPER(clkPER2),
        .rstPER(rst)
    ); 

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        clkCPU = 0;
        clkPER1 = 0;
        clkPER2 = 0;
        rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        rst = 0;
        #100;

        #10;
        #17;
        #8;    
        $finish;
    end

    always  #10  clkCPU = !clkCPU;
    always  #17  clkPER1 = !clkPER1;
    always  #8  clkPER2 = !clkPER2;
endmodule