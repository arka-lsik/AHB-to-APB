module APB_Interface(Pwrite,Pselx,Penable,Paddr,Pwdata,Pwriteout,Pselxout,Penableout,Paddrout,Pwdataout,Prdata);

input Pwrite,Penable;
input [2:0] Pselx;
input [31:0] Pwdata,Paddr;

output Pwriteout,Penableout;
output [2:0] Pselxout;
output [31:0] Pwdataout,Paddrout;
output reg [31:0] Prdata;

assign Penableout=Penable;
assign Pselxout=Pselx;
assign Pwriteout=Pwrite;
assign Paddrout=Paddr;
assign Pwdataout=Pwdata;

always @(*)
 begin
  if (~Pwrite && Penable)
   Prdata = 8'd25;
   //Prdata=($random)%256;
  else
   Prdata=0;
 end

endmodule
