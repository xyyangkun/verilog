//*******************************************
// Author		:	xy
// desp			: uart send
//
//	Modification History:
//  1. initial
//*******************************************

// ******************************************
//		MODULE DEFINITION
// ******************************************
`define SIM

module uart_tx(
	//system signals
	input 			sclk		,
	input 			srst		,
	// UART Interface
	output 	reg		rs232_tx	,
	// others
	input reg[7:0]	tx_data		,
	input 			tx_trig		,
	output			tx_en
);

`ifndef SIM
localparam			MAX_BAUD_COUNT = 5207				;
`else
localparam			MAX_BAUD_COUNT = 28					;
`endif
localparam			BIT_FLAG_COUNT = MAX_BAUD_COUNT/2	;
localparam			MAX_BIT_COUNT = 8					;


reg[ 7:0]			tx_data_reg							;
reg[12:0]			baud_cnt							;
reg					tx_flag								;
reg					bit_flag							;
reg		[ 3:0]		bit_cnt								;

// 当tx_trig为高时，赋值tx_data_reg, 拉高tx_flag
always @(posedge sclk or negedge srst )
begin
	if(srst == 1'b0)
		tx_data_reg <= 8'd0;
	else if(tx_trig == 1'b1)
		tx_data_reg <= tx_data;
end

/// 计数baud_cnt
always @(posedge sclk or negedge srst )
begin
	if(srst == 1'b0)
		baud_cnt <= 'd0;
	else if (baud_cnt == MAX_BAUD_COUNT)
		baud_cnt <= 'd0;
	else if (tx_flag == 1'b1)
		baud_cnt <= baud_cnt + 1;
end

// 置高bit_flag
always @(posedge sclk or negedge srst )
begin
	if(srst == 1'b0)
		bit_flag <= 1'b0;
	else if(baud_cnt == MAX_BAUD_COUNT)
		bit_flag <= 1'b1;
	else 
		bit_flag <= 1'b0;
end

// 计数bit_cnt
always @(posedge sclk or negedge srst )
begin
	if(srst == 1'b0)
		bit_cnt <= 'd0;
	else if (baud_cnt == MAX_BAUD_COUNT && bit_cnt == 'd8)
		bit_cnt <= 0;
	else if(baud_cnt == MAX_BAUD_COUNT)
		bit_cnt <= bit_cnt + 1;

end

always @(posedge sclk or negedge srst )
begin
	if(srst == 1'b0)
		tx_flag <= 1'b0;
	else if (baud_cnt == MAX_BAUD_COUNT && bit_cnt == 'd8)
		tx_flag <= 1'b0;
	else if(tx_trig == 1'b1)
		tx_flag <= 1'b1;

end
/// 发送数据,rs232_tx
always @(posedge sclk or negedge srst )
begin
	if(srst == 1'b0)
		rs232_tx <= 1'b1;
	else if (tx_trig == 1'b1)
		rs232_tx <= 1'b0;
	else if(bit_flag == 1'b1 && tx_flag == 1'b1)
		case(bit_cnt)
			0:	rs232_tx <= 1'b0;
			1:	rs232_tx <= tx_data_reg[0];
			2:	rs232_tx <= tx_data_reg[1];
			3:	rs232_tx <= tx_data_reg[2];
			4:	rs232_tx <= tx_data_reg[3];
			5:	rs232_tx <= tx_data_reg[4];
			6:	rs232_tx <= tx_data_reg[5];
			7:	rs232_tx <= tx_data_reg[6];
			8:	rs232_tx <= tx_data_reg[7];
			default:rs232_tx <= 1'b1;
		endcase
	else if (tx_flag == 1'b0)
		rs232_tx <= 1'b1;

end


assign tx_en =  tx_flag;

endmodule



