module controller (
	input  wire [6:0] i_op ,
	input  wire [2:0] i_funct3 ,
	input  wire [6:0] i_funct7 ,
	input  wire i_zero ,
	output wire o_reg_write ,  o_mem_write , o_alu_src  ,
	output wire [1:0]  o_pc_src ,
	output wire [1:0] o_immsrc , o_result_src ,
	output wire [2:0] o_alu_ctrl 
	);

	wire branch , jump , jalr ;
	wire [1:0] alu_op ;

	assign o_pc_src = ( (i_zero & branch) | jump ) ? 01 : (jalr) ? 10 : 00  ;


	main_decoder main_dec (
	 .i_op(i_op) ,
	 .o_result_src(o_result_src) ,
	 .o_mem_write (o_mem_write) ,
	 .o_alu_src (o_alu_src),
	 .o_immsrc(o_immsrc) ,
	 .o_reg_write(o_reg_write) ,
	 .o_alu_op (alu_op) ,
	 .o_branch (branch) ,
	 .o_jump (jump) , 
	 .o_jalr(jalr) );	

	alu_decoder alu_dec (
		 .i_funct3(i_funct3) ,
	 	 .i_funct7(i_funct3) ,
	 	 .i_op(i_op[5]) ,
		 .i_alu_op(alu_op) , 
		 .o_alu_ctrl(o_alu_ctrl) );

endmodule