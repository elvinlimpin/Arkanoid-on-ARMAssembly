// Drawing Tools

.text
.global Init_Frame
	Init_Frame:
		PUSH	{lr}

		LDR	r0, =frameBufferInfo
		BL	initFbInfo

		POP	{pc}

.global drawPx

// r0 - xStart
// r1 - yStart
// r2 - color

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

	POP	{r3-r9, pc}


	.unreq	offset
	.unreq	frame
	.unreq	width

// r0 - xStart
// r1 - yStart
// r2 - color
// r3 - length
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

// r0 - xStart
// r1 - yStart
// r2 - color
// r3 - length
// r4 - xLength (height)

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

	POP	{r5-r6, pc}

	.unreq	length
	.unreq	height
	.unreq	pxDrawn



// Draw the character in r0
// r1=x
// r2=y
// @r3=colour
.global drawChar
drawChar:
	PUSH		{r4-r10, lr}

	chAdr		.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask		.req	r8
        colour		.req	r9
        initx		.req    r10

	LDR		chAdr, =font		// load the address of the font map
	ADD		chAdr,	r0, lsl #4	// char address = font base + (char * 16)

	MOV		py, r2			// init the Y coordinate (pixel coordinate)
        MOV		initx, r1	      	// init X coordinate


	charLoop:
		MOV		px, initx		// init the X coordinate
		MOV		mask, #0x01		// set the bitmask to 1 in the LSB
		LDRB		row, [chAdr], #1	// load the row byte, post increment chAdr

	rowLoop:
		TST		row, mask		// test row byte against the bitmask
		BEQ		noPixel

		MOV		r0, px
		MOV		r1, py
		MOV		r2, colour
		BL		drawPx			// draw pixel at (px, py)

	noPixel:
		ADD		px, px, #1		// increment x coordinate by 1
		LSL		mask, #1		// shift bitmask left by 1

		TST		mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
		BEQ		rowLoop

		ADD		py,py, #1		// increment y coordinate by 1

		TST		chAdr, #0xF
		BNE		charLoop		// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

	POP		{r4-r10, pc}


// r0 - char array address
// r1 - initial x
// r2 - y
// r3 - color
.global drawWord
drawWord:
	PUSH	{r4-r7, lr}
	MOV	r5, r0
	MOV	r6, r1
	MOV	r7, r2
	MOV	r4, r3
	drawWordLoop:
		LDRB	r0, [r5], #1
		CMP	r0, #0
		POPEQ	{r4-r7, pc}

		MOV	r1, r6
		MOV	r2, r7
		MOV	r3, r4
		BL	drawChar
		ADD	r6, r6, #11
		B	drawWordLoop


// r0 - brick x position
// r1 - brick y position
// r2 - brick type (0, 1, 2)

.global drawBrick
drawBrick:
	xpos		.req	r5
	ypos		.req	r6
	colorCode	.req	r7


	PUSH	{r3-r7, lr}
	BL	drawOutBrick
	BL	drawInBrick
		.unreq	xpos
		.unreq	ypos
		.unreq	colorCode

	POP	{r3-r7, pc}


drawOutBrick:
	xpos		.req	r5
	ypos		.req	r6
	colorCode	.req	r7

	PUSH	{lr}
	MOV	xpos, r0
	MOV	ypos, r1
	MOV	colorCode, r2

	MOV	r3, #64
	MOV	r4, #32

	LSL	xpos, xpos, #6
	ADD	xpos, #36
	MOV	r0, xpos

	LSL	ypos, ypos, #5
	ADD	ypos, #64
	MOV	r1, ypos

	MOV	r2, #0x0
	BL 	makeTile
		.unreq	xpos
		.unreq	ypos
		.unreq	colorCode

	POP	{pc}

drawInBrick:
	xpos		.req	r5
	ypos		.req	r6
	colorCode	.req	r7


	PUSH	{lr}

	ADD	xpos, xpos, #4
	ADD	ypos, ypos, #4

	MOV	r3, #56
	MOV	r4, #24

	MOV	r0, xpos
	MOV	r1, ypos

	MOV	colorCode, #0
	CMP	colorCode, #1
	LDREQ	r2, =cYellow
	LDRGT	r2, =cGreen
	LDRLT	r2, =cWhite

	BL	makeTile

		.unreq	xpos
		.unreq	ypos
		.unreq	colorCode

	POP	{pc}

// Data section
.section .data

.align 4
font:		.incbin	"font.bin"

cWhite:		.word 0xFFFFFF
cYellow:	.word 0xFFFF00
cGreen:		.word 0x00FF00

.global frameBufferInfo
frameBufferInfo:
	.int	0	// frame buffer pointer
	.int	0	// width
	.int	0	// height
