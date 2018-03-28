.global	moveBall
moveBall:
	PUSH	{lr}

	LDR	r0, =slopeCode
	LDR	r0, [r0]

	CMP	r0, #0		// ignore if not launched
	POPEQ	{pc}

	CMP	r0, #9
	POPLT	{pc}
	BEQ	move9

	CMPNE	r0, #7
	BLLT	move7
	POPLT	{pc}

	CMPNE	r0, #89
	BLEQ	move89
	POPEQ	{pc}

	CMPNE	r0, #87
	BLEQ	move87
	POPEQ	{pc}

	CMPNE	r0, #3
	BLEQ	move3
	POPEQ	{pc}

	CMPNE	r0, #1
	BLEQ	move1
	POPEQ	{pc}

	CMPNE	r0, #23
	BLEQ	move23
	POPEQ	{pc}

	CMPNE	r0, #21
	BLEQ	move21
	POPEQ	{pc}

	LDR	r0, =illegalSlope
	BL	printf
	POP	{pc}

move89:
	PUSH	{lr}
	BL	$1

	LDR	r0, =curX
	LDR	r1, [r0]
	SUB	r1, r1, #32
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	SUB	r1, r1, #32
	STR	r1, [r0]

	BL	drawBall
	BL	getRidOfBall
	POP	{pc}

move9:	MOV	pc, lr
move7:	MOV	pc, lr
move87:	MOV	pc, lr
move3:	MOV	pc, lr
move1:	MOV	pc, lr
move23:	MOV	pc, lr
move21:	MOV	pc, lr

.global drawBall
drawBall:
	PUSH	{r4-r6, lr}
	LDR	r0, =curX
	LDR	r5, [r0]

	LDR	r1, =curY
	LDR	r6, [r1]


	//crosswise
	MOV	r0, r5
	ADD	r1, r6, #4
	MOV	r2, #0x0000FF
	MOV	r3, #32
	MOV	r4, #24
	BL	makeTile

	//lengthwise
	ADD	r0, r5, #4		//x
	ADD	r1, r6, #0		//y
	MOV	r2, #0x000FF
	MOV	r3, #24
	MOV	r4, #32
	BL	makeTile

	POP	{r4-r6, pc}

.global initBall
initBall:
	PUSH	{r4-r6,lr}
	ADD	r4, r0, #64

	BL	isLaunched
	CMP	r0, #0
	POPNE	{r4-r6, pc}


	LDR	r5, =curX
	STR	r4, [r5]
	BL	drawBall
	BL	getRidOfBall


	LDR	r0, =lifeCount
	STR	r4, [r0]

	POP	{r4-r6, pc}


getRidOfBall:
	PUSH	{r4-r5, lr}
	LDR	r0, =prevX
	LDR	r0, [r0]
	LDR	r1, =prevY
	LDR	r1, [r1]

	MOV	r2, #0x0
	MOV	r3, #32
	MOV	r4, r3
	BL	makeTile

	LDR	r4, =curX
	LDR	r4, [r4]
	LDR	r5, =prevX
	STR	r4, [r5]

	LDR	r4, =curY
	LDR	r4, [r4]
	LDR	r5, =prevY
	STR	r4, [r5]


	POP	{r4-r5, pc}

.global launchBall
launchBall:
	PUSH	{r4-r7, lr}

	BL	isLaunched		// if already launched, ignore
	CMP	r0, #1
	POPEQ	{r4-r7, pc}

	BL	getRidOfBall
	BL	launch

	POP	{r4-r7, pc}

.global launch
launch:
	PUSH	{lr}

	LDR	r0, =slopeCode
	MOV	r1, #89	// 60 up right
	STRB	r1, [r0]

	POP	{pc}

.global unlaunch
unlaunch:
	PUSH	{lr}

	LDR	r0, =slopeCode
	MOV	r1, #0
	STRB	r1, [r0]
	BL	initBall
	POP	{pc}


.global	isLaunched
isLaunched:
	PUSH	{lr}
	LDR	r0, =slopeCode
	LDR	r0, [r0]
	CMP	r0, #0
	MOVNE	r0, #0
	MOVEQ	r0, #1
	POP	{pc}

.section	.data

	illegalSlope:	.asciz	"Illegal Slope \n"

	prevX:	.int	370
	curX:	.int	326

	prevY:	.int	738
	curY:	.int	738


	//  0: unlaunched
	//  9: 45 up right
	//  7: 45 up left
	// 89: 60 up right
	// 87: 60 up left
	//  3: 45 down right
	//  1: 45 down left
	// 23: 60 down right
	// 21: 60 down left
	// hint: these numbers mimic the numpad

	slopeCode:	.int	0
