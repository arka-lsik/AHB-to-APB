module ABP_controller_tb();
reg Hclk,Hresetin,Hwrite,Hwritereg,valid;
reg [31:0] Haddr, Hwdata, Prdata, Hwdata1,Hwdata2,Haddr1,Haddr2;
reg [2:0]tempselx;
wire Penable,Pwrite,Hreadyout;
wire [31:0] Paddr,Pwdata;
wire [2:0] Pselx;

APB_controller DUT(.Hclk(Hclk),.Hresetin(Hresetin),.Hreadyout(Hreadyout),.Hwrite(Hwrite),.Hwritereg(Hwritereg),.valid(valid),.Haddr(Haddr),.Haddr1(Haddr1),.Haddr2(Haddr2),.Hwdata1(Hwdata1),.Hwdata2(Hwdata2),.Hwdata(Hwdata),.Prdata(Prdata),.tempselx(tempselx),
                     .Penable(Penabe),.Pwrite(Pwrite),.Paddr(Paddr),.Pwdata(Pwdata),.Pselx(Psel));
        initial
        begin
        Hclk = 1'b0;
        forever #10 Hclk = ~Hclk;
        end 
        
        task reset();
        begin
        @(negedge Hclk)
         Hresetin = 1'b0;
        @(negedge Hclk)
         Hresetin = 1'b1;
       end 
       endtask 
       
       initial
       begin
        reset;
        Hwrite = 1'b1; 
        valid= 1'b1; 
        Haddr = 32'h8100_0000;
        Haddr1 = 32'h8200_0000;
        Haddr2 = 32'h8300_0000;
        Hwdata = 'd32;
        Hwdata1 = 'd45;
        Hwdata2 = 'd52;
        Prdata = 'd543;
        Hwritereg = 1'b1;
        tempselx = 3'b001;
        
        #100
          Hwrite = 1'b0;
          valid=1'b0;
          end          
endmodule
