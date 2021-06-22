module adder_32bits(a,b,ci,s,co);
input [31:0]a;
input [31:0]b;
input ci;
output [31:0]s;
output co;

wire [31:0] a,b,s;
wire [7:1] coo;


adder_4 adder_4_1(a[3:0],b[3:0],ci,s[3:0],coo[1]);
add_sel add_sel1(coo[1],a[7:4],b[7:4],coo[2],s[7:4]);
add_sel add_sel2(coo[2],a[11:8],b[11:8],coo[3],s[11:8]);
add_sel add_sel3(coo[3],a[15:12],b[15:12],coo[4],s[15:12]);
add_sel add_sel4(coo[4],a[19:16],b[19:16],coo[5],s[19:16]);
add_sel add_sel5(coo[5],a[23:20],b[23:20],coo[6],s[23:20]);
add_sel add_sel6(coo[6],a[27:24],b[27:24],coo[7],s[27:24]);
add_sel add_sel7(coo[7],a[31:28],b[31:28],co,s[31:28]);

endmodule


module adder_4(a,b,ci,s,co);
input [3:0]a,b;
input ci;
output co;
output [3:0]s;
f_adder f0(a[0],b[0],ci,s[0],ci1);
f_adder f1(a[1],b[1],ci1,s[1],ci2);
f_adder f2(a[2],b[2],ci2,s[2],ci3);
f_adder f3(a[3],b[3],ci3,s[3],co);
endmodule

module f_adder(ain,bin,cin,sum,cout);//1????//
output sum,cout;
input ain,bin,cin;
wire d,e,f;
h_adder h1(ain,bin,e,d);
h_adder h2(e,cin,sum,f);
or(cout,d,f);
endmodule

module h_adder(a,b,so,co);//???//
input a,b;
output so,co;
assign so=a^b;
assign co=a&b;
endmodule


module add4_head ( a, b, ci, s, pp, gg);
input[3:0]    a;
input[3:0]    b;
input         ci;
output[3:0]     s;
output          pp;
output          gg;
wire[3:0]       p;
wire[3:0]       g;
wire[2:0]       c;

assign p[0] = a[0] ^ b[0];
assign p[1] = a[1] ^ b[1];
assign p[2] = a[2] ^ b[2];
assign p[3] = a[3] ^ b[3];
assign g[0] = a[0] & b[0];
assign g[1] = a[1] & b[1];
assign g[2] = a[2] & b[2];
assign g[3] = a[3] & b[3];
assign c[0] = (p[0] & ci) | g[0];
assign c[1] = (p[1] & c[0]) | g[1];
assign c[2] = (p[2] & c[1]) | g[2];
assign pp = p[3] & p[2] & p[1] & p[0];
assign gg  = g[3] | (p[3] & (g[2] | p[2] & (g[1] | p[1] & g[0])));
assign s[0] = p[0] ^ ci;
assign s[1] = p[1] ^ c[0];
assign s[2] = p[2] ^ c[1];
assign s[3] = p[3] ^ c[2];

endmodule


module add_sel(cii,a,b,coo,s);
  input [3:0]a,b;
  input cii;
  output [3:0]s;
  output coo;
  
  wire [3:0]s1,s2;
  
  adder_4 adder_4_1(a,b,1,s1,co1);
  adder_4 adder_4_2(a,b,0,s2,co2);
  mux_2to1_1 mux_2to1_1(s1,s2,cii,s);
  mux_2to1_2 mux_2to1_2(co1,co2,cii,coo);
  
endmodule


module mux_2to1_1(s1,s2,ci,out);

input [3:0]s1;
input [3:0]s2;
input ci;
output [3:0]out;
   
assign out=ci?s1:s2;

endmodule



module mux_2to1_2(s1,s2,ci,out);

input s1;
input s2;
input ci;
output out;
assign out=ci?s1:s2;

endmodule