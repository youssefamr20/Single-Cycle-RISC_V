module reg_file (
	input wire i_clk ,
	input wire i_rst_n ,
	input wire [4:0] i_addr1 , i_addr2 , i_addr3 ,
	input wire [31:0] i_wd3 ,
	input wire i_we3 ,
	output wire [31:0] o_rd1, o_rd2 
	);
	
	[31:0] registers [31:0] ;
	integer i ;

	always @(posedge i_clk or negedge i_rst_n) begin
		if (~i_rst_n) begin 			 // asynchronous reset
			for (i=0;i<32;i=i+1) begin 
				registers[i] <= 32'b0;
			end
		end
		else if (i_we3) 
			begin
				register[i_addr3] <= i_wd3 ; 
			end
	end

	// combinational read
	assign o_rd1 = (i_addr1==5'b0) ? 0 : registers[i_addr1] ;
	assign o_rd2 = (i_addr2==5'b0) ? 0 : registers[i_addr2] ;

endmodule