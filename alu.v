module alu (
             input       reg_in, pc_in,
             input [1:0] code, // code[1] is the cmd, code[0] is the arg
             output reg_out, pc_out
            );

   assign reg_out = code[1] == 1'b0 ?  // cmd == 0 => XOR
                    reg_in ^ code[0] : // xor
                    reg_in;            // reg

   assign pc_out  = code[1] == 1'b1 ?   // cmd == 1 => JMP
                    code[1] & code[0] : // jmp
                    ~pc_in;             // pc++
   
endmodule // alu
