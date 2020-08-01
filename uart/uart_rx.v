//*******************************************
// Author		:	xy
// desp			: uart recv
//
//	Modification History:
//  1. initial
//*******************************************

// ******************************************
//		MODULE DEFINITION
// ******************************************
`define SIM

module uart_rx(
	//system signals
	input 			sclk		,
	input 			srst		,
	// UART Interface
	input 			rx			,
	// others
	output reg[7:0]	rx_data		,
	output reg		po_flag		
);

`ifndef SIM
localparam			MAX_BAUD_COUNT = 5208				;
`else
localparam			MAX_BAUD_COUNT = 56					;
`endif
localparam			BIT_FLAG_COUNT = MAX_BAUD_COUNT/2	;
localparam			MAX_BIT_COUNT = 8					;

reg						rx_t;
reg						rx_tt;
reg						rx_ttt;
reg						rx_flag;
reg				[12:0]	baud_cnt;
reg						bit_flag;
reg				[3:0]	bit_cnt;

// wire					rx_neg;

assign		rx_neg = ~rx_tt & rx_ttt;

always @(posedge sclk) begin
	rx_t 		<=			rx;
	rx_tt		<=			rx_t;
	rx_ttt		<=			rx_tt;
end

/// rx_flag 在什么时候置为0
always @(posedge sclk or negedge srst )
begin
	if(srst == 1'b0)
		rx_flag <= 1'b0;	
	else if( rx_neg == 1'b1)
		rx_flag <=	1'b1;
	else if (bit_cnt == 'd0 && baud_cnt== MAX_BAUD_COUNT)
		rx_flag <= 1'b0;
end



// baud_cnt 是这样的吗
always @(posedge sclk or negedge srst)
begin
	if(srst == 1'b0)
		baud_cnt <=			0;
	else if(baud_cnt == MAX_BAUD_COUNT)
		baud_cnt <=			0;
	else if(rx_flag == 1'b1)
		baud_cnt <= baud_cnt + 1;
	else
		baud_cnt	<=	1'b0;
end

// bit_flag
always @(posedge sclk or negedge srst)
begin
	if(srst == 1'b0)
		baud_cnt <=			0;
	else if(baud_cnt == BIT_FLAG_COUNT)
		bit_flag <=			1'b1;
	else 
		bit_flag <= 		1'b0;
end

// bit_cnt
always @(posedge sclk or negedge srst)
begin
	if(srst == 1'b0)
		bit_cnt <=			0;
	else if(bit_cnt == MAX_BIT_COUNT && bit_flag== 1'b1)
		bit_cnt <=			0;
	else if(bit_flag == 1'b1)
		bit_cnt <= 		bit_cnt + 1;
end

// rx_data
always @(posedge sclk or negedge srst)
begin
	if(srst == 1'b0)
		rx_data <=			0;
	else if(bit_flag == 1'b1)
		rx_data <=			{rx_ttt, rx_data[7:1]};
end

// po_flag
always @(posedge sclk or negedge srst)
begin
	if(srst == 1'b0)
		po_flag <=			1'b0;
	else if (bit_cnt == MAX_BIT_COUNT && bit_flag==1'b1)
		po_flag <=			1'b1;
	else 
		po_flag <= 			1'b0;
end
endmodule
