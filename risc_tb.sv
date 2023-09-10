`timescale 1ns / 1ps

module risc_tb ();
 reg clk , rst_n ; 
 
  risc_v_top u_risc (clk , rst_n );
  
  wire [31:0] instr  ;
  assign instr = u_risc.u_inst_mem.o_rd ;
  integer errors=0;

  initial begin 
  	clk =0  ;
  	rst_n=0 ;
  	#10 
  	rst_n=1 ;
  	 repeat (20) begin 
  	  @(posedge clk);
      fork
        $write("@t=%0t, Instruction:%8h  ",$time ,u_risc.u_inst_mem.o_rd );
        check(instr);
      join_none
  	 end 
     $display("ERRORS=%0d",errors);
  	 $finish ;
  end

task check (input reg [31:0] instr);
 begin:check

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [4:0] rs1,rs2,rd ;
    reg[31:0] rs1_data , rs2_data , rd_data ;
    reg signed [31:0] exp_data ;
    reg signed [31:0] immediate;

    opcode=instr[6:0] ;
    funct3=instr[14:12];
    funct7=instr[31:25]; 
    rs1=instr[19:15];
    rs2=instr[24:20];
    rd= instr[11:7];

    case (opcode) //opcode
        'd51:   // R-type
          begin
            rs1_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rs1];
            rs2_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rs2];
            
             case (funct3) //funct3
               3'b000:
               begin 
                  case(funct7[5])//funct7[5]
                    0: //ADD
                    begin 
                        $write("add x%0d x%0d x%0d ", rd , rs1 , rs2);
                        exp_data = rs1_data + rs2_data;
                        @(posedge clk )  
                        rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                        if (exp_data == rd_data )
                            $display(" x%0d=%0d ,expected x%0d=%0d ,PASSED! ",rd , rd_data,rd,exp_data);
                        else
                          begin
                            errors++;
                            $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data,rd,exp_data);
                          end
                    end
                    1: begin  
                     $write("sub x%0d x%0d x%0d ", rd , rs1 , rs2); //SUB
                        exp_data = rs1_data - rs2_data;
                        @(posedge clk)  
                        rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                        if (exp_data == rd_data )
                            $display(" x%0d=%0d ,expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                        else
                           begin
                            errors++;
                            $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
                           end
                    end
                  endcase
               end
               3'b001:$display("sll isnt supported yet");
               3'b010:  //slt
                    begin        
                        $write("slt x%0d x%0d x%0d ", rd , rs1 , rs2); //SUB
                         exp_data = (rs1_data < rs2_data)?32'b1:32'b0;
                        @(posedge clk)  
                         rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                        if (exp_data == rd_data )
                            $display(" x%0d=%0d ,expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                        else
                          begin 
                            errors++;
                            $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
                         end
                    end
              
               3'b110:
                    begin        
                        $write("or x%0d x%0d x%0d ", rd , rs1 , rs2); //SUB
                        exp_data = rs1_data | rs2_data;
                        @(posedge clk)  
                         rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                        if (exp_data == rd_data )
                            $display(" x%0d=%0d ,expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                        else
                        begin 
                            errors++;
                            $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
                        end
                    end
               3'b111: //and 
                     begin        
                        $write("and x%0d x%0d x%0d ", rd , rs1 , rs2); //SUB
                         exp_data = rs1_data & rs2_data;
                        @(posedge clk)  
                         rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                        if (exp_data == rd_data )
                            $display(" x%0d=%0d ,expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                        else
                          begin 
                            errors++;
                            $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
                          end
                    end
               3'b100: //XOR
                     begin        
                        $write("xor x%0d x%0d x%0d ", rd , rs1 , rs2); //SUB
                        exp_data = rs1_data ^ rs2_data;
                        @(posedge clk)  
                         rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                        if (exp_data == rd_data )
                            $display(" x%0d=%0d expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                        else
                          begin 
                            errors++;
                            $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
                          end
                    end

             default:$display("Undefined R-type instruction");
            endcase
          end
        'd3:  // LW
          begin 
            immediate={{20 {instr[31]} }, instr[31:20]};
            $write("LW x%0d %0d(x%0d)  ",rd,immediate,rs1);
            $write("[%0d]=%0d " , (immediate+rs1), u_risc.u_data_mem.mem[(immediate+rs1)] );
            @(posedge clk) 
            rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
             if(rd_data==u_risc.u_data_mem.mem[(immediate+rs1)] )
                $display("PASSED");
            else 
              begin 
                errors++;
                $display("ERROR");
              end
           end
        'd19:  // I-type
            begin 
            rs1_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rs1];
            rs2_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rs2];
            immediate={{20 {instr[31]} },instr[31:20]};
            case(funct3)
            3'b000: 
            begin 
              $write("addi x%0d x%0d %0d ",rd,rs1,immediate);
              exp_data=rs1_data+immediate;
              @(posedge clk)
              rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                if (rd_data==exp_data)
                   $display(" x%0d=%0d expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                else
                  begin 
                    errors++;
                  $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
                  end
             end
            3'b100:
            begin 
                $write("xori x%0d x%0d %0d ",rd,rs1,immediate);
                exp_data=immediate^rs1;
                @(posedge clk)
                rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                  if (rd_data==exp_data)
                     $display(" x%0d=%0d expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                  else
                  begin 
                    errors++;
                    $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
                  end
             end
            3'b110:
            begin 
              $write("ori x%0d x%0d %0d ",rd,rs1,immediate);
              exp_data=immediate|rs1;
              @(posedge clk)
              rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                if (rd_data==exp_data)
                   $display(" x%0d=%0d expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                else
               begin 
                  errors++;
                  $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
               end
            end
            3'b111:
            begin 
              $write("andi x%0d x%0d %0d ",rd,rs1,immediate);
              exp_data=immediate&rs1;
              @(posedge clk)
              rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
                if (rd_data==exp_data)
                   $display(" x%0d=%0d expected x%0d=%0d ,PASSED! ",rd ,rd_data,rd,exp_data );
                else
                 begin 
                  errors++;
                  $display(" x%0d=%0d but expected x%0d=%0d ,ERROR!", rd , rd_data , rd ,exp_data);
                 end
            end
            default:$display("this I-type instruction isnt supported yet");
         endcase    
            end

        'd103: ; // Jalr - // I-type
        'd111:  // J type
          begin
            immediate={{12{instr[31]}}, instr[19:12],instr[20], instr[30:21], 1'b0};
            $write("jal x%0d %0h  ,", rd , immediate );
            exp_data = u_risc.u_risc.u_data_path.pc_plus_4 ;// use it to store pc counter
            @(posedge clk)
            rd_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rd];
            if (exp_data==rd_data && u_risc.pc==(immediate+exp_data-4))
                $display("PASSED");
            else 
             begin 
                errors++;
                $display("x%0d=%0d & pc=%0h , expected: x%0d=%0d & pc=%0h ,Failed",rd,rd_data,u_risc.pc,rd,exp_data,(immediate+exp_data-32'd4));
            end
          end
        
        'd99:   //B-type
          begin
            rs1_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rs1];
            rs2_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rs2];
            immediate= {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; 
            case(funct3) 
                3'b000: //beq
                    begin 
                        $write("beq x%0d x%0d %0h ",rs1,rs2,immediate );
                        $write ("x%0d=%0d x%0d=%0d ",rs1,rs1_data,rs2,rs2_data );
                        exp_data=u_risc.pc ; // we will use it here for storing last pc to compare
                        @(posedge clk)
                        if (rs1_data==rs2_data)begin 
                            if (u_risc.pc == immediate+exp_data )// make sure it branched and the pc took the label
                                $display("PASSED!");
                            else
                            begin 
                                errors++;
                                $display("Failed! , pc=%0h , expected_pc=%0h" ,u_risc.pc, (immediate+exp_data));
                            end
                        end
                        else begin 
                            if (u_risc.pc==exp_data+32'd4)// make sure it branched and the pc took the label
                                $display("PASSED!");
                            else
                            begin
                                $display("Failed! , pc=%0h , expected_pc=%0h" ,u_risc.pc,exp_data+32'd4);
                                errors++;
                            end
                        end
                    end
                3'b001: $write("bne x%0d x%0d %0h ",rd,rs1,immediate); //bne
                default: $display("this B-type instruction isnt supported yet");
            endcase
          end
        'd35: // S-type
         begin
            rs1_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rs1];
            rs2_data=u_risc.u_risc.u_data_path.u_reg_file.registers[rs2];
            immediate={{20{instr[31]}}, instr[31:25],instr[11:7]};
            case(funct3)
             3'b010:
                begin
                    $write("sw x%0d %0d(x%0d)  " ,rs2, immediate,rs1);
                    @(posedge clk)
                    exp_data=u_risc.u_data_mem.mem[rs1_data+immediate]; // not expected , its the actual
                    if (exp_data==rs2_data)//data in register is saved in the expected address
                        $display("[%0d]=x%0d=%0d ,PASSED!", rs1_data+immediate , rs2 , rs2_data);
                    else
                    begin 
                        errors++;
                        $display("[%0d]=x%0d=%0d , expected:[%0d]=x%0d ,Failed!",rs1_data+immediate,rs2,rs2_data,rs1_data+immediate,exp_data);
                        end
                end
             default: $display("Undefined S-type instructio");
            endcase
        end      
        default: $display("This opcode wasn't detected by the testbench , opcode=%7h", opcode );
    endcase 
  end:check
endtask

  initial begin 
  	forever #5 clk=~clk ;
  end

endmodule