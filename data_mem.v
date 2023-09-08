module data_mem (
	input wire i_clk , i_rst_n ,
	input wire i_we ,
	input wire  [31:0] i_addr , i_write_data ,
	output wire [31:0] o_read_data
	);
		
	reg [31:0] mem [255:0] ;

	integer i ;

	always @(posedge i_clk or negedge i_rst_n ) begin
		if (~i_rst_n) begin
			for(i=0;i<256;i=i+1) begin 
				mem[i] <= 0 ;
			end
		end
		else if (i_we) begin
			mem[i_addr[31:0]] <= i_write_data;
		end
	end

	assign o_read_data = mem[i_addr[31:0]];

endmodule