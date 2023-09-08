module flip_flop #( parameter N= 4 )
	(
	input wire clk ,rst_n ,
	input wire [N-1:0] din ,
	output reg [N-1:0] dout 
	);

	always@(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin 
			dout <= 'b0 ;
		end 
		else begin 
			dout <= din ;
		end 
	end

endmodule