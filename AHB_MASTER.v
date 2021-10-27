module AHB_MASTER( HCLK ,HRESETn ,HWRITE ,HREADYin, HTRANS ,HADDR ,
                    HWDATA, HRDATA, HRESP, HREADY_OUT );

input HCLK ,HRESETn;

input [1:0]HRESP;

input HREADY_OUT;

input [31:0]HRDATA;

output reg  [1:0]HTRANS;

output reg [31:0]HADDR ,HWDATA;

output reg HWRITE ,HREADYin;


reg [2:0]HSIZE;
reg [2:0]HBURST;

integer i;

parameter BYTE= 3'b000;
parameter HALF_WORD = 3'b001;
parameter WORD = 3'b010;



task SINGLE_WRITE();
begin
@(posedge HCLK)
#1;
begin
HTRANS = 2'd2;
HADDR = 32'h8000_0001;
HWRITE = 1;
HREADYin = 1;
HBURST = 3'b000;

end
@(posedge HCLK)
#1;
begin
HTRANS = 2'd0;
HWDATA = 32'h0000_1122;
end
end 
endtask

task SINGLE_READ();
begin
@(posedge HCLK)
#1;
begin
HTRANS = 2'd2;
HWRITE = 0;
HADDR = 32'h8000_0001;
HREADYin = 1;
end
@(posedge HCLK)
#1;
HTRANS = 2'd0;
end 
endtask





endmodule