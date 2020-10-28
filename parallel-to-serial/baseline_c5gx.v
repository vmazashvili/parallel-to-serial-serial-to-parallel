module baseline_c5gx(
      ///////// CLOCK /////////
      input              CLOCK_125_p, ///LVDS

      ///////// KEY ///////// 1.2 V ///////
      input       [1:0]  KEY,
  
      ///////// SW ///////// 1.2 V ///////
      input       [7:0]  SW,
		output [7:0] LEDG,
	
output [6:0] HEX0,

		
		///////// LEDR ///////// 2.5 V ///////
      output      [0:0]  LEDR
);

	wire clk, rst, btn;
	wire [7:0] sw_i;
	reg [0:0] LED;
	reg [2:0] bit_count;
	reg signal;
	reg [6:0] seven_segment;
assign HEX0[6:0] = seven_segment;
//assign HEX3[6:0] = SW;	for debuging
	
	assign LEDG[7:0]= bit_count;
	assign LEDR[0:0]= LED;
	assign clk = CLOCK_125_p;
	assign sw_i = SW[7:0];
	assign btn = !KEY[1];      		    
	assign rst = !KEY[0];

always @(clk) begin
	case(bit_count)
	3'b000 : seven_segment <= 7'b1000000;
	3'b001 : seven_segment <= 7'b1111001;
	3'b010 : seven_segment <= 7'b0100100;
	3'b011 : seven_segment <= 7'b0110000;
	3'b100 : seven_segment <= 7'b0011001;
	3'b101 : seven_segment <= 7'b0010010;
	3'b110 : seven_segment <= 7'b0000010;
	3'b111 : seven_segment <= 7'b1111000;
	endcase
end

	always @(posedge clk) begin
			if(btn && !signal &&!rst) begin
				LED <= sw_i[bit_count];
				bit_count <= bit_count+1;
				signal <= 1;
			end
			if (rst) begin
				bit_count <= 0;
				LED <= 0;
			end
			if (!btn) signal <=0;
	end
endmodule
