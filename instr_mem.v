module instr_mem (
	input wire [31:0] i_a ,
	output wire [31:0] o_rd);

	reg [31:0] ram [255:0] ; //2^8 locations

	initial 
	 	$readmemh("test.txt" , ram );

	assign o_rd = ram[i_a[31:2]] ;

endmodule