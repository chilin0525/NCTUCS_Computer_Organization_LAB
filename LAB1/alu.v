// 0711282 邱頎霖
`timescale 1ns/1ps

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
	   bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input  [4-1:0]  ALU_control;
input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

wire [32-1:0]result_rst;
wire cout_rst;
wire zero_rst;
wire overflow_rst;

wire [32-1:0] temp_result;
wire [32-1:0] temp_carry_out; //[i]'s carryout->[i+1] carry_in
wire  		  temp2_answer;
wire temp_zero;
wire [32-1:0] bonus_temp;
wire [32-1:0] equal_temp;

//----------------------------------------------------------------------------------------------------------------------------------------
// onebit_alu:(a,b,carryin,alucontrol,result.carryout)
Onebit_Alu positone_0(src1[0],src2[0],ALU_control[2],ALU_control,temp_result[0],temp_carry_out[0],1'b1,bonus_temp[0],1'b1,equal_temp[0]);
Onebit_Alu positone_1(src1[1],src2[1],temp_carry_out[0],ALU_control,temp_result[1],temp_carry_out[1],bonus_temp[0],bonus_temp[1],equal_temp[0],equal_temp[1]);
Onebit_Alu positone_2(src1[2],src2[2],temp_carry_out[1],ALU_control,temp_result[2],temp_carry_out[2],bonus_temp[1],bonus_temp[2],equal_temp[1],equal_temp[2]);
Onebit_Alu positone_3(src1[3],src2[3],temp_carry_out[2],ALU_control,temp_result[3],temp_carry_out[3],bonus_temp[2],bonus_temp[3],equal_temp[2],equal_temp[3]);
Onebit_Alu positone_4(src1[4],src2[4],temp_carry_out[3],ALU_control,temp_result[4],temp_carry_out[4],bonus_temp[3],bonus_temp[4],equal_temp[3],equal_temp[4]);
Onebit_Alu positone_5(src1[5],src2[5],temp_carry_out[4],ALU_control,temp_result[5],temp_carry_out[5],bonus_temp[4],bonus_temp[5],equal_temp[4],equal_temp[5]);
Onebit_Alu positone_6(src1[6],src2[6],temp_carry_out[5],ALU_control,temp_result[6],temp_carry_out[6],bonus_temp[5],bonus_temp[6],equal_temp[5],equal_temp[6]);
Onebit_Alu positone_7(src1[7],src2[7],temp_carry_out[6],ALU_control,temp_result[7],temp_carry_out[7],bonus_temp[6],bonus_temp[7],equal_temp[6],equal_temp[7]);
Onebit_Alu positone_8(src1[8],src2[8],temp_carry_out[7],ALU_control,temp_result[8],temp_carry_out[8],bonus_temp[7],bonus_temp[8],equal_temp[7],equal_temp[8]);
Onebit_Alu positone_9(src1[9],src2[9],temp_carry_out[8],ALU_control,temp_result[9],temp_carry_out[9],bonus_temp[8],bonus_temp[9],equal_temp[8],equal_temp[9]);
Onebit_Alu positone_10(src1[10],src2[10],temp_carry_out[9],ALU_control,temp_result[10],temp_carry_out[10],bonus_temp[9],bonus_temp[10],equal_temp[9],equal_temp[10]);
Onebit_Alu positone_11(src1[11],src2[11],temp_carry_out[10],ALU_control,temp_result[11],temp_carry_out[11],bonus_temp[10],bonus_temp[11],equal_temp[10],equal_temp[11]);
Onebit_Alu positone_12(src1[12],src2[12],temp_carry_out[11],ALU_control,temp_result[12],temp_carry_out[12],bonus_temp[11],bonus_temp[12],equal_temp[11],equal_temp[12]);
Onebit_Alu positone_13(src1[13],src2[13],temp_carry_out[12],ALU_control,temp_result[13],temp_carry_out[13],bonus_temp[12],bonus_temp[13],equal_temp[12],equal_temp[13]);
Onebit_Alu positone_14(src1[14],src2[14],temp_carry_out[13],ALU_control,temp_result[14],temp_carry_out[14],bonus_temp[13],bonus_temp[14],equal_temp[13],equal_temp[14]);
Onebit_Alu positone_15(src1[15],src2[15],temp_carry_out[14],ALU_control,temp_result[15],temp_carry_out[15],bonus_temp[14],bonus_temp[15],equal_temp[14],equal_temp[15]);
Onebit_Alu positone_16(src1[16],src2[16],temp_carry_out[15],ALU_control,temp_result[16],temp_carry_out[16],bonus_temp[15],bonus_temp[16],equal_temp[15],equal_temp[16]);
Onebit_Alu positone_17(src1[17],src2[17],temp_carry_out[16],ALU_control,temp_result[17],temp_carry_out[17],bonus_temp[16],bonus_temp[17],equal_temp[16],equal_temp[17]);
Onebit_Alu positone_18(src1[18],src2[18],temp_carry_out[17],ALU_control,temp_result[18],temp_carry_out[18],bonus_temp[17],bonus_temp[18],equal_temp[17],equal_temp[18]);
Onebit_Alu positone_19(src1[19],src2[19],temp_carry_out[18],ALU_control,temp_result[19],temp_carry_out[19],bonus_temp[18],bonus_temp[19],equal_temp[18],equal_temp[19]);
Onebit_Alu positone_20(src1[20],src2[20],temp_carry_out[19],ALU_control,temp_result[20],temp_carry_out[20],bonus_temp[19],bonus_temp[20],equal_temp[19],equal_temp[20]);
Onebit_Alu positone_21(src1[21],src2[21],temp_carry_out[20],ALU_control,temp_result[21],temp_carry_out[21],bonus_temp[20],bonus_temp[21],equal_temp[20],equal_temp[21]);
Onebit_Alu positone_22(src1[22],src2[22],temp_carry_out[21],ALU_control,temp_result[22],temp_carry_out[22],bonus_temp[21],bonus_temp[22],equal_temp[21],equal_temp[22]);
Onebit_Alu positone_23(src1[23],src2[23],temp_carry_out[22],ALU_control,temp_result[23],temp_carry_out[23],bonus_temp[22],bonus_temp[23],equal_temp[22],equal_temp[23]);
Onebit_Alu positone_24(src1[24],src2[24],temp_carry_out[23],ALU_control,temp_result[24],temp_carry_out[24],bonus_temp[23],bonus_temp[24],equal_temp[23],equal_temp[24]);
Onebit_Alu positone_25(src1[25],src2[25],temp_carry_out[24],ALU_control,temp_result[25],temp_carry_out[25],bonus_temp[24],bonus_temp[25],equal_temp[24],equal_temp[25]);
Onebit_Alu positone_26(src1[26],src2[26],temp_carry_out[25],ALU_control,temp_result[26],temp_carry_out[26],bonus_temp[25],bonus_temp[26],equal_temp[25],equal_temp[26]);
Onebit_Alu positone_27(src1[27],src2[27],temp_carry_out[26],ALU_control,temp_result[27],temp_carry_out[27],bonus_temp[26],bonus_temp[27],equal_temp[26],equal_temp[27]);
Onebit_Alu positone_28(src1[28],src2[28],temp_carry_out[27],ALU_control,temp_result[28],temp_carry_out[28],bonus_temp[27],bonus_temp[28],equal_temp[27],equal_temp[28]);
Onebit_Alu positone_29(src1[29],src2[29],temp_carry_out[28],ALU_control,temp_result[29],temp_carry_out[29],bonus_temp[28],bonus_temp[29],equal_temp[28],equal_temp[29]);
Onebit_Alu positone_30(src1[30],src2[30],temp_carry_out[29],ALU_control,temp_result[30],temp_carry_out[30],bonus_temp[29],bonus_temp[30],equal_temp[29],equal_temp[30]);
Onebit_Alu positone_31(src1[31],src2[31],temp_carry_out[30],ALU_control,temp_result[31],temp_carry_out[31],bonus_temp[30],bonus_temp[31],equal_temp[30],equal_temp[31]);

// *ALU_control->"ALU" UPPER!
assign temp_zero     = (temp_result==0)?1:0;
assign temp2_answer   =   ((src1[31]==0 && src2[31]==0 && bonus_control==0 && bonus_temp[31]==0 && equal_temp[31]==0) || (bonus_control==0 && src1[31]>src2[31] && equal_temp[31]==0) || (src1[31]==1 && src2[31]==1 && bonus_control==0 && bonus_temp[31]==0 && equal_temp[31]==0)) || ((src1[31]==0 && src2[31]==0 && bonus_control==1 && bonus_temp[31]==1 && equal_temp[31]==0) || (bonus_control==1 && src1[31]<src2[31] && equal_temp[31]==0) || (src1[31]==1 && src2[31]==1 && bonus_control==1 && bonus_temp[31]==1 && equal_temp[31]==0)) || ( (bonus_control==2 && src1[31]>src2[31])||(bonus_control==2 && equal_temp[31]==1)||(src1[31]==0 && src2[31]==0 && bonus_control==2 && bonus_temp[31]==0)||(src1[31]==1 && src2[31]==1 && bonus_control==2 && bonus_temp[31]==0) ) || ((src1[31]==0 && src2[31]==0 && bonus_control==3 && bonus_temp[31]==1)||(src1[31]==1 && src2[31]==1 && bonus_control==3 && bonus_temp[31]==1)||(bonus_control==3 && src1[31]<src2[31])||(bonus_control==3 && equal_temp[31]==1) ) || (bonus_control==6 && equal_temp[31]==1) || (bonus_control==4 && equal_temp[31]==0); // see detail in report

assign overflow_rst = (temp_carry_out[31]==temp_carry_out[30]) ? 0 : 1 ; // XOR for determine overflow or not
assign cout_rst     = (ALU_control==2 || ALU_control==6)?temp_carry_out[31]:0; // add or sub need to determine carryout
assign result_rst = (ALU_control==7)?temp2_answer:temp_result;
assign zero_rst = (ALU_control==7)?(result==0):temp_zero;
//assign result=bonus_temp;
assign result=(rst_n==1)?result_rst:0;
assign zero = (rst_n==1)?zero_rst:0;
assign cout = (rst_n==1)?cout_rst:0;
assign overflow= (rst_n==1)?overflow_rst:0;
endmodule
