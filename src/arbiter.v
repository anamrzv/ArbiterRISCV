module arbiter(
    input clk,
    input reset,
    input [31:0] command_1, command_2,
    input command_valid_1, command_valid_2,
    input isBranch,
    input [31:0] firstAddr,
    input [31:0] secondAddr,
    
    output reg [31:0] data_out, // выбранная арбитром команда
    output reg [1:0]  data_out_ready,
    output reg [31:0] currentAddr
);

    parameter READY = 0;
    parameter FIRST_TRAN = 1;
    parameter SECOND_TRAN = 2;
    
    reg [2:0] current_state = READY;
    reg [2:0] next_state = FIRST_TRAN;
    
    //логика текущего состояния
    always @(posedge clk, posedge reset)
        current_state <= next_state;
    
    //логика следующего состояния
    always @(posedge clk)
        case (current_state)
            READY: begin
                if (command_valid_1) next_state <= FIRST_TRAN;
                else if (command_valid_2) next_state <= SECOND_TRAN;
                else next_state <= READY;
                end
            FIRST_TRAN: begin
                if (isBranch) next_state <= FIRST_TRAN;
                else if (command_valid_2) next_state <= SECOND_TRAN;
                else if (command_valid_1) next_state <= FIRST_TRAN;
                else next_state <= READY;
                end
            SECOND_TRAN: begin
                if (command_valid_1) next_state <= FIRST_TRAN;
                else if (command_valid_2) next_state <= SECOND_TRAN;
                else next_state <= READY;
                end  
            default: begin
                next_state <= READY;
                end
        endcase
        
    //выходная логика
    always @(posedge clk)
        case (next_state)
            FIRST_TRAN: begin
                data_out <= command_1;
                if (data_out_ready == 1)
                    data_out_ready <= 0;
                else data_out_ready <= 1;
                currentAddr <= firstAddr;
                end
            SECOND_TRAN: begin
                data_out <= command_2;
                if (data_out_ready == 2) data_out_ready <= 0;
                else data_out_ready <= 2;
                currentAddr <= secondAddr;
                end
        endcase  
        
endmodule