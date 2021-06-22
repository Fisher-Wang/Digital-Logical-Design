module and2 (input a, b, output y);
    assign y = a & b;
endmodule

module and3 (input a, b, c, output y);
    assign y = a & b & c;
endmodule

module and4 (input a, b, c, d, output y);
    assign y = a & b & c & d;
endmodule

module and5 (input a, b, c, d, e, output y);
    assign y = a & b & c & d & e;
endmodule

module or2 (input a, b, output y);
    assign y = a | b;
endmodule

module or3 (input a, b, c, output y);
    assign y = a | b | c;
endmodule

module or4 (input a, b, c, d, output y);
    assign y = a | b | c | d;
endmodule

module or5 (input a, b, c, d, e, output y);
    assign y = a | b | c | d | e;
endmodule