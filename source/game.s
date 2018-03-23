.text

.global makeGame
makeGame:
	//walls
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
	BL	initBrick

	BL	paddle
	B	terminate

initBrick:
	PUSH	{r4-r9, lr}
	MOV	r4, #0		// x position
	MOV	r5, #0		// y position
	MOV	r6, #0

	brickLoop:
		MOV	r0, r4
		MOV	r1, r5
		MOV	r2, r6
		BL	drawBrick
		ADD	r4, r4, #1
		CMP	r4, #9
		BLE	brickLoop

	MOV	r4, #0
	ADD	r5, r5, #1
	MOV	r6, #1
	CMP	r5, #5
	BLE	brickLoop

	POP	{r4-r9, pc}

paddle:
	PUSH	{r4-r9, lr}

	// init Paddle
	MOV	r0, #228	// x
	MOV	r1, #772	// y
	MOV	r2, #0x880000	// color
	MOV	r3, #192	// length
	MOV	r4, #32		// height
	BL	makeTile

	MOV	r8, #228	// default xstart
	MOV	r7, #1750

	paddleLoop:
			LDR	r0, =log
			MOV	r1, r8
			BL	printf

		MOV	r0, r7			// delay
		BL	readSNES
		MOV	r7, #1750

		CMP	r0, #4096		// start
		BEQ	initMenu

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
		CMP	r8, #484
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
			MOV	r3, #192
			BL	makeTile

			ADD	r8, r8, #32

				LDR	r0, =log
				MOV	r1, r8
				BL	printf

		BL	paddleLoop

		moveLeft:
			CMP	r8, #36
			BLE	paddleLoop

			// repaint
			MOV	r0, r8
			ADD	r0, r0, #160
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

				LDR	r0, =log
				MOV	r1, r8
				BL	printf

			BL	paddleLoop

	POP	{r4-r9, pc}
