// Author: 0711282 邱頎霖

module Simple_Single_CPU(
    clk_i,
    rst_i
    );

// Input port
input clk_i;
input rst_i;

wire [32-1:0] pc_in;
wire [32-1:0] pc_out;
wire [32-1:0] pc_plus_4;
wire [32-1:0] instruction;
wire RegDst;
wire ALUSrc;
wire RegWrite;
wire branch;
wire [3-1:0]  ALUOp;
wire [5-1:0]  number_WriteReg_fromMux;
//wire [32-1:0] Write_data;
wire [32-1:0] RS_data;
wire [32-1:0] RT_data;
wire [32-1:0] RD_data;
wire [4-1:0] AlU_control;
wire [32-1:0] data_after_se;
wire [32-1:0] data_into_ALU_after_mux;
wire zero_alu;
wire [32-1:0] data_after_left2;
wire [32-1:0] branch_target_addr;

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i (rst_i),
    .pc_in_i(pc_in),
    .pc_out_o(pc_out)
    );

Adder Adder1(
    .src1_i(pc_out),
    .src2_i(32'd4),    //+4 and 32bit
    .sum_o(pc_plus_4)
    );

Instr_Memory IM(
    .pc_addr_i(pc_out),
    .instr_o(instruction)
    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instruction[20:16]),
    .data1_i(instruction[15:11]),
    .select_i(RegDst),
    .data_o(number_WriteReg_fromMux) 
    );

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i) ,
    .RSaddr_i(instruction[25:21]) ,
    .RTaddr_i(instruction[20:16]) ,
    .RDaddr_i(number_WriteReg_fromMux) , //from mux before
    .RDdata_i(RD_data)  ,
    .RegWrite_i (RegWrite),
    .RSdata_o(RS_data) ,   //output
    .RTdata_o(RT_data)	   //output	
    );

Decoder Decoder(
    .instr_op_i(instruction[31:26]),
    .RegWrite_o(RegWrite),
    .ALU_op_o(ALUOp),
    .ALUSrc_o(ALUSrc),
    .RegDst_o(RegDst),
    .Branch_o(branch)
    );

ALU_Ctrl AC(
    .funct_i(instruction[5:0]),
    .ALUOp_i(ALUOp),
    .ALUCtrl_o(AlU_control)
    );

Sign_Extend SE(
    .data_i(instruction[15:0]),
    .data_o(data_after_se),
	.ctrl_i(AlU_control)
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(RT_data), //RT's data
    .data1_i(data_after_se), //data after se
    .select_i(ALUSrc),
    .data_o(data_into_ALU_after_mux)
    );

ALU ALU(
    .src1_i(RS_data),
    .src2_i(data_into_ALU_after_mux),
    .ctrl_i(AlU_control),
    .result_o(RD_data),
    .zero_o(zero_alu),
	.shamt_i(instruction[10:6]) //new! for get shamt in R-type
    );

Adder Adder2(
    .src1_i(pc_plus_4),
    .src2_i(data_after_left2),
    .sum_o(branch_target_addr)
    );

Shift_Left_Two_32 Shifter(
    .data_i(data_after_se),
    .data_o(data_after_left2)
    );
//choose next instr'address

MUX_2to1 #(.size(32)) Mux_PC_Source(
    .data0_i(pc_plus_4),
    .data1_i(branch_target_addr),
    .select_i(zero_alu & branch),
    .data_o(pc_in)
    );

endmodule
