`timescale 1ns/1ns

module tb_uart_tx;

reg				sclk;
reg				s_rst_n;
reg				tx_trig;
reg		[ 7:0]	tx_data;

wire			rs232_tx;
wire			tx_en;

//-------------------------generate system signals-----------------------------
initial begin
		sclk		=		1;
		s_rst_n		<=		0;
		#100
		s_rst_n		<=		1;
end

always		#5		sclk	=  ~sclk;
//------------------------------------------------------------------------------

initial begin
	tx_data			<=		8'd0;
	tx_trig			<=		0;
	#200
	
	tx_trig			<=		1'b1;
	tx_data			<=		8'h55;
	#10
	tx_trig			<=		1'b0;
end

uart_tx			uart_tx_inst(
        // system signals
        .sclk                   (sclk                   ),
        .srst               	(s_rst_n                ),
        // UART Interface       
        .rs232_tx               (rs232_tx               ),
        // others               
		.tx_data                (tx_data                ),
        .tx_trig                (tx_trig                ),
		.tx_en					(tx_en					)
);
endmodule