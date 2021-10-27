module APB_INTERFACE( PENABLE, PWRITE, PSELx, PADDR, PWDATA, PWRITE_OUT,
                       PENABLE_OUT, PSELX_OUT, PADDR_OUT, PWDATA_OUT, PRDATA );


input PENABLE,PWRITE;

input [2:0]PSELx;

input [31:0]PADDR,PWDATA;	

output PWRITE_OUT,PENABLE_OUT;

output [2:0]PSELX_OUT;

output [31:0]PADDR_OUT,PWDATA_OUT;

output reg [31:0]PRDATA;


assign PSELX_OUT = PSELx;
assign PADDR_OUT =PADDR;
assign PWDATA_OUT = PWDATA;
assign PWRITE_OUT = PWRITE;
assign PENABLE_OUT = PENABLE;

always @(*)
begin
if(!PWRITE && PENABLE)
PRDATA = {$random}%100;
else
PRDATA=32'd0;

end

endmodule