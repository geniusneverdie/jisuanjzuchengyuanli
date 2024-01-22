`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: exe.v
//   > ����  :������CPU��ִ��ģ��
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module exe(                         // ִ�м�
    input              EXE_valid,   // ִ�м���Ч�ź�
    input      [149:0] ID_EXE_bus_r,// ID->EXE����
    output             EXE_over,    // EXEģ��ִ�����
    output     [105:0] EXE_MEM_bus, // EXE->MEM����
    
    //չʾPC
    output     [ 31:0] EXE_pc
);
//-----{ID->EXE����}begin
    //EXE��Ҫ�õ�����Ϣ
    //ALU����Դ�������Ϳ����ź�
    wire [11:0] alu_control;
    wire [31:0] alu_operand1;
    wire [31:0] alu_operand2;

    //�ô���Ҫ�õ���load/store��Ϣ
    wire [3:0] mem_control;  //MEM��Ҫʹ�õĿ����ź�
    wire [31:0] store_data;  //store�����Ĵ������
                          
    //д����Ҫ�õ�����Ϣ
    wire       rf_wen;    //д�صļĴ���дʹ��
    wire [4:0] rf_wdest;  //д�ص�Ŀ�ļĴ���
    
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
//-----{ID->EXE����}end

//-----{ALU}begin
    wire [31:0] alu_result;

    alu alu_module(
        .alu_control  (alu_control ),  // I, 12, ALU�����ź�
        .alu_src1     (alu_operand1),  // I, 32, ALU������1
        .alu_src2     (alu_operand2),  // I, 32, ALU������2
        .alu_result   (alu_result  )   // O, 32, ALU���
    );
//-----{ALU}end

//-----{EXEִ�����}begin
    //�����Ƕ����ڵģ��������������
    //������ALU���㶼����һ�������
    //��EXEģ��һ�ľ���������в���
    //��EXE_valid����EXE_over�ź�
    assign EXE_over = EXE_valid;
//-----{EXEִ�����}end

//-----{EXE->MEM����}begin
    assign EXE_MEM_bus = {mem_control,store_data,   //load/store��Ϣ��store����
                          alu_result,               //alu������
                          rf_wen,rf_wdest,          // WB��Ҫʹ�õ��ź�
                          pc};                      // PC
//-----{EXE->MEM����}end

//-----{չʾEXEģ���PCֵ}begin
    assign EXE_pc = pc;
//-----{չʾEXEģ���PCֵ}end
endmodule
