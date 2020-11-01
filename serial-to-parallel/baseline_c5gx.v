module baseline_c5gx(
		///////// CLOCK /////////
      input              CLOCK_125_p, ///LVDS
      ///////// KEY ///////// 1.2 V ///////
      input       [1:0]  KEY,
      ///////// SW ///////// 1.2 V ///////
      input       [0:0]  SW,
		
		///////// LEDG ///////// 2.5 V ///////
		output 		[7:0]  LEDG,
		///////// LEDR ///////// 2.5 V ///////
      output      [7:0]  LEDR,
		output 		[6:0]  HEX0
);

	wire clk, rst, btn;
	wire [0:0] sw_i;
	reg [7:0] LED;
	reg [2:0] bit_count;
	reg signal;
	reg [7:0] register;
	reg [6:0] seven_segment;
	assign HEX0[6:0] = seven_segment;
	
	assign LEDG[7:0]= register;
	assign LEDR[7:0]= LED;
	assign clk = CLOCK_125_p;
	assign sw_i = SW[0:0];
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
			register [bit_count] <= sw_i;
			bit_count <= bit_count + 1;
			signal <= 1;
		end
		if(bit_count == 0 && !rst) begin
			LED <= register;
		end
		if (rst) begin
				bit_count <= 0;
				LED <= 0;
				register <= 0;
			end
		if (!btn) signal <=0 ;
	end

endmodule

