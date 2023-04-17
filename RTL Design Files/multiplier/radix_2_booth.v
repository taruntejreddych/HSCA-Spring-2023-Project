module PARTIALPRODUCT (INPUT1,segment,OUTPUT1);
input [25:0] INPUT1;input [2:0] segment;output reg [51:0] OUTPUT1;
 
 always @(*) begin
 case (segment)
 3'b000: OUTPUT1=$signed(1'b0);
 3'b011:
 begin
 OUTPUT1=$signed(1'b0);
 end
 3'b100:begin
 OUTPUT1=$signed(1'b0);
 end
 3'b101:begin
 OUTPUT1=$signed(INPUT1);
 OUTPUT1=$signed(~OUTPUT1+1'b1);
 end
 3'b110:begin
 OUTPUT1=$signed(INPUT1);
 OUTPUT1=$signed(~OUTPUT1+1'b1);
 end
 3'b111:OUTPUT1=$signed(16'b0);
 default:OUTPUT1=$signed(INPUT1);
 endcase
 end
 endmodule
