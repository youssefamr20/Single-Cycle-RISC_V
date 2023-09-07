 module alu_dec (
	input wire [2:0] i_funct3 ,
	input wire [6:0] i_funct7 ,
	input wire       i_op ,
	input wire	[1:0] i_alu_op ,
	output reg [2:0] o_alu_ctrl );

 	always@(*) begin 
 		case(i_alu_op)
 		2'b00: o_alu_ctrl = 3'b000; // lw , sw
 		2'b01: o_alu_ctrl = 3'b001; // beq
 		2'b10: begin 
 				case (i_funct3)
 					3'b000: begin
 							if ({i_op,i_funct7[5]}==2'b11) o_alu_ctrl = 3'b001 ; //sub
 							else o_alu_ctrl = 3'b000 ;
 						 end
 					3'b010: o_alu_ctrl = 3'b101 ; //slt
 					3'b110: o_alu_ctrl = 3'b011 ;
 					3'b111: o_alu_ctrl = 3'b010 ;
 					default:  o_alu_ctrl = 3'bxxx;
 				endcase
 			end
 		default : o_alu_ctrl = 3'bx ;
 		endcase
 	end

endmodule