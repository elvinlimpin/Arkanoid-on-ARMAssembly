.section .text

.global makeGame
makeGame:
	BL	resetScore

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

	LDR	r0, =paddlePosition
	MOV	r1, #228
	STR	r1, [r0]

	BL	paddle
	B	terminate

initBricks:
	PUSH	{r4-r6, lr}
	MOV	r4, #0		// x position
	MOV	r5, #0		// y position
	MOV	r6, #3		// color

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
	SUB	r6, r6, #1
	CMP	r5, #2
	BLE	brickLoop

	POP	{r4-r6, lr}
	mov	PC, LR

paddle:
	PUSH	{r4-r9, lr}

	BL	drawInitialPaddle
	LDR	r8, =paddleStart // default xstart
	LDR	r8, [r8]
	MOV	r0, r8
	BL	initBall


	MOV	r7, #1500	// pause length

	paddleLoop:
		BL	maybeMoveBall

		LDR	r8, =paddlePosition
		LDR	r8, [r8]

		// check if won or lost
		BL	checkGameWon //check if game has been won
        	CMP	r0, #1
		POPEQ	{r4-r9, lr}
		MOVEQ	pc, lr
        	BEQ	WIN

        	LDR	r0, =lifeCount
        	LDR 	r0, [r0]
        	CMP	r0, #0
		POPEQ	{r4-r9, lr}
		MOVEQ	pc, lr
        	BEQ	LOST

		BL	updateScoreAndLives
		MOV	r0, r7			// delay
		BL	readSNES
		MOV	r7, #1500

		CMP	r0, #4096		// start
		BLEQ	pauseMenu

		CMP	r0, #32768		// B
		BLEQ	launchBall

		CMP	r0, #16384		// Y
		BLEQ	bigPaddleDrop

		CMP	r0, #512		// L
		BEQ	moveLeft
		CMP	r0, #256		// R
		BEQ	moveRight

		CMP	r0, #640		// L + A
		MOVEQ	r7, #750
		BEQ	moveLeft

		CMP	r0, #384		// R + A
		MOVEQ	r7, #750
		BNE	paddleLoop
		BEQ	moveRight

		CMP	r0, #128		//A
		MOVEQ	r7, #750

		moveRight:

		LDR	r6, =paddleBound
		LDR	r0, [r6]
		CMP	r8, r0
		BGE	paddleLoop

				//repaint
				MOV	r0, r8
				MOV	r1, #774
				MOV	r2, #0x0
				MOV	r3, #32
				MOV	r4, #32
				BL	makeTile

				//paddle
 				MOV	r0, r8
				ADD	r0, r0, #32
				MOV	r1, #774
				MOV	r2, #0x8800000
				LDR	r3, =paddleSize
				LDR	r3, [r3]
				BL	makeTile

				ADD	r8, r8, #32
				LDR	r6, =paddlePosition
				STR	r8, [r6]
				MOV	r0, r8
			BL	initBall

		BL	paddleLoop

		moveLeft:
			CMP	r8, #36
			BLE	paddleLoop

				// repaint
				LDR	r0, =paddleSize
				LDR	r0, [r0]
				SUB	r0, r0, #32
				ADD	r0, r8

				MOV	r1, #774
				MOV	r2, #0x0
				MOV	r3, #32
				BL	makeTile

				//paddle
				MOV	r0, r8
				SUB	r0, r0, #32
				MOV	r1, #774
				MOV	r2, #0x8800000
				MOV	r3, #192
				BL	makeTile

				SUB	r8,r8, #32
				LDR	r6, =paddlePosition
				STR	r8, [r6]
				MOV	r0, r8
				BL	initBall

			BL	paddleLoop

	POP	{r4-r9, lr}
	MOV	PC, lr

maybeMoveBall:
	PUSH	{r4,r5, lr}
	LDR	r0, =willMoveBall
	LDR	r1, [r0]
	MOV	r4, r0

	CMP	r1, #0
	BEQ	moveBallLoop

	MOV	r5, #1414
	CMP	r7, r5
	BGE	moveBallLoop

	MOV	r1, #0
	STR	r1, [r0]
	POP	{r4,r5,lr}
	MOV	PC,lr

	moveBallLoop:
		BL	moveBall
		MOV	r1, #1
		MOV	r0, r4
		STR	r1, [r0]
		POP	{r4,r5,lr}
		MOV	PC, LR

.global anybutton
anybutton:
	MOV	r0, #8192
        BL 	readSNES
	CMP     r0, #0
        BNE	menusetup
	B	anybutton

anybutton2:
        bl 	readSNES
	CMP     r0, #0
        BNE	menusetup
	B	anybutton2
        

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

	POP	{lr}
	MOv	PC, LR

.global smallPaddle
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

	POP	{lr}
	MOV	PC, LR

drawInitialPaddle:
	PUSH	{lr}

	// init Paddle
	MOV	r0, #228	// x
	MOV	r1, #774	// y
	MOV	r2, #0x880000	// color
	MOV	r3, #192
	MOV	r4, #32		// height
	BL	makeTile

	POP	{LR}
	MOV	PC, LR


.global	clearPaddle
clearPaddle:
	PUSH	{lr}
	MOV	r0, #36
	MOV	r1, #774
	MOV	r2, #0x0
	MOV	r3, #640
	MOV	r4, #32
	BL	makeTile
	POP	{lr}
	MOV	PC, LR

.section	.data


	.global paddleSize
	paddleSize:	.int	192

	.global paddleStart
	paddleStart:	.int	228

	.global	paddlePosition
	paddlePosition:	.int	228

	paddleBound:	.int	484

	willMoveBall:	.int	1
