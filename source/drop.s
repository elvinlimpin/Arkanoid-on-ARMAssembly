.section	.text


.global dropListener
dropListener:
	PUSH	{r4-r6, lr}
	LDR	r0, =dropStateFlag
	LDR	r0, [r0]
	MOV	r4, r0

	MOV	r1, r0
	LDR	r0, =log
	BL	printf

	CMP	r4, #1
	BLT	state0
	BEQ	state1
	CMPGT	r4, #2
	BEQ	state2

	// state 3
		BL	bigPaddleDrop
	//	BL	slowBallDrop
		B	DLend

	state2:
	//	BL	slowBallDrop
		BL	listenPaddle
		B	DLend

	state1:
		BL	bigPaddleDrop
	//	BL	listenSlowBall
		B	DLend

	state0:
//		BL	listenSlowBall
		BL	listenPaddle

DLend:	POP	{r4-r6, pc}


	listenPaddle:
		LDR	r0, =tile20
		LDR	r0, [r0]

		CMP	r0, #0
		MOVNE	pc, lr

		LDR	r0, =dropStateFlag
		LDR	r1, [r0]

		CMP	r1, #2
		MOVEQ	r1, #3
		MOVNE	r1, #1

		STR	r1, [r0]
		MOV	pc, lr


bigPaddleDrop:
	PUSH	{r4-r8, lr}

	MOV	r0, #56

	LDR	r1, =paddleDropY
	LDR	r6, [r1]

	MOV	r1, r6
	MOV	r2, #0xFFFFFF
	MOV	r3, #28
	MOV	r4, r3
	BL	makeTile

	ADD	r7, r6, #32
	LDR	r1, =paddleDropY
	STR	r7, [r1]

	MOV	r0, #'+'
	MOV	r1, #64
	ADD	r2, r6, #4
	BL	drawChar

	MOV	r0, #56
	SUB	r1, r6, #32
	MOV	r2, #0x0
	MOV	r3, #28
	MOV	r4, r3
	BL	makeTile

	LDR	r0, =paddleDropY
	LDR	r0, [r0]
	MOV	r1, #774


	// if drop is near the bottom check if the paddle caught it
	CMP	r0, r1
	BLGE	checkPaddleDrop

	POP	{r4-r8, pc}


checkPaddleDrop:
	PUSH	{lr}
	// load paddle position
	LDR	r0, =paddlePosition
	LDR	r0, [r0]

	// if paddle is 88 from the left
	CMP	r0, #88
	BLE	bigPaddle	// change paddle to big paddle
	BLE	resetDropState
	POP	{pc}

.global dropSlowBall
dropSlowBall:
	PUSH	{r4-r8, lr}

	POP	{r4-r8, pc}


.section	.data

	willDropPaddle:		.int	0
	willDropSlowBall:	.int	0

	paddleDropY:		.int    192


	//states:
	// 0 - nothing is dropping
	// 1 - left is dropping
	// 2 - right is dropping
	// 3 - both is dropping
	// 4 - left is finished. right is
	dropStateFlag:		.int	1
