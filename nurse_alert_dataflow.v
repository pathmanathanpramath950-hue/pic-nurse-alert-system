// 10-ward priority encoder with display enable - DATAFLOW model
module nurse_alert_dataflow (
    input  wire S1, S2, S3, S4, S5, S6, S7, S8, S9, S10,
    output wire V,
    output wire A3, A2, A1, A0
);
    assign V = S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 | S10;

    wire P1  = S1 & ~S2 & ~S3 & ~S4 & ~S5 & ~S6 & ~S7 & ~S8 & ~S9 & ~S10;
    wire P2  = S2 & ~S3 & ~S4 & ~S5 & ~S6 & ~S7 & ~S8 & ~S9 & ~S10;
    wire P3  = S3 & ~S4 & ~S5 & ~S6 & ~S7 & ~S8 & ~S9 & ~S10;
    wire P4  = S4 & ~S5 & ~S6 & ~S7 & ~S8 & ~S9 & ~S10;
    wire P5  = S5 & ~S6 & ~S7 & ~S8 & ~S9 & ~S10;
    wire P6  = S6 & ~S7 & ~S8 & ~S9 & ~S10;
    wire P7  = S7 & ~S8 & ~S9 & ~S10;
    wire P8  = S8 & ~S9 & ~S10;
    wire P9  = S9 & ~S10;
    wire P10 = S10;

    assign A3 = P8 | P9 | P10;
    assign A2 = P4 | P5 | P6 | P7;
    assign A1 = P2 | P3 | P6 | P7 | P10;
    assign A0 = P1 | P3 | P5 | P7 | P9;
endmodule
