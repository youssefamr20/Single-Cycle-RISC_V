module risc_v_top (
 	input wire i_clk ,
 	input wire i_rst_n );

	wire [31:0] instruction , pc , write_data , data_addr , read_data , alu_result ;
	wire mem_write ;

	instr_mem u_inst_mem(
	 .i_a (pc) ,
	 .o_rd(instruction)
	 );

	data_mem u_data_mem(
	.i_clk(i_clk) , 
	.i_rst_n(i_rst_n) ,
	.i_we(mem_write) ,
	.i_addr(data_addr) ,
	.i_write_data(write_data) ,
	.o_read_data(read_data)
	);
		
	riscv_singlecycle u_risc(
	.i_clk(i_clk) , .i_rst_n(i_rst_n) ,
    .i_instr(instruction) ,
	.i_read_data(read_data) ,
	.o_pc (pc),
	.o_write_data(write_data) ,
	.o_data_addr(data_addr) , 
	.o_mem_write(mem_write) );

endmodule