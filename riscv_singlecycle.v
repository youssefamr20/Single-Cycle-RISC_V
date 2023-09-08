module riscv_singlecycle(
	input wire i_clk , i_rst_n ,
	input wire [31:0] i_instr ,
	input wire [31:0] i_read_data ,
	output wire [31:0] o_pc ,
	output wire [31:0] o_write_data , o_data_addr ,
	output wire o_mem_write  );

	wire reg_write , zero , alu_src ;
	wire [1:0] pc_src , immsrc , result_src ;
	wire [2:0] alu_ctrl ;


	data_path u_data_path(
	.i_clk(i_clk) , .i_rst_n(i_rst_n) ,
	.i_instr(i_instr) , 
	.i_read_data(i_read_data) ,
	.i_reg_write(reg_write) , 
	  .i_alu_src(alu_src)  ,
	.i_pc_src(pc_src) ,
	.i_immsrc(immsrc) ,
	 .i_result_src(result_src) ,
	.i_alu_ctrl(alu_ctrl) ,
	.o_zero(zero)  ,
	.o_write_data(o_write_data) ,
	.o_data_addr(o_data_addr) ,
	.o_pc(o_pc) );

	controller u_ctrl(
	.i_op(i_instr[6:0]) ,
	.i_funct3(i_instr[14:12]) ,
	.i_funct7(i_instr[31:25]) ,
	.i_zero(zero) ,
	.o_reg_write(reg_write) ,
    .o_mem_write(o_mem_write) ,
    .o_alu_src(alu_src)  ,
	.o_pc_src(pc_src) ,
	.o_immsrc (immsrc),
    .o_result_src(result_src) ,
	.o_alu_ctrl (alu_ctrl)
	);


endmodule