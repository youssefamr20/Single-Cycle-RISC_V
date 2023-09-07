module main_dec ( 
	input wire  [6:0] i_op ,
	output wire [1:0] o_result_src ,
	output wire 	  o_mem_write ,
	output wire 	  o_alu_src  ,
	output wire [1:0] o_immsrc ,
	output wire  	  o_reg_write ,
	output wire [1:0] o_alu_op  ,
	output wire 	  o_branch  ,
	output wire 	  o_jump   , 
	output wire       o_jalr ) ;

	reg [11:0] controls ;
	assign {o_reg_write , o_immsrc , o_alu_src , o_mem_write , o_result_src ,  o_alu_op , o_branch , o_jump , jalr } = controls ;

	always@(*) begin 
		case (i_op)  
		  'd51: controls = 12'b1_xx_0_0_00_10_0_0_0; // and or 
		  'd3:  controls = 12'b1_00_1_0_01_00_0_0_0; // LW
		  'd19: controls = 12'b1_00_1_0_00_10_0_0_0; //I-type
		  'd111:controls = 12'b1_11_x_0_10_xx_0_1_0;  //JAL
		  'd103:controls = 12'b1_00_1_0_00_10_0_1_1; //JALR I type
		  'd99: controls = 12'b0_10_0_0_xx_01_1_0_0; // branching (BEQ, BNE)
		  'd35: controls = 12'b0_01_1_1_xx_00_0_0_0; //SW
		 default: controls = 10'bx ; 
		endcase
	end

endmodule