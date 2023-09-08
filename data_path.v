module data_path (
	input wire i_clk , i_rst_n ,
	input wire [31:0] i_instr , i_read_data ,
	input wire i_reg_write , i_alu_src  ,
	input wire [1:0]  i_pc_src ,
	input wire [1:0] i_immsrc , i_result_src ,
	input wire [2:0] i_alu_ctrl ,
	output wire o_zero  ,
	output wire [31:0] o_write_data ,
	output wire [31:0] o_data_addr ,
	output wire [31:0] o_pc );
	
	wire write_enable ;
	wire [31:0] result , reg_read_a , reg_read_b , immext , src_b , alu_result , pc , pc_target , pc_plus_4 , pc_next;

	assign o_pc = pc ;

	reg_file u_reg_file(
	.i_clk(i_clk) ,
	.i_rst_n(i_rst_n) ,
	.i_addr1(i_instr[19:15]) , 
	.i_addr2(i_instr[24:20]) , 
	.i_addr3(i_instr[11:7]) ,
	.i_wd3(result) ,
	.i_we3(i_reg_write) ,
	.o_rd1(reg_read_a) , 
	.o_rd2(reg_read_b) );

	extend u_extend(.i_instr(i_instr[31:7]) , .i_immsrc(i_immsrc) , .o_immext(immext));

	gen_mux #(32,1) alu_src_mux(.i_in ({immext,reg_read_b}) , 
								.i_sel(i_alu_src) ,
							    .i_out(src_b));

	alu u_alu (.i_srca(reg_read_a) ,
	     .i_srcb(src_b) , 
		 .i_alu_ctrl(i_alu_ctrl) ,
		 .o_alu_result(alu_result) , 
		 .o_zero(o_zero) );
	
	adder pc_target_adder (.i_a(pc) , .i_b(immext) , .o_y(pc_target) ) ;

	adder pc_plus_4_adder (.i_a(pc) , .i_b(32'b0100) , .o_y(pc_plus_4) ) ;

	gen_mux #(32,2) pc_src_mux(.i_in ({ 32'bx  , alu_result , pc_target , pc_plus_4 }) ,
							  .i_sel(i_pc_src) ,
							  .i_out(pc_next));

	flip_flop #(32) u_ff_pc (.clk(i_clk) , .rst_n(i_rst_n) , .din (pc_next) , .dout(pc));

	gen_mux #(32,2) result_src_mux(.i_in ({ 32'bx  , pc_plus_4 , i_read_data , alu_result }) ,
			                       .i_sel(i_result_src) ,
			                       .i_out(result)  );

endmodule 
	
