module apb_master(
  input PRESETn,
        PCLK,
        Wr_RdN,
        PREADY,
        transfer,
        
  input [7:0] addr,
               wr_data,
               PRDATA,  
               
  output PENABLE,
         PWRITE,
         PSEL,
         
  output reg [7:0] PWDATA,
                PADDR,
                rd_data //input to tb
  );
  
  reg [7:0]PADDR_d,PWDATA_d;
  reg [1:0] current, next;
  localparam [1:0] IDLE  = 2'd0,
                   SETUP = 2'd1,
                   ACCESS  = 2'd2;
                   
  assign PENABLE = (current == ACCESS);
  assign PSEL = ((current == SETUP) | (current == ACCESS));
    
  assign PWRITE = (Wr_RdN == 1)/* & transfer*/;
  
  always @(posedge PCLK or negedge PRESETn) begin
    if(!PRESETn)
      current <= IDLE;
    else begin
    case(current)
        
        IDLE : begin
          if(transfer)begin
              current <= SETUP;
              PADDR <= addr;
            if(PWRITE)
              PWDATA <= wr_data;
            else PWDATA <= 8'h00;
          end
            else begin
              current <= IDLE;
              PADDR <= 8'h00;
          PWDATA <= 8'h00;
        end
          end
          
        SETUP: begin
          current <= ACCESS;
        end
          
        ACCESS: begin
            if (!PREADY) 
              current <= ACCESS;
            else begin
              if (transfer) begin
                if (!Wr_RdN) begin
                  rd_data <= PRDATA;
                  PWDATA<=8'h00;
                end
                current <= SETUP;
                PADDR <= addr;
                if(PWRITE)
            		PWDATA <= wr_data;
                else PWDATA<=8'h00;
                end
              else
                current <= IDLE;
            end
          end
        
        default : begin 
          current <= IDLE;
          PADDR <= 8'h00;
          PWDATA <= 8'h00;
        end
      endcase
    end
   end
  
  
  apb_slave slv(.PADDR(PADDR),
                  .PWDATA(PWDATA),
                  .PENABLE(PENABLE),
                  .PSEL(PSEL),
                  .PCLK(PCLK),
                  .PWRITE(PWRITE),
                  .PRDATA(PRDATA),
                  .PREADY(PREADY)
                 );
  
  
endmodule

module apb_slave(
  input [7:0] PADDR,
              PWDATA,
  input       PENABLE,
              PWRITE,
              PCLK,
              PSEL,
  output reg [7:0]PRDATA,
  output      PREADY
);
  reg [7:0] file[255:0];
  reg PREADY1,PREADY2,PREADY3;
  initial begin
    foreach(file[i])begin
      file [i] = i;
    end
  end
  
  
  always @( posedge PCLK) begin
    if (PENABLE && PSEL)
      PREADY1 <= 1'b1;
    else
      PREADY1 <= 1'b0;
  end
  
  
  assign PREADY = PREADY1 &~PREADY2;
  ////////////To implement a delayed PREADY response from the slave/////////////
  //assign PREADY = PREADY2 &~PREADY3; 
  
  always @(posedge PCLK)begin
    PREADY2 <= PREADY1;
  end
  
  always @(posedge PCLK)begin
    PREADY3<= PREADY2;
  end
  
  always @(posedge PREADY)begin
    if(PENABLE && PSEL) begin
      if(PWRITE) begin
        if(PREADY)
        file[PWRITE] <= PWDATA;
      end
      else begin
        if(PREADY)
        PRDATA <= file[PADDR];
      end
    end
  end
endmodule
