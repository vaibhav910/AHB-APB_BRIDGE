module BRIDGE_TOP_TB();

reg HCLK, HRESETn;
wire HREADY_OUT;

wire HWRITE, HREADYin;

wire [1:0]HTRANS;

wire [31:0]HADDR, HWDATA, HRDATA;

wire [1:0]HRESP;

wire  PENABLE, PWRITE, PWRITE_OUT,PENABLE_OUT;

wire [2:0]PSELx, PSELX_OUT;

wire [31:0]PADDR, PWDATA,PRDATA, PADDR_OUT, PWDATA_OUT; 

assign HRDATA = PRDATA;  // unassign check

//define state
parameter S_IDLE  =3'b000;		//IDLE
parameter S_READ  =3'b001;		//READ SETUP
parameter S_REN   =3'b010;		//READ ENABLE
parameter S_WWAIT =3'b011;		//WAITING FOR HWDATA
parameter S_WRITE =3'b100;		//WRITE SETUP(no need for a pending)
parameter S_WRITEP=3'b101;		//WRITE SETUP(need a pending cycle)
parameter S_WENP  =3'b110;		//WRITE ENABLE(insert a pedning cycle)
parameter S_WEN   =3'b111;		//WRITE ENBALE(no need for a pending)



AHB_MASTER AHB_MAS( HCLK ,HRESETn ,HWRITE ,HREADYin, HTRANS ,HADDR ,
                    HWDATA, HRDATA, HRESP, HREADY_OUT );
BRIDGE_TOP BRIDGE_TO(  HTRANS, HADDR, HWDATA, HREADYin, HWRITE, HCLK, HRESETn, PRDATA, HRESP,

                          PENABLE, HREADY_OUT, PWRITE, PWDATA, PADDR, HRDATA, PSELx );
APB_INTERFACE APB_INTERF( PENABLE, PWRITE, PSELx, PADDR, PWDATA, PWRITE_OUT,
                       PENABLE_OUT, PSELX_OUT, PADDR_OUT, PWDATA_OUT, PRDATA );

initial HCLK  = 0;
always #1 HCLK = ~HCLK ;


task RSTN();
begin
@(negedge HCLK);
HRESETn = 1;
@(negedge HCLK);
HRESETn = 0;

end
endtask

initial
begin
RSTN;
AHB_MAS.SINGLE_WRITE;
#25;
AHB_MAS.SINGLE_READ;
#25;

end

initial
begin
#100 $finish;
end
endmodule
