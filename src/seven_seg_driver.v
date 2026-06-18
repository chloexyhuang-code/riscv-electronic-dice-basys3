// Basys 3 seven-segment display is active-low.
// This driver only enables the rightmost digit.
module seven_seg_driver(
    input  wire [2:0] dice,
    output reg  [6:0] seg,
    output wire [3:0] an
);
    assign an = 4'b1110; // only rightmost digit is ON

    always @(*) begin
        case (dice)
            3'd1: seg = 7'b1111001; // 1
            3'd2: seg = 7'b0100100; // 2
            3'd3: seg = 7'b0110000; // 3
            3'd4: seg = 7'b0011001; // 4
            3'd5: seg = 7'b0010010; // 5
            3'd6: seg = 7'b0000010; // 6
            default: seg = 7'b1000000; // 0 after reset
        endcase
    end
endmodule
