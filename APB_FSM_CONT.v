module APB_FSM_CONT(   HCLK, HRESETn, VALID, TSELx, TPADDR1, TPADDR2, TPWDATA1, TPWDATA2, HWRITEreg, 
			PRDATA, HWRITE, PENABLE,PSELx,PADDR,PWDATA,HRDATA, PWRITE,HRESP ,HREADY_OUT  );




input   HCLK,                          		//reference signal HCLK
        HRESETn,                       	 	//reset signal HRESETn
	VALID,					//handshaking signal VALID
	HWRITEreg,HWRITE;
	
input	[31:0]TPADDR1, TPADDR2,			//Transmition addresses signals
	      TPWDATA1, TPWDATA2,			//Transmission data signals
	      PRDATA;
input	[2:0]TSELx;


output reg PENABLE,					//control signals 
	   PWRITE,HREADY_OUT;
output reg	[2:0]PSELx;
output reg	[31:0]PADDR,					//slave address signal
	              PWDATA;					//Transmission data signal
output             [31:0]HRDATA; 
output     	[1:0]HRESP;	
				
reg PENABLE_TEMP, HREADY_OUT_TEMP, PWRITE_TEMP;					
reg	[2:0]PSELx_TEMP;
reg	[31:0]PADDR_TEMP,					
	      PWDATA_TEMP;					
	
	

reg [2:0]CURR_STATE,NEXT_STATE;
reg [31:0]ADDR;

//define state
parameter S_IDLE  =3'b000;		//IDLE
parameter S_READ  =3'b001;		//READ SETUP
parameter S_REN   =3'b010;		//READ ENABLE
parameter S_WWAIT =3'b011;		//WAITING FOR HWDATA
parameter S_WRITE =3'b100;		//WRITE SETUP(no need for a pending)
parameter S_WRITEP =3'b101;		//WRITE SETUP(need a pending cycle)
parameter S_WENP  =3'b110;		//WRITE ENABLE(insert a pedning cycle)
parameter S_WEN   =3'b111;		//WRITE ENBALE(no need for a pending)


always@(posedge HCLK ) begin
if(HRESETn)
CURR_STATE<=S_IDLE;
else
CURR_STATE<=NEXT_STATE;
end

always@(*) begin
NEXT_STATE =S_IDLE;

case(CURR_STATE)
S_IDLE : if(VALID && HWRITE)
	 NEXT_STATE=S_WWAIT;
	else if(VALID && (~HWRITE))
	 NEXT_STATE=S_READ;
	 else
	 NEXT_STATE=S_IDLE;

S_WWAIT :  if(!VALID)
	   NEXT_STATE=S_WRITE;
	   else
	   NEXT_STATE=S_WRITEP;

S_WRITEP :  NEXT_STATE=S_WENP;

S_WENP   :  if((!VALID) && HWRITEreg)
	    NEXT_STATE=S_WRITE;
	    else if(~HWRITEreg)
	    NEXT_STATE=S_READ;

S_WEN  :   if(!VALID)
	   NEXT_STATE=S_IDLE;
	   else if(VALID && HWRITE)
	   NEXT_STATE=S_WWAIT;
	   else if(VALID && (!HWRITE))
	   NEXT_STATE=S_READ;

S_REN  :    if(!VALID)
	   NEXT_STATE=S_IDLE;
	  else if(VALID && HWRITE)
	   NEXT_STATE=S_WWAIT;
	   else if(VALID && (!HWRITE))
	   NEXT_STATE=S_READ;

S_READ :   NEXT_STATE=S_REN;

S_WRITE :  if(!VALID)
	   NEXT_STATE=S_WEN;
	   else
	   NEXT_STATE=S_WENP;
endcase
end

always@(posedge HCLK or posedge HRESETn) begin
PENABLE_TEMP=0;
PSELx_TEMP=0;
PADDR_TEMP=0;
PWDATA_TEMP=0;
HREADY_OUT_TEMP=0;
PWRITE_TEMP=0;
case(CURR_STATE)
S_IDLE :      begin
	      HREADY_OUT_TEMP=1;
		end
S_WWAIT :     begin
	      HREADY_OUT_TEMP=1;
		end

S_WRITEP :	begin
	      PWDATA_TEMP=TPWDATA1;
	      PWRITE_TEMP=1;
	      PSELx_TEMP=TSELx;
	      PADDR_TEMP=TPADDR2;
	      ADDR=PADDR_TEMP;
		end

S_WENP   :	begin
	      PWRITE_TEMP=1;
	      PENABLE_TEMP=1;
	      PSELx_TEMP=TSELx; 
	      PADDR_TEMP=ADDR;
	      PWDATA_TEMP=TPWDATA2;
	      HREADY_OUT_TEMP=1;
	      
  		end

S_WEN  :	begin
	      PWDATA_TEMP=TPWDATA1;
	      PADDR_TEMP=TPADDR1;
	      PENABLE_TEMP=1;
	      PSELx_TEMP=TSELx; 
	      HREADY_OUT_TEMP=1;
	      PWRITE_TEMP=1;	
		end

S_REN  :	begin
	      PENABLE_TEMP=1;
	      HREADY_OUT_TEMP=1;
	      PADDR_TEMP=TPADDR2;
	      PSELx_TEMP=TSELx;
	      
		end

S_READ :	begin
	      PADDR_TEMP=TPADDR1;
	      PSELx_TEMP=TSELx; 
	      HREADY_OUT_TEMP=0;
		end

S_WRITE :    begin
              PWDATA_TEMP=TPWDATA1;
	      PADDR_TEMP=TPADDR1;
	      PWRITE_TEMP=1;	
	      PSELx_TEMP=TSELx;
	      PENABLE_TEMP=0;
	      HREADY_OUT_TEMP=1;
               end
	      
	  
endcase
end


always@(posedge HCLK or posedge HRESETn) begin
if(HRESETn)
begin
PENABLE<=0;
PSELx<=0;
PADDR<=0;
PWDATA <=0;
HREADY_OUT<=0;
PWRITE<=0;
end
else
begin
PENABLE <= PENABLE_TEMP;					
PSELx <= PSELx_TEMP;
PADDR <= PADDR_TEMP;			
PWDATA <= PWDATA_TEMP;				
HREADY_OUT <= HREADY_OUT_TEMP;
PWRITE <= PWRITE_TEMP;
end
end


assign HRDATA = PRDATA;
assign HRESP = 0;

endmodule
