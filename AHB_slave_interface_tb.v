module tb_AHB_slave_interface;

  // Inputs
  reg Hclk;
  reg Hresetin;
  reg Hwrite;
  reg Hreadyin;
  reg [1:0] Htrans;
  reg [31:0] Haddr;
  reg [31:0] Hwdata;
  reg [31:0] Prdata;

  // Outputs
  wire valid;
  wire [31:0] Haddr1;
  wire [31:0] Haddr2;
  wire [31:0] Hwdata1;
  wire [31:0] Hwdata2;
  wire Hwritereg;
  wire [2:0] tempselx;
  wire [31:0] Hrdata;
  wire [1:0] Hresp;

  // Instantiate the Unit Under Test (UUT)
  AHB_slave_interface DUT (
    .Hclk(Hclk), 
    .Hresetin(Hresetin), 
    .Hwrite(Hwrite), 
    .Hreadyin(Hreadyin), 
    .Htrans(Htrans), 
    .Haddr(Haddr), 
    .Hwdata(Hwdata), 
    .valid(valid), 
    .Haddr1(Haddr1), 
    .Haddr2(Haddr2), 
    .Hwdata1(Hwdata1), 
    .Hwdata2(Hwdata2), 
    .Hwritereg(Hwritereg), 
    .tempselx(tempselx), 
    .Hrdata(Hrdata), 
    .Hresp(Hresp), 
    .Prdata(Prdata)
  );

initial 
begin
Hclk = 1'b0;
forever #5 Hclk =~Hclk;
end


task reset;
begin
@(negedge Hclk)
Hresetin = 1'b0;
@(negedge Hclk)
Hresetin = 1'b1;
end
endtask

task in(input p,q);
begin
@(negedge Hclk)
Hwrite = p;
Hreadyin = q;
end
endtask

task inp(input [31:0] a,b, [1:0] c);
begin
@(negedge Hclk)
Haddr = a;
Hwdata = b;
Htrans = c;
end
endtask


initial
begin
reset;
in(1'b1, 1'b1);

inp(32'h8000_1010, 32'h536, 2'b10);
#20;
inp(32'h8400_1010, 32'hABD, 2'b11);
#20;
inp(32'h8800_1010, 32'h123, 2'b10);
#20;
inp(32'h8C00_1010, 32'hDEF, 2'b11);
#20;

$stop;
end


endmodule
