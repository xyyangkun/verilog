//2022.9.3
//https://hdlbits.01xz.net/wiki/Popcount255
module top_module( 
    input [254:0] in,
    output [7:0] out );
		always@(*)begin
			int i;
			out = 8'b0000_0000; // ��Ҫ��ʼ���ۼӼ�����Ҫ��Ȼ����ÿ�ζ����ϴε�ֵ
			for(i=0;i<255;i=i+1) begin
				if(in[i] == 1'b1)
						out = out + 1'b1;
				else
						out = out;
			end
		end
endmodule
