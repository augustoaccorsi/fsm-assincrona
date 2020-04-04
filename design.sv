`timescale 1ns / 1ps

module assCPU(inAck1, inAck2, outSend1, outSend2, outData1, outData2, clkCPU, rstCPU);
  output reg [1:0] outSend1 = 0; 
  output reg [1:0] outSend2 = 0;
  output reg [15:0] outData1; 
  output reg [15:0] outData2;
  
  input [1:0] inAck1;
  input [1:0] inAck2; 
  input clkCPU;
  input rstCPU;
  
  /* STATES 
  	 0 NOT SENDING
  	 1 SENDING
  */
  reg currentStateCPU;
  reg nextStateCPU;

   /***** STATE *****/
    always @ (posedge clkCPU)
        begin
            if(rstCPU == 1)
                currentStateCPU <= 0;
            else
                currentStateCPU <= nextStateCPU;
        end
    /***** STATE *****/

    /***** NEXT STATE *****/
	always @ (*)
	begin
		case ({currentStateCPU})
			0, 1:
              if (inAck1 == 1 || inAck2 == 1) /* precisa esperar os dois acks?*/
					nextStateCPU = 1;
				else
					nextStateCPU = 0;
		endcase
	end
    /***** NEXT STATE *****/

    /***** OUTPUT PERIFERICO 1 *****/
    always @ (*)
	begin
      if(rstCPU == 0 && clkCPU ==1)
		case ({currentStateCPU})
			0:
			begin
                  outSend1 = 1;
                  // Generates a random between 0 and 15
                  outData1 = $urandom%15;
			end
			1:
			begin
				outSend1 = 0;
			end
			
		endcase
	end
  	/***** OUTPUT PERIFERICO 1 *****/
    
    /***** OUTPUT PERIFERICO 2 *****/
    always @ (*)
	begin
        if(rstCPU == 0 && clkCPU ==1)
          case ({currentStateCPU})
              0:
              begin
                    outSend2 = 1;
                    // Generates a random between 0 and 15
                    outData2 = $urandom%15;
              end
              1:
              begin
                  outSend2 = 0;
              end

          endcase
	end
  	/***** OUTPUTS PERIFERICO 2 *****/

endmodule

module assPeriferico(outAck, inSend, inData, clkPER, rstPER);
  output reg [1:0] outAck = 0;

  input [15:0] inData;
  input [1:0] inSend;
  input clkPER;
  input rstPER;

    /* STATES 
  	 0 NOT RECEVING
  	 1 RECEVING
    */
  reg currentStatePER;
  reg nextStatePER;
  reg [15:0] dataPER;

  	/***** STATE *****/
	always @ (posedge clkPER)
        begin
            if (rstPER == 1)
                currentStatePER <= 0;
            else
                currentStatePER <= nextStatePER;
        end
	/***** STATE *****/  

    /***** NEXT STATE *****/
	always @ (*)
	begin
		case ({currentStatePER})
			0, 1:
				if (inSend == 1)
					nextStatePER = 1;
				else
					nextStatePER = 0;
		endcase
	end
	/***** NEXT STATE *****/

    /***** OUTPUTS *****/
	always @ (*)
	begin
      if(rstPER == 0)
		case ({currentStatePER})	
			0:
				outAck = 0;
			1:
			begin
				if(inSend == 1) 
					dataPER = inData;
					outAck = 1;
			end
		endcase
	end
  	/***** OUTPUTS *****/

endmodule