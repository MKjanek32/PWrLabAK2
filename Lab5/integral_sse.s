.file "integral_sse.s"
.text
.globl integral_sse
.type integral_sse, @function

zeros:
    .double 0.0, 0.0

two:
    .double 2.0

# double integral_sse(double from, double to, unsigned n)
# return (double)integralAcc
integral_sse:
    pushl %ebp
    movl  %esp, %ebp
    subl  $8, %esp

    movupd zeros, %xmm0         # xmm0 - integralAcc, vectorize
    movsd 8(%ebp), %xmm1        # xmm1 - from
    movsd 16(%ebp), %xmm2       # xmm2 - to
    movl  24(%ebp), %eax
    cvtsi2sdl %eax, %xmm3       # xmm3 - steps

    movsd %xmm2, %xmm4
    subsd %xmm1, %xmm4
    divsd %xmm3, %xmm4          # xmm4 - width
    unpcklpd %xmm4, %xmm4       # vectorize width

    # Integrating loop init
    movsd %xmm4, %xmm5
    movsd two, %xmm7
    divsd %xmm7, %xmm5
    addsd %xmm1, %xmm5          # xmm5 - middle
    unpcklpd %xmm5, %xmm5       # vectorize middle
    addsd %xmm4, %xmm5          # xmm5 - middle, middle + width
    movapd %xmm4, %xmm7
    addpd %xmm7, %xmm7          # xmm7 - 2*width

    xorl %edx, %edx
    movl $2, %ecx
    divl %ecx
    movl %eax, %ecx             # set loop counter

    # Integrating loop
    integrate:
        movapd %xmm4, %xmm6
        divpd %xmm5, %xmm6          # xmm6 - surface
        addpd %xmm6, %xmm0          # integralAcc += surface

        addpd %xmm7, %xmm5          # middle += 2*width
        loop integrate

    haddpd %xmm0, %xmm0             # vectorized to scalar integral

    movsd %xmm0, -8(%ebp)
    fldl -8(%ebp)

    leave
    ret
