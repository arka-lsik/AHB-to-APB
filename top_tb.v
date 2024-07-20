module top_tb();
    reg Hclk, Hresetin;
    wire [31:0] Haddr, Hwdata, Hrdata, Paddr, Pwdata, Prdata, Paddrout, Pwdataout;
    wire [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;
    wire [1:0] Htrans, Hresp;
    wire [2:0] tempselx, Pselx, Pselxout;
    wire Hreadyout, Hwrite, Hreadyin, Hwritereg, Penable, Pwrite, Pwriteout, Penableout;

    AHB_Master ahb(Hclk, Hresetin, Hresp, Hrdata, Hwrite, Hreadyin, Hreadyout, Htrans, Hwdata, Haddr);
    Bridge_Top bridge(Hclk, Hresetin, Hwrite, Hreadyin, Hreadyout, Hwdata, Haddr, Htrans, Prdata, Penable, Pwrite, Pselx, Paddr, Pwdata, Hreadyout, Hresp, Hrdata);
    APB_Interface apb(Pwrite, Pselx, Penable, Paddr, Pwdata, Pwriteout, Pselxout, Penableout, Paddrout, Pwdataout, Prdata);

    initial begin
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

    initial begin
        reset;
        //ahb.single_write();
         ahb.burst_write();
      //ahb.wrap_write();
         
    end
endmodule
