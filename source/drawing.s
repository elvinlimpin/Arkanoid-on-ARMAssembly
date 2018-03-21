
.text
.global Init_Frame
	Init_Frame:
		PUSH	{lr}

		LDR	r0, =frameBufferInfo
		BL	initFbInfo
	
		POP	{lr}
		MOV	pc, lr

.global makePx

makePx:
	PUSH	{r4-r9, lr}

	offset	.req	r4
	frame	.req	r5
	width	.req	r6
	xval	.req	r7
	yval	.req	r8
	color	.req	r9

	MOV	xval, r0
	MOV	yval, r1
	MOV	color, r2

	LDR	frame, =frameBufferInfo
	LDR	width, [frame, #4]

	// making the offset
	MUL	xval, width
	ADD	offset, xval, yval
	LSL	offset, #2	// * 4

	LDR	r3, [r5]
	STR	color, [r3, offset]

	POP	{r4-r9, lr}
	MOV	pc, lr


	.unreq	offset
	.unreq	frame
	.unreq	width
	.unreq	xval
	.unreq	yval
	.unreq	color


.data
.global frameBufferInfo
frameBufferInfo:
	.int	0	// frame buffer pointer
	.int	0	// width
	.int	0	// height
