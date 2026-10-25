// Testbench for the dataflow model
module tb_nurse_alert_dataflow;
    reg  S1, S2, S3, S4, S5, S6, S7, S8, S9, S10;
    wire V, A3, A2, A1, A0;

    nurse_alert_dataflow uut (
        .S1(S1), .S2(S2), .S3(S3), .S4(S4), .S5(S5),
        .S6(S6), .S7(S7), .S8(S8), .S9(S9), .S10(S10),
        .V(V), .A3(A3), .A2(A2), .A1(A1), .A0(A0)
    );

    initial begin
        {S10,S9,S8,S7,S6,S5,S4,S3,S2,S1} = 10'b0000000000; #10; // idle      -> V=0, 0000
        {S10,S9,S8,S7,S6,S5,S4,S3,S2,S1} = 10'b0000000001; #10; // ward 1    -> V=1, 0001
        {S10,S9,S8,S7,S6,S5,S4,S3,S2,S1} = 10'b0000000011; #10; // ward 1+2  -> ward 2 wins: 0010
        {S10,S9,S8,S7,S6,S5,S4,S3,S2,S1} = 10'b0001000000; #10; // ward 7    -> 0111
        {S10,S9,S8,S7,S6,S5,S4,S3,S2,S1} = 10'b0010000000; #10; // ward 8    -> 1000
        {S10,S9,S8,S7,S6,S5,S4,S3,S2,S1} = 10'b1000000001; #10; // ward 1+10 -> ward 10 wins: 1010
        $finish;
    end

    initial
        $monitor("t=%0t V=%b A3A2A1A0=%b%b%b%b", $time, V, A3, A2, A1, A0);
endmodule
