/*
 * schoolRISCV - small RISC-V CPU 
 *
 * originally based on Sarah L. Harris MIPS CPU 
 *                   & schoolMIPS project
 * 
 * Copyright(c) 2017-2020 Stanislav Zhelnio 
 *                        Aleksandr Romanov 
 */ 

// память инструкций. асинхронная память - доступ к данным в ней
// осуществляется в том же такте, когда выставлен адрес
module sm_rom
#(
    parameter SIZE = 64
)
(
    input  [31:0] a, 
    output [31:0] rd1,
    output [31:0] rd2
);
    reg [31:0] rom [SIZE - 1:0];
    
    assign rd1 = rom [a];

    reg [31:0] a_next; 
    always @* begin
        a_next = ((a << 2) + 4) >> 2; // Смещение на 4 байта для получения адреса следующей команды
    end
 
    assign rd2 = rom [a_next]; 

    initial begin
        $readmemh("D:/fs/schoolRISCV/program/03_arbiter/program.hex", rom);
    end

endmodule
