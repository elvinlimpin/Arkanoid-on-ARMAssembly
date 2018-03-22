

@ Draw the character in r0 
@ r1=x
@ r2=y
@ r3=colour
.global DrawChar
DrawChar:
	push		{r4-r10, lr}

	chAdr		.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask		.req	r8
        colour		.req	r9
        initx		.req    r10

	ldr		chAdr, =font		@ load the address of the font map
	add		chAdr,	r0, lsl #4	@ char address = font base + (char * 16)

	mov		py, r2		@ init the Y coordinate (pixel coordinate)
        mov		initx, r1       @ init X coordinate


charLoop$:
	mov		px, initx		@ init the X coordinate

	mov		mask, #0x01		@ set the bitmask to 1 in the LSB
	
	ldrb		row, [chAdr], #1	@ load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask		@ test row byte against the bitmask
	beq		noPixel$

	mov		r0, px
	mov		r1, py
	mov		r2, colour	
	bl		drawPx		@ draw pixel at (px, py)

noPixel$:
	add		px, px, #1			@ increment x coordinate by 1
	lsl		mask, #1		@ shift bitmask left by 1

	tst		mask,	#0x100		@ test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py,py, #1			@ increment y coordinate by 1

	tst		chAdr, #0xF
	bne		charLoop$		@ loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

	pop		{r4-r10, pc}
  
  @ Data section
.section .data

.align 4
font:		.incbin	"font.bin"
