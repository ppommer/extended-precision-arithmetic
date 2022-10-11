# Extended Precision Arithmetic

This repository includes a low-level implementation for basic vector operations on 64-bit fixed-point numbers. The implementation aims to be executable on a 32-bit architecture by splitting the 64-bit numbers into two registers each and executing the operations including the carry bit. Parameters are passed via the stack by concatenating the edx and eax registers; results are also returned in edx:eax.

`fix_add.asm`
Fixed-point addition.

`fix_sub.asm`
Fixed-point subtraction.

`fix_mul.asm`
Fixed-point multiplication.

`fix_vec_add.asm`
Fixed-point vector addition. The first two parameters are the addresses of the vectors to be added. The result of the addition is stored in the third vector (address passed over the stack).

`fix_vec_sub.asm`
Fixed-point vector subtraction. The first two parameters are the addresses of the vectors to be subtracted. The result of the subtraction is stored in the third vector (address passed over the stack).

`fix_vec_dot.asm`
Fixed-point scalar product. The addresses of both vectors are passed as parameters over the stack.

`fix_vec_cross.asm`
Fixed-point cross product. The addresses of both vectors are passed as parameters over the stack. The result of the cross product is stored in the third vector (address passed over the stack).
