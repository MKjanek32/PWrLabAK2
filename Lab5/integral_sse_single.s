.file "integral_sse_single.s"
.text
.globl integral_sse_single
.type integral_sse_single, @function

zeros:
    .float 0.0, 0.0, 0.0, 0.0

two:
    .float 2.0

# double integral_sse_single(double from, double to, unsigned n)
# return (double)integralAcc
integral_sse_single:
    pushl %ebp
    movl  %esp, %ebp
    subl  $8, %esp

    movups zeros, %xmm0         # xmm0 - integralAcc, vectorize
    movsd 8(%ebp), %xmm1        # xmm1 - from
	cvtsd2ss %xmm1, %xmm1
    movsd 16(%ebp), %xmm2       # xmm2 - to
	cvtsd2ss %xmm2, %xmm2
    movl  24(%ebp), %eax
    cvtsi2ssl %eax, %xmm3       # xmm3 - steps

    movss %xmm2, %xmm4
    subss %xmm1, %xmm4
    divss %xmm3, %xmm4          # xmm4 - width
    unpcklps %xmm4, %xmm4
	unpcklps %xmm4, %xmm4       # vectorize width

    # Integrating loop init
    movss %xmm4, %xmm5
    movss two, %xmm7
    divss %xmm7, %xmm5
    addss %xmm1, %xmm5          # xmm5 - middle

	movss %xmm5, %xmm7			# xmm7 - middle
	unpcklps %xmm7, %xmm7		# xmm7 - middle, middle
	addss %xmm4, %xmm7			# xmm7 - middle, middle + width
	movss %xmm7, %xmm5			# xmm5 - middle + width
	unpcklps %xmm5, %xmm5		# xmm5 - middle + width, middle + width
	addss %xmm4, %xmm5			# xmm5 - middle + width, middle + 2*width
	movss %xmm5, %xmm7			# xmm7 - middle, middle + 2*width
	addss %xmm4, %xmm5			# xmm5 - middle + width, middle + 3*width
	unpcklps %xmm7, %xmm5		# finally vectorize middle
	
    movaps %xmm4, %xmm7
    addps %xmm7, %xmm7          # xmm7 - 2*width
	addps %xmm7, %xmm7          # xmm7 - 4*width

    xorl %edx, %edx
    movl $4, %ecx
    divl %ecx
    movl %eax, %ecx             # set loop counter

    # Integrating loop
    integrate:
        movaps %xmm4, %xmm6
        divps %xmm5, %xmm6          # xmm6 - surface
        addps %xmm6, %xmm0          # integralAcc += surface

        addps %xmm7, %xmm5          # middle += 4*width
        loop integrate

    haddps %xmm0, %xmm0             # vectorized to scalar integral 1
	haddps %xmm0, %xmm0             # vectorized to scalar integral 2

    movss %xmm0, -8(%ebp)
    flds -8(%ebp)

    leave
    ret
