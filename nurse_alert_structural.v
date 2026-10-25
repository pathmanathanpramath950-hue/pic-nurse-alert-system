// 10-ward priority encoder with display enable - STRUCTURAL model
// Ward 10 (S10) has the highest priority. Output A3..A0 = BCD ward number.
module nurse_alert_structural (
    input  wire S1, S2, S3, S4, S5, S6, S7, S8, S9, S10,
    output wire V,
    output wire A3, A2, A1, A0
);
    // Complements needed for exclusion terms (S1 never needs complementing)
    wire s2_n, s3_n, s4_n, s5_n, s6_n, s7_n, s8_n, s9_n, s10_n;
    not (s2_n, S2);
    not (s3_n, S3);
    not (s4_n, S4);
    not (s5_n, S5);
    not (s6_n, S6);
    not (s7_n, S7);
    not (s8_n, S8);
    not (s9_n, S9);
    not (s10_n, S10);

    // Display Enable
    or (V, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10);

    // Priority terms P1-P10 (each true when that ward is the top-priority active ward)
    wire P1, P2, P3, P4, P5, P6, P7, P8, P9, P10;
    and (P1, S1, s2_n, s3_n, s4_n, s5_n, s6_n, s7_n, s8_n, s9_n, s10_n);
    and (P2, S2, s3_n, s4_n, s5_n, s6_n, s7_n, s8_n, s9_n, s10_n);
    and (P3, S3, s4_n, s5_n, s6_n, s7_n, s8_n, s9_n, s10_n);
    and (P4, S4, s5_n, s6_n, s7_n, s8_n, s9_n, s10_n);
    and (P5, S5, s6_n, s7_n, s8_n, s9_n, s10_n);
    and (P6, S6, s7_n, s8_n, s9_n, s10_n);
    and (P7, S7, s8_n, s9_n, s10_n);
    and (P8, S8, s9_n, s10_n);
    and (P9, S9, s10_n);
    buf (P10, S10);   // highest priority - no exclusion terms needed

    // BCD output bits
    or (A3, P8, P9, P10);
    or (A2, P4, P5, P6, P7);
    or (A1, P2, P3, P6, P7, P10);
    or (A0, P1, P3, P5, P7, P9);
endmodule
