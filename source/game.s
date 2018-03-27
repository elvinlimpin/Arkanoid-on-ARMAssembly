.text

.global makeGame
makeGame:
	MOV	r0, #4
	MOV	r1, #4
	MOV	r2, #0x007770
	MOV	r3, #704
	MOV	r4, #944
	BL	makeTile


	// foreground
	MOV	r0, #36
	MOV	r1, #36
	MOV	r2, #0x0
	MOV	r3, #640
	MOV	r4, #880
	BL	makeTile

	BL	initScore
	BL	initLives
	BL	initBricks

	BL	paddle
	B	terminate

initBricks:
	PUSH	{r4-r6, lr}
	MOV	r4, #0		// x position
	MOV	r5, #2		// y position
	MOV	r6, #2		// color

	brickLoop:
		MOV	r0, r4
		MOV	r1, r5
		MOV	r2, r6
		BL	makeBrick
		ADD	r4, r4, #1
		CMP	r4, #9
		BLE	brickLoop

	MOV	r4, #0
	ADD	r5, r5, #1
	SUB	r6, #1
	CMP	r5, #4
	BLE	brickLoop

	POP	{r4-r6, pc}

paddle:
	PUSH	{r4-r9, lr}

	BL	drawInitialPaddle
	LDR	r8, =paddleStart // default xstart
	LDR	r8, [r8]
	MOV	r7, #1750	// pause length

	paddleLoop:
			LDR	r0, =scoreCount
			STR	r8, [r0]

		LDR	r8, =paddlePosition
		LDR	r8, [r8]

		BL	updateScoreAndLives
//		BL	ballLoop
		MOV	r0, r7			// delay
		BL	readSNES
		MOV	r7, #1750

		CMP	r0, #4096		// start
		BLEQ	hitBrickTest

		CMP	r0, #512		// L
		BEQ	moveLeft
		CMP	r0, #256		// R
		BEQ	moveRight

		CMP	r0, #640		// L + A
		MOVEQ	r7, #550
		BEQ	moveLeft

		CMP	r0, #384		// R + A
		MOVEQ	r7, #550
		BNE	paddleLoop

		moveRight:

		LDR	r6, =paddleBound
		LDR	r6, [r6]
		CMP	r8, r6
		BGE	paddleLoop

			//repaint
			MOV	r0, r8
			MOV	r1, #772
			MOV	r2, #0x0
			MOV	r3, #32
			MOV	r4, #32
			BL	makeTile

			//paddle
 			MOV	r0, r8
			ADD	r0, r0, #32
			MOV	r1, #772
			MOV	r2, #0x8800000
			LDR	r3, =paddleSize
			LDR	r3, [r3]
			BL	makeTile

			ADD	r8, r8, #32
			LDR	r6, =paddlePosition
			STR	r8, [r6]

		BL	paddleLoop

		moveLeft:
			CMP	r8, #36
			BLE	paddleLoop

			// repaint
			LDR	r0, =paddleSize
			LDR	r0, [r0]
			SUB	r0, r0, #32
			ADD	r0, r8

			MOV	r1, #772
			MOV	r2, #0x0
			MOV	r3, #32
			BL	makeTile

			//paddle
			MOV	r0, r8
			SUB	r0, r0, #32
			MOV	r1, #772
			MOV	r2, #0x8800000
			MOV	r3, #192
			BL	makeTile

			SUB	r8,r8, #32
			LDR	r6, =paddlePosition
			STR	r8, [r6]

			BL	paddleLoop

	POP	{r4-r9, pc}

.global bigPaddle
bigPaddle:
	PUSH	{lr}
	BL	drawInitialPaddle

	LDR	r0, =paddleSize
	MOV	r1, #384
	STR	r1, [r0]

	LDR	r0, =paddleStart
	MOV	r1, #0
	STR	r1, [r0]

	LDR	r0, =paddleBound
	MOV	r1, #292
	STR	r1, [r0]

	POP	{pc}

smallPaddle:
	PUSH	{lr}

	BL	clearPaddle
	BL	drawInitialPaddle

	LDR	r0, =paddleSize
	MOV	r1, #192
	STR	r1, [r0]

	LDR	r0, =paddleStart
	MOV	r1, #228
	STR	r1, [r0]

	LDR	r0, =paddleBound
	MOV	r1, #484
	STR	r1, [r0]

	LDR	r0, =paddlePosition
	MOV	r1, #228
	STR	r1, [r0]

	POP	{pc}

drawInitialPaddle:
	PUSH	{lr}

	// init Paddle
	MOV	r0, #228	// x
	MOV	r1, #772	// y
	MOV	r2, #0x880000	// color
	MOV	r3, #192
	MOV	r4, #32		// height
	BL	makeTile

	POP	{pc}

clearPaddle:
	PUSH	{lr}
	MOV	r0, #36
	MOV	r1, #772
	MOV	r2, #0x0
	MOV	r3, #640
	MOV	r4, #32
	BL	makeTile
	POP	{pc}

.section	.data


	.global paddleSize
	paddleSize:	.int	192

	.global paddleStart
	paddleStart:	.int	228

	.global	paddlePosition
	paddlePosition:	.int	228

	paddleBound:	.int	484
