.section	.text

.global bigPaddleDrop
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

	POP	{r4-r8, pc}


.global dropSlowBall
dropSlowBall:
	PUSH	{r4-r8, lr}

	POP	{r4-r8, pc}


.section	.data

	willDropPaddle:		.int	0
	willDropSlowBall:	.int	0

	paddleDropY:		.int 160
