
.text
.global Init_Frame
	Init_Frame:
		PUSH	{lr}

		LDR	r0, =frameBufferInfo
		BL	initFbInfo

		POP	{lr}
		MOV	pc, lr

.global drawPx

drawPx:
	PUSH	{r3-r9, lr}

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
	MUL	yval, width
	ADD	offset, xval, yval
	LSL	offset, #2	// * 4

	LDR	r3, [frame]
	STR	color, [r3, offset]

	POP	{r3-r9, lr}
	MOV	pc, lr


	.unreq	offset
	.unreq	frame
	.unreq	width

.global drawHLn
drawHLn:
	PUSH	{r6, lr}
	length	.req 	r3
	pxDrawn	.req	r6

	MOV	pxDrawn, #0
	hlPxLoop:
		BL	drawPx
		ADD	r0, r0, #1
		ADD	pxDrawn, pxDrawn, #1
		CMP	pxDrawn, length
		BLE	hlPxLoop

	POP	{r6, lr}
	MOV	pc, lr

.global makeTile
makeTile:
	PUSH	{r5-r6, lr}
	// length r3
	height	.req	r4

	LDR	r5, =frameBufferInfo
	LDR	r5, [r5, #4]

	MOV	pxDrawn, #0
	tileLoop:
		BL	drawHLn
		ADD	r0, r0, r5
		SUB	r0, r0, length
		SUB	r0, r0, #1
		ADD	pxDrawn, pxDrawn, #1
		CMP	pxDrawn, height
		BLE	tileLoop

	POP	{r5-r6, lr}
	MOV	pc, lr

	.unreq	length
	.unreq	height
	.unreq	pxDrawn

.data
.global frameBufferInfo
frameBufferInfo:
	.int	0	// frame buffer pointer
	.int	0	// width
	.int	0	// height
