module x();

logic x, y, z;

always @(*) begin
    x <= y;
end

(* attrib *)
always @(*) begin
    z <= x;
end


endmodule
