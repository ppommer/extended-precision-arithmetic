# Extended Precision Arithmetic

Programming exercise in the course of the lecture _Introduction to Computer Organization and Technology - Computer Architecture_ (IN0004) at the Technical University of Munich.

The implementation includes basic mathematical operations based on vectors with three elements. The operations are based on 64-bit fixed-point numbers (38-bit pre-decimal, 26-bit post-decimal) performed on a 32-bit architecture. Parameters are passed via the stack in several steps by concatenating the edx and eax registers (thus, the effective return is edx:eax).

`fix_add.asm`
Fixed-point addition.

`fix_sub.asm`
Fixed-point subtraction.

`fix_mul.asm`
Fixed-point multiplication.

`fix_vec_add.asm`
Fixed-point vector addition. The first two parameters are the addresses of the vectors to be added. The result of the addition is in the third vector, whose address is passed via the stack.

`fix_vec_sub.asm`
Fixed-point vector subtraction. The first two parameters are the addresses of the vectors to be subtracted. The result of the subtraction is in the third vector, whose address is passed over the stack.

`fix_vec_dot.asm`
Fixed-point scalar product. The addresses of both vectors are passed as parameters over the stack.

`fix_vec_cross.asm`
Fixed-point cross product. The addresses of both vectors are passed as parameters over the stack. The result of the cross product is in the third vector, whose address is also passed over the stack.
