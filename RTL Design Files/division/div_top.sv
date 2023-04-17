module div_top #(
    parameter WIDTH=32,  // width of numbers in bits
    parameter MBITS=23   // mantissa bits (IEEE 754 single precision floating point)
    ) (
    input      logic clk,
    input      logic start,          // start signal
    output     logic busy,           // calculation in progress
    output     logic valid,          // quotient and remainder are valid
    output     logic dbz,            // divide by zero flag
    output     logic zbz,            // zero by zero flag
    output     logic ovf,            // overflow flag  (exp > exp max)
    output     logic unf,            // underflow flag (exp < exp min)
    input      logic [WIDTH-1:0] A,  // dividend
    input      logic [WIDTH-1:0] B,  // divisor
    output     logic [WIDTH-1:0] C   // result
    );

    logic [MBITS : 0] q;  // quotient
    logic [MBITS : 0] r;  // remainder

    logic extra_bit;
    logic sign;
    logic [7:0] exp;
    logic [MBITS : 0] man;
    logic [MBITS : 0] x;
    logic [MBITS : 0] y;

    always_comb begin
	x = {1'b1, A[22:0]};
	y = {1'b1, B[22:0]};
    end

    div mandiv (
	.clk(clk),
	.start(start),
	.busy(busy),
	.valid(valid),
	.dbz(),
	.ovf(),
	.x(x),
	.y(y),
	.q(q),
	.r(r)
    );
   

    assign dbz = (B==0) & !zbz;
    assign zbz = (A==0 & B==0);
    assign extra_bit = (x>=y) ? 0 : 1;
    assign sign = A[WIDTH-1] ^ B[WIDTH-1];
    assign exp  = A[WIDTH-2 -: 8] - B[WIDTH-2 -: 8] + 8'd127 - extra_bit;
    assign man  = q << extra_bit;
    assign ovf  = (exp>254) & !dbz;
    assign unf  = (exp<1) & !dbz;

    assign C = {sign, exp, man[MBITS-1:0]};

endmodule
