module alu (
	input wire [31:0] i_srca , i_srcb ,
	input wire [2:0] i_alu_ctrl ,
	output reg [31:0] o_alu_result ,
	output wire o_zero 
	);
	
	assign o_zero =  ~|o_alu_result ;

	always@(*) begin 
		case(i_alu_ctrl) 
			3'b000: o_alu_result =  i_srca + i_srcb ;
			3'b001: o_alu_result =  i_srca - i_srcb ;
			3'b010: o_alu_result =  i_srca & i_srcb ; //and
			3'b011: o_alu_result =  i_srca | i_srcb ; //or
			3'b101: o_alu_result =  ( i_srca < i_srcb ) ? 1:0;
			default: o_alu_result = 'bxxx ;
		endcase
	end

endmodule