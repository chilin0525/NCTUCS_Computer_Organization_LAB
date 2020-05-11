// 0711282 邱頎霖
module Onebit_Adder(a,b,carry_in,carry_out,result);

	input a,b,carry_in;
	output carry_out,result;

	assign {carry_out,result} = a+b+carry_in;
	
endmodule
