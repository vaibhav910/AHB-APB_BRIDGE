 

module BRIDGE_TOP(  HTRANS, HADDR, HWDATA, HREADYin, HWRITE, HCLK, HRESETn, PRDATA, HRESP,

                          PENABLE, HREADY_OUT, PWRITE, PWDATA, PADDR, HRDATA, PSELx );



 input  [1:0]HTRANS;

 input  [31:0]HADDR
	     ,HWDATA;

 input   HREADYin
	,HWRITE
	,HCLK
	,HRESETn;

 input [31:0]PRDATA;

 
	

output    PENABLE
	 ,HREADY_OUT
	 ,PWRITE;

output [31:0]PWDATA
	    ,PADDR;
	    
 
output [2:0]PSELx;

output  [1:0]HRESP;
output [31:0]HRDATA;

wire [2:0]TSELx;
wire  [31:0]TPADDR1, TPADDR2, TPWDATA1, TPWDATA2;


AHB_interface mod1(    HCLK , HRESETn, HWRITE , HREADYin , HADDR ,HWDATA  , HTRANS ,
                           VALID ,HWRITEreg  ,TSELx  ,TPADDR1, TPADDR2 ,TPWDATA1, TPWDATA2  );

APB_FSM_CONT mod2(   HCLK, HRESETn, VALID, TSELx, TPADDR1, TPADDR2, TPWDATA1, TPWDATA2, HWRITEreg, 
			PRDATA, HWRITE, PENABLE,PSELx,PADDR,PWDATA,HRDATA, PWRITE,HRESP ,HREADY_OUT  );


endmodule

