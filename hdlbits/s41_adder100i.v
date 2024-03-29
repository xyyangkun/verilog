//2022.9.3
//https://hdlbits.01xz.net/wiki/Adder100i
module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
		
		always@(*)  begin
			int i;
			for(i=0; i<100; i=i+1)
				if(i==0)
					{cout[0], sum[0]} = a[0] + b[0] + cin;
				else
					{cout[i], sum[i]} = a[i] + b[i] + cout[i-1];
		end
endmodule