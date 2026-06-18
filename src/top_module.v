// RISC-V Electronic Dice System for Basys 3
// Requires: picorv32.v (place it in the same Vivado project)
// Memory map:
// 0x00000000-0x00000FFF : Instruction Memory (firmware.hex)
// 0x00001000-0x00001FFF : Data Memory
// 0x40000000            : Button input register, bit[0] = BTNC
// 0x40000004            : Seven-seg output register, bit[2:0] = dice 1~6

module top_module(
    input  wire        clk,      // Basys 3 100 MHz clock, W5
    input  wire        btnC,     // dice button
    input  wire        btnU,     // reset button, active high on board
    output wire [6:0]  seg,      // active-low segment signals
    output wire [3:0]  an        // active-low anode signals
);
    wire resetn = ~btnU;         // PicoRV32 resetn is active-low

    wire        mem_valid;
    wire        mem_instr;
    wire        mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    reg  [31:0] mem_rdata;

    reg [31:0] imem [0:1023];    // 4 KB instruction memory
    reg [31:0] dmem [0:1023];    // 4 KB data memory

    reg [2:0] dice_reg;

    initial begin
        dice_reg = 3'd0;
        $readmemh("firmware32.hex", imem);
    end

    // PicoRV32 native memory interface
    picorv32 #(
        .ENABLE_COUNTERS(0),
        .ENABLE_COUNTERS64(0),
        .ENABLE_MUL(0),
        .ENABLE_DIV(0),
        .PROGADDR_RESET(32'h0000_0000),
        .STACKADDR(32'h0000_2000)
    ) cpu (
        .clk(clk),
        .resetn(resetn),
        .mem_valid(mem_valid),
        .mem_instr(mem_instr),
        .mem_ready(mem_ready),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),
        .irq(32'b0)
    );

    assign mem_ready = mem_valid; // single-cycle response for simple memory/I/O

    wire access_imem   = (mem_addr[31:12] == 20'h00000);
    wire access_dmem   = (mem_addr[31:12] == 20'h00001);
    wire access_button = (mem_addr == 32'h4000_0000);
    wire access_seg    = (mem_addr == 32'h4000_0004);

    wire [9:0] word_index = mem_addr[11:2];

    // Write path
    always @(posedge clk) begin
        if (!resetn) begin
            dice_reg <= 3'd0;
        end else if (mem_valid && |mem_wstrb) begin
            if (access_dmem) begin
                if (mem_wstrb[0]) dmem[word_index][7:0]   <= mem_wdata[7:0];
                if (mem_wstrb[1]) dmem[word_index][15:8]  <= mem_wdata[15:8];
                if (mem_wstrb[2]) dmem[word_index][23:16] <= mem_wdata[23:16];
                if (mem_wstrb[3]) dmem[word_index][31:24] <= mem_wdata[31:24];
            end else if (access_seg) begin
                dice_reg <= mem_wdata[2:0];
            end
        end
    end

    // Read path
    always @(*) begin
        if (access_imem) begin
            mem_rdata = imem[word_index];
        end else if (access_dmem) begin
            mem_rdata = dmem[word_index];
        end else if (access_button) begin
            mem_rdata = {31'b0, btnC};
        end else if (access_seg) begin
            mem_rdata = {29'b0, dice_reg};
        end else begin
            mem_rdata = 32'h0000_0000;
        end
    end

    seven_seg_driver u_seven_seg_driver(
        .dice(dice_reg),
        .seg(seg),
        .an(an)
    );
endmodule
