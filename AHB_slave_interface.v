module AHB_slave_interface(Hclk,Hresetin,Hwrite,Hreadyin,Htrans,Haddr,Hwdata,
                              valid,Haddr1,Haddr2,Hwdata1,Hwdata2,Hwritereg,tempselx,Hrdata,Hresp,Prdata);
    input Hclk,Hresetin;
    input Hwrite,Hreadyin;
    input [1:0] Htrans;
    input [31:0] Haddr,Hwdata,Prdata;
    
    output reg valid;
    output reg [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2;
    output reg Hwritereg;
    output reg [2:0] tempselx;
    output [31:0] Hrdata;
    output [1:0] Hresp;
    
    ///pipeline logic for address assigning
    always @(posedge Hclk)
       begin 
         if(~Hresetin)
           begin
             Haddr1<=32'h0;
             Haddr2<=32'h0;
            end
         else
           begin
             Haddr1<= Haddr;
             Haddr2<= Haddr;
           end 
        end 
 ///Pipeline logic for data write
   always @(posedge Hclk)
     begin
       if(~Hresetin)
        begin
          Hwdata1<= 32'h0;
          Hwdata2<= 32'h0;
         end 
        else
          begin
           Hwdata1<= Hwdata;
           Hwdata2<= Hwdata;
          end 
     end 
     
  ///Pipeline logic for control logic
    always @(posedge Hclk)
     begin
       if(~Hresetin)
         Hwritereg <= 32'h0;
       else
         Hwritereg <= Hwdata;
      end
      
    ///Tempselx logic 
    always @(Haddr)
     begin
      tempselx <= 3'b000;
         if(Haddr >= 32'h8000_0000 && Haddr <= 32'h8400_0000 )
          tempselx <= 3'b001;
         else if(Haddr >= 32'h8400_0000 && Haddr <= 32'h8800_0000 )
          tempselx <= 3'b010;
         else if(Haddr >= 32'h8800_0000 && Haddr <= 32'h8C00_0000 )
          tempselx <= 3'b100;
     end 
           
  /// VAlid logic genaration
   always @(Hreadyin,Haddr,Htrans)
   begin
    if( (Haddr>=32'h8000_0000 && Haddr<=32'h8C00_0000) && (Htrans==2'b10 || Htrans==2'b11) && Hreadyin)
    valid = 1'b1;
    else
    valid = 1'b0;
   end 
                                  
  assign Hrdata = Prdata;
  assign Hresp = 2'b00;     
     
  endmodule

