.file "integral_asm.s"
.text
.globl integral_asm
.type integral_asm, @function

twoones:
    .double 1.0, 1.0

zeros:
    .double 0.0, 0.0

two:
    .double 2.0

# double integral_asm(double from, double to, unsigned n)
# return (double)integralAcc
integral_asm:
    pushl %ebp
    movl  %esp, %ebp
    subl  $8, %esp

    movsd zeros, %xmm0          # xmm0 - integralAcc
    movsd 8(%ebp), %xmm1        # xmm1 - from
    movsd 16(%ebp), %xmm2       # xmm2 - to
    movl  24(%ebp), %ecx        # set also loop counter
    cvtsi2sdl %ecx, %xmm3       # xmm3 - steps

    movsd %xmm2, %xmm4
    subsd %xmm1, %xmm4
    divsd %xmm3, %xmm4          # xmm4 - width

    # Integrating loop init
    movsd %xmm4, %xmm5
    movsd two, %xmm7
    divsd %xmm7, %xmm5
    addsd %xmm1, %xmm5          # xmm5 - middle

    # Integrating loop
    integrate:
        movsd %xmm4, %xmm6
        divsd %xmm5, %xmm6          # xmm6 - surface
        addsd %xmm6, %xmm0          # integralAcc += surface

        addsd %xmm4, %xmm5          # middle += width
        loop integrate

    movsd %xmm0, -8(%ebp)
    fldl  -8(%ebp)

    leave
    ret
