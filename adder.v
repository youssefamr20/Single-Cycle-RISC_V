module adder(input wire [31:0] i_a , i_b,
			output wire [31:0] o_y  );

	assign o_y = i_a + i_b;

endmodule