module APB_controller(
    Hclk,Hresetin,valid,Haddr1,Haddr2,Hwdata1,Hwdata2,Hwritereg,tempselx,Prdata,Pwrite
   ,Pselx,Penable,Pwdata,Paddr,Hreadyout,Haddr,Hwdata,Hwrite);
   
   input Hclk,Hresetin,valid,Hwrite,Hwritereg;
   input [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2,Prdata,Hwdata,Haddr;
   input [2:0] tempselx;
   output reg Pwrite,Penable,Hreadyout;
   output reg [2:0] Pselx;
   output reg [31:0] Paddr,Pwdata;
   
   //parameter define
   parameter ST_IDLE = 3'b000;
   parameter ST_WWAIT = 3'b001;
   parameter ST_READ = 3'b010;
   parameter ST_WRITE = 3'b011;
   parameter ST_WRITEP = 3'b100;
   parameter ST_RENABLE = 3'b101;
   parameter ST_WENABLE = 3'b110;
   parameter ST_WENABLEP = 3'b111;
   
   reg [2:0] ps,ns;
 
 ///present and next state logic 
   always @(posedge Hclk)
    begin
      if(~Hresetin)
        ps<=ST_IDLE;
      else
        ps<=ns;
     end 
   
   always @(*)
    begin
      ns<=ST_IDLE;
      case(ps)
        ST_IDLE: begin 
                 if(valid && Hwrite)
                    ns = ST_WWAIT;
                 else if (valid && ~Hwrite)
                    ns = ST_READ;
                 else
                    ns = ST_IDLE;
                end
        ST_WWAIT: begin 
                 if(valid) 
                   ns = ST_WRITEP;
                  else
                   ns = ST_WRITE;
                  end 
        ST_READ: begin
                 ns = ST_RENABLE;
                 end 
        ST_WRITE: begin
                 if(~valid)
                  ns = ST_WENABLE;
                 else
                  ns = ST_WENABLEP;
                end 
        ST_WRITEP: begin
                 ns = ST_WENABLEP;
                 end 
        ST_RENABLE: begin
               if(valid && ~Hwrite)
                ns = ST_READ;
               else if(valid && Hwrite)
                ns = ST_WWAIT;
               else
                ns = ST_IDLE;
                end 
        ST_WENABLE: begin
               if (~valid)
		          ns=ST_IDLE;
		     else if (valid && Hwrite)
		          ns=ST_WWAIT;
		     else
		          ns=ST_READ;
		   end   
		 ST_WENABLEP: begin
		   if(~valid && Hwritereg)
		    ns = ST_WRITE;
		   else if(valid && Hwritereg)
		     ns = ST_WRITEP;
		   else   
		    ns = ST_READ;
		 end
		default:begin
		     ns = ST_IDLE;
		    end   
	endcase	
end	        
                                                                        
         
///ABP controler output logic
reg Pwrite_temp,Penable_temp,Hreadyout_temp;
reg [2:0] Psel_temp;
reg [31:0] Pwdata_temp,Paddr_temp;



always @(*)
  begin
   case(ps)
    ST_IDLE:begin 
            if(valid && Hwrite)
            begin
                Psel_temp=3'b000;
                Penable_temp=1'b0;
                Hreadyout_temp=1'b1;
            end    
            else if (valid && ~Hwrite)
            begin
                Paddr_temp = Haddr;
                Pwrite_temp = Hwrite;
                Psel_temp = tempselx;
                Penable_temp = 1'b0;
                Hreadyout_temp = 1'b0;
            end 
            else
            begin
                Penable_temp = 1'b0;
                Psel_temp = 3'b000;
                Hreadyout_temp = 1'b0;
            end 
      end 
   ST_WWAIT: begin
             if(valid)
             begin
               Paddr_temp = Haddr2;
               Pwrite_temp = Hwrite;
               Psel_temp = tempselx;
               Penable_temp = 1'b0;
               end
              else  
               begin  ///single write transfer
               Paddr_temp = Haddr;
               Pwrite_temp = Hwrite;
               Psel_temp = tempselx;
               Penable_temp = 1'b0;
               Hreadyout_temp = 1'b0;
               end
           end 
           
   ST_WRITE:
       begin
          if(valid)
          begin
             Paddr_temp = Haddr;
             Pwrite_temp = Hwrite;
             Hreadyout_temp = 1'b1;
             Psel_temp = tempselx;
             Penable_temp = 1'b1;
          end
      end 
   
   ST_WRITEP: begin
              Paddr_temp = Haddr1;
              Pwrite_temp = Hwrite;
              Psel_temp = tempselx;
              Penable_temp = 1'b1;
              Hreadyout_temp = 1'b1;
              end 
   ST_WENABLEP:begin
              if(valid && Hwritereg)
              begin
              Paddr_temp = Haddr2;
              Pwrite_temp = Hwrite;
              Psel_temp = tempselx;
              Penable_temp = 1'b0;
              Hreadyout_temp = 1'b0;
              end 
              else if(~valid && Hwritereg)
              begin
              Paddr_temp = Haddr;
              Pwrite_temp = Hwrite;
              Psel_temp = tempselx;
              Penable_temp = 1'b0;
              Hreadyout_temp = 1'b0;
              end 
              else
              begin
              Paddr_temp = Haddr1;
              Pwrite_temp = 1'b0;
              Psel_temp = tempselx;
              Penable_temp = 1'b0;
              Hreadyout_temp = 1'b0;
              end 
        end      
              
                            
   ST_READ: begin 
               Paddr_temp = Haddr;
               Hreadyout_temp = 1'b1;
               Penable_temp = 1'b1;
               Psel_temp = tempselx;
               Pwrite_temp = 1'b0;
            end                     
   ST_RENABLE:begin
               if(valid && ~Hwrite)
               begin
                 Paddr_temp = Haddr1;
                 Pwrite_temp = 1'b0;
                 Psel_temp = tempselx;
                 Penable_temp = 1'b0;
                 Hreadyout_temp = 1'b0;             
               end
               else if(valid && Hwrite)
               begin
                   Paddr_temp = Haddr;
                 Pwrite_temp = Hwrite;
                 Psel_temp = tempselx;
                 Penable_temp = 1'b0;
                 Hreadyout_temp = 1'b1;        
                end
              else
              begin
                   Paddr_temp = Haddr1;
                 Pwrite_temp = Hwrite;
                 Psel_temp = tempselx;
                 Penable_temp = 1'b0;
                 Hreadyout_temp = 1'b1;  
              end
           end

         default: begin
                 Paddr_temp = 32'h0;
                 Pwdata_temp = 32'h0;
                 Pwrite_temp = 1'b0;
                 Psel_temp = 3'b000;
                 Penable_temp = 1'b0;
                 Hreadyout_temp = 1'b0;       
                end
endcase 
end 
 
always @(posedge Hclk)
begin
   Paddr <= Paddr_temp;
   Pwrite <= Pwrite_temp;
   Penable <= Penable_temp;
   Pselx  <= Psel_temp;
   Hreadyout <= Hreadyout_temp;   
   end

   
endmodule
