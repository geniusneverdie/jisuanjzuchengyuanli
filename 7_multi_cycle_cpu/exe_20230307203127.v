`timescale 1ns / 1ps
//*************************************************************************
//   > 文件名: exe.v
//   > 描述  :多周期CPU的执行模块
//   > 作者  : LOONGSON
//   > 日期  : 2016-04-14
//*************************************************************************
module exe(                         // 执行级
    input              EXE_valid,   // 执行级有效信号
    input      [149:0] ID_EXE_bus_r,// ID->EXE总线
    output             EXE_over,    // EXE模块执行完成
    output     [105:0] EXE_MEM_bus, // EXE->MEM总线
    
    //展示PC
    output     [ 31:0] EXE_pc
);
//-----{ID->EXE总线}begin
    //EXE需要用到的信息
    //ALU两个源操作数和控制信号
    wire [11:0] alu_control;
    wire [31:0] alu_operand1;
    wire [31:0] alu_operand2;

    //访存需要用到的load/store信息
    wire [3:0] mem_control;  //MEM需要使用的控制信号
    wire [31:0] store_data;  //store操作的存的数据
                          
    //写回需要用到的信息
    wire       rf_wen;    //写回的寄存器写使能
    wire [4:0] rf_wdest;  //写回的目的寄存器
    
    //pc
    wire [31:0] pc;
    assign {alu_control,
            alu_operand1,
            alu_operand2,
            mem_control,
            store_data,
            rf_wen,
            rf_wdest,
            pc          } = ID_EXE_bus_r;
//-----{ID->EXE总线}end

//-----{ALU}begin
    wire [31:0] alu_result;

    alu alu_module(
        .alu_control  (alu_control ),  // I, 12, ALU控制信号
        .alu_src1     (alu_operand1),  // I, 32, ALU操作数1
        .alu_src2     (alu_operand2),  // I, 32, ALU操作数2
        .alu_result   (alu_result  )   // O, 32, ALU结果
    );
//-----{ALU}end

//-----{EXE执行完成}begin
    //由于是多周期的，不存在数据相关
    //且所有ALU运算都可在一拍内完成
    //故EXE模块一拍就能完成所有操作
    //故EXE_valid即是EXE_over信号
    assign EXE_over = EXE_valid;
//-----{EXE执行完成}end

//-----{EXE->MEM总线}begin
    assign EXE_MEM_bus = {mem_control,store_data,   //load/store信息和store数据
                          alu_result,               //alu运算结果
                          rf_wen,rf_wdest,          // WB需要使用的信号
                          pc};                      // PC
//-----{EXE->MEM总线}end

//-----{展示EXE模块的PC值}begin
    assign EXE_pc = pc;
//-----{展示EXE模块的PC值}end
endmodule
