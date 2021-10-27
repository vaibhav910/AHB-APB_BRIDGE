module AHB_interface   (    HCLK , HRESETn, HWRITE , HREADYin , HADDR ,HWDATA  , HTRANS ,
                           VALID ,HWRITEreg  ,TSELx  ,TPADDR1, TPADDR2 ,TPWDATA1, TPWDATA2  );


input  HCLK                  //  reference signal HCLK
      ,HRESETn                //reset signal HRESET
      ,HWRITE                // handshaking signal HWRITE
      ,HREADYin;

input  [31:0]HADDR          //address signal HADDR
            ,HWDATA ;        // Data signal HWDATA
input  [1:0]HTRANS;


output reg VALID                      //handshaking signals VALID
       ,HWRITEreg;

output reg[2:0]TSELx;

output reg [31:0]TPADDR1, TPADDR2           //transmission address signals TADDR1, TADDR2
       ,TPWDATA1, TPWDATA2;     //transmission data signals TPWDATA1, TPWDATA2
       


// peripheral map of memory
//parameter ADDD1 = 32'h8000_0000;    // interrupt controller
//parameter ADDD2 = 32'h8400_0000;    // counter and timers
//parameter ADDD3 = 32'h8800_0000;    // remap and pause
//parameter ADDD4 = 32'h8C00_0000;     // undefined

//...................................................................................................................

always@(*) begin  // define a TSELx
TSELx=3'b000;

if(HADDR>=32'h8000_0000 && HADDR<32'h8400_0000)
begin
TSELx=3'b001;
end

if(HADDR>=32'h8400_0000 && HADDR<32'h8800_0000)
begin
TSELx=3'b010;
end

if(HADDR>=32'h8800_0000 && HADDR<32'h8C00_0000)
begin
TSELx=3'b100;
end

if(HADDR>=32'h8C00_0000)
begin
TSELx=3'b000;
end

end

//...................................................................................................................

always@(*) begin    // define a valid signal

VALID=0;
if(HADDR>=32'h8000_0000 && HADDR<=32'h8C00_0000 && HREADYin && (HTRANS == 2'b10 || HTRANS == 2'b11))
VALID=1;

end

//......................................................................................................................

always@(posedge HCLK or posedge HRESETn ) begin   //2 stage pipeline for data
if(HRESETn)
begin
TPWDATA1<=0;
TPWDATA2<=0;
end

else
begin
TPWDATA1<=HWDATA;
TPWDATA2<=TPWDATA1;
end

end

//...............................................................................................................

always@(posedge HCLK or posedge HRESETn ) begin   //2 stage pipeline for address
if(HRESETn)
begin
TPADDR1<=0;
TPADDR2<=0;
end
else
begin
TPADDR1<=HADDR;
TPADDR2<=TPADDR1;
end

end

//....................................................................................................................
always@(posedge HCLK or posedge HRESETn ) begin  

if(HRESETn)
HWRITEreg<=1'b0;
else
HWRITEreg<=HWRITE;
end
endmodule
