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
  reg currentStateCPU1;
  reg nextStateCPU1;
  reg currentStateCPU2;
  reg nextStateCPU2;

   /***** STATE *****/
    always @ (posedge clkCPU)
        begin
          if(rstCPU == 1) begin
                currentStateCPU1 <= 0;
              currentStateCPU2 <= 0;
          end
            else begin
                currentStateCPU1 <= nextStateCPU1;
              currentStateCPU2 <= nextStateCPU2;
            end
        end
    /***** STATE *****/

    /***** NEXT STATE CPU1 *****/
  always @ (*)
  begin
      case ({currentStateCPU1})
      0, 1:
              if (inAck1 == 1) /* precisa esperar os dois acks?*/
          nextStateCPU1 = 1;
        else
          nextStateCPU1 = 0;
    endcase
  end
    /***** NEXT STATE *****/

      /***** NEXT STATE CPU2 *****/
  always @ (*)
  begin
      case ({currentStateCPU2})
      0, 1:
            if (inAck2 == 1) /* precisa esperar os dois acks?*/
          nextStateCPU2 = 1;
        else
          nextStateCPU2 = 0;
    endcase
  end
    /***** NEXT STATE *****/
  
  
    /***** OUTPUT PERIFERICO 1 *****/
    always @ (*)
  begin
        case ({currentStateCPU1})
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
          case ({currentStateCPU2})
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