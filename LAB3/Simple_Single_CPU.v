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

wire [32-1:0] result_branch_target_addr_or_pc_plus_4;

wire jr;
wire mem_write;
wire mem_read;
wire mem_reg;
wire jump;
wire [32-1:0] result_mux_mem_alu;
wire [32-1:0] result_mem;
wire [32-1:0] branch_or_pcplus4;
wire [32-1:0] jmp_address;
wire [32-1:0] tmp_jmp_address;
wire [5-1:0] RT;
wire [2-1:0] branch_type;
wire branch_type_or_not;
wire [32-1:0] branch_address;
wire jal;
wire [5-1:0] tmp_number_WriteReg_fromMux;
wire [32-1:0] write_data2;
wire [32-1:0] jump_address_2;


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

/*
MUX_2to1 #(.size(5)) Mux_RT_or_zero(
    .data0_i(instruction[20:16]),
    .data1_i(5'b0), // for blez bgtz 讓rs減 "0"
    .select_i(regdst2),
    .data_o(RT) 
    );
*/
MUX_2to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instruction[20:16]),
    .data1_i(instruction[15:11]),
    .select_i(RegDst),
    .data_o(tmp_number_WriteReg_fromMux) 
    );

MUX_2to1 #(.size(5)) Mux_Write_Reg_or_jal(
    .data0_i(tmp_number_WriteReg_fromMux),
    .data1_i(5'd31),
    .select_i(jal),
    .data_o(number_WriteReg_fromMux) 
    );

MUX_2to1 #(.size(32)) write_data(
    //.data0_i(RD_data),
	.data0_i(result_mux_mem_alu),  
	//.data0_i(result_mem),
	.data1_i(pc_plus_4),
    .select_i(jal),
    .data_o(write_data2) 
    );

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i) ,
    .RSaddr_i(instruction[25:21]) ,
    .RTaddr_i(instruction[20:16]) ,
    .RDaddr_i(number_WriteReg_fromMux) , //from mux before
	//RDdata_i(RD_data),    
	.RDdata_i(write_data2),	
	//.RDdata_i(result_from_mem),
	//.RDdata_i(result_from_mux_mem_alu) ,
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
    .Branch_o(branch),
	.mem_write_o(mem_write),
	.mem_read_o(mem_read),
	.mem_to_reg(mem_reg),
	.jump_o(jump),
	.branch_type_o(branch_type),
	.jal_o(jal)
    );

ALU_Ctrl AC(
    .funct_i(instruction[5:0]),
    .ALUOp_i(ALUOp),
    .ALUCtrl_o(AlU_control),
	.jr_o(jr)
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

Branch_type branchtype(
	.Branch_type_i(branch_type),
	.Zero_i(zero_alu),
	.ALU_result_i(RD_data[31]),
	.branch_type_result_o(branch_type_or_not)
	);
/*
always@(*)begin
	$display("here:%d %d",branch_type_or_not,branch);
end
*/

MUX_2to1 #(.size(32)) Mux_PC_Source(
    .data0_i(pc_plus_4),
    .data1_i(branch_target_addr),
    .select_i(branch_type_or_not & branch),
    //.data_o(result_branch_target_addr_or_pc_plus_4)
	.data_o(branch_address)
	//.data_o(branch_or_pcplus4)
    );

wire [32-1:0] tmp_jump_address;
wire [32-1:0] jump_address;
wire [32-1:0] tmp;
assign tmp = {6'b0,instruction[25:0]};


Shift_Left_Two_32 Jump_address(
    .data_i(tmp),
    .data_o(tmp_jump_address)
    );


assign jump_address = {pc_plus_4[31:28],tmp_jump_address[27:0]};
MUX_2to1 #(.size(32)) Mux_jump(
    .data0_i(branch_address),
    .data1_i(jump_address),
    .select_i(jump),
	.data_o(jump_address_2)
    );



//assign jr_or_out = (instruction[5:0]==6'b001000 && instruction[31:26]==6'b000000)?1'b1:1'b0;


MUX_2to1 #(.size(32)) Jrr(
    .data0_i(jump_address_2),
    .data1_i(RS_data),
	//.data0_i(RS_data),
	//.data1_i(result_branch_target_addr_or_pc_plus_4),
    .select_i(jr),
    .data_o(pc_in)
    );



Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(RD_data),
	.data_i(RT_data),
	.MemRead_i(mem_read),
	.MemWrite_i(mem_write),
	.data_o(result_mem)	
	);


MUX_2to1 #(.size(32)) Mux_mem_or_alu(
    .data0_i(RD_data),
    .data1_i(result_mem),
    .select_i(mem_reg),
    .data_o(result_mux_mem_alu)
    );

/*
assign tmp_jmp_address={{6{1'b0}},instrction[25:0]}; //add: pc 4bit+26bit

Shift_Left_Two_32 shift_jmp_address(
	.data_i(tmp_jmp_address);
	.data_o(jmp_address);
	);
*/


endmodule






















