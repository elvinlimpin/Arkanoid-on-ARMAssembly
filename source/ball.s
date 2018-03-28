.global	moveBall
moveBall:
	PUSH	{lr}

	//debugging
	LDR	r0, =curX
	LDR	r0, [r0]
	LDR	r1, =scoreCount
	STR	r0, [r1]

	BL	changeSlope
	LDR	r0, =slopeCode
	LDR	r0, [r0]

	CMP	r0, #0		// ignore if not launched
	POPEQ	{pc}

	CMP	r0, #9
	BLEQ	move9
	POPEQ	{pc}

	CMPNE	r0, #7
	BLEQ	move7
	POPEQ	{pc}

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

	MOV	r1, r0
	LDR	r0, =illegalSlope
	BL	printf
	POP	{pc}

changeSlope:
	PUSH	{r4-r8, lr}

	LDR	r0, =curX
	LDR	r1, [r0]
	MOV	r4, r1

	LDR	r2, =curY
	LDR	r2, [r2]
	MOV	r5, r2

	LDR	r3, =slopeCode
	LDR	r3, [r3]
	MOV	r6, r3

	LDR	r0, =xandy
	BL	printf


	CMP	r4,#644
	BLGE	switch45

	CMP	r5, #36
	BLLE	switch60

	CMP	r4, #36
	BLLE	switch45

	CMP	r5, #740
	BLGE	switch60

	POP	{r4-r8, pc}

slopeDown:
	PUSH	{lr}

	LDR	r0, =slopeCode
	LDR	r0, [r0]

	CMP	r0, #7
	MOVEQ	r1, #0

	CMP	r0, #9
	MOVEQ	r1, #0

	CMP	r0, #9

	POP	{pc}

move89:
	PUSH	{lr}

	LDR	r0, =curX
	LDR	r1, [r0]
	ADD	r1, r1, #32
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	SUB	r1, r1, #64
	STR	r1, [r0]

	BL	drawBall
	BL	getRidOfBall
	POP	{pc}

move7:
	PUSH	{lr}

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



move9:
	PUSH	{lr}

	LDR	r0, =curX
	LDR	r1, [r0]
	ADD	r1, r1, #32
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	SUB	r1, r1, #32
	STR	r1, [r0]

	BL	drawBall
	BL	getRidOfBall
	POP	{pc}

move87:
	PUSH	{lr}

	LDR	r0, =curX
	LDR	r1, [r0]
	SUB	r1, r1, #32
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	SUB	r1, r1, #64
	STR	r1, [r0]

	BL	drawBall
	BL	getRidOfBall
	POP	{pc}

move3:

	PUSH	{lr}

	LDR	r0, =curX
	LDR	r1, [r0]
	ADD	r1, r1, #32
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	ADD	r1, r1, #32
	STR	r1, [r0]

	BL	drawBall
	BL	getRidOfBall
	POP	{pc}

move1:
	PUSH	{lr}

	LDR	r0, =curX
	LDR	r1, [r0]
	SUB	r1, r1, #32
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	ADD	r1, r1, #32
	STR	r1, [r0]

	BL	drawBall
	BL	getRidOfBall
	POP	{pc}


move23:
	PUSH	{lr}

	LDR	r0, =curX
	LDR	r1, [r0]
	ADD	r1, r1, #32
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	ADD	r1, r1, #64
	STR	r1, [r0]

	BL	drawBall
	BL	getRidOfBall
	POP	{pc}

move21:
	PUSH	{lr}

	LDR	r0, =curX
	LDR	r1, [r0]
	SUB	r1, r1, #32
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	ADD	r1, r1, #64
	STR	r1, [r0]

	BL	drawBall
	BL	getRidOfBall
	POP	{pc}


switch60:
	PUSH	{lr}
	LDR	r0, =slopeCode
	LDR	r1, [r0]

	CMP	r1, #9
	MOVEQ	r2, #23

	CMP	r1, #89
	MOVEQ	r2, #23

	CMP	r1, #87
	MOVEQ	r2, #21

	CMP	r1, #7
	MOVEQ	r2, #21

	CMP	r1, #21
	MOVEQ	r2, #87

	CMP	r1, #1
	MOVEQ	r2, #87

	CMP	r1, #3
	MOVEQ	r2, #89

	CMP	r1, #23
	MOVEQ	r2, #89

	STR	r2, [r0]
	POP	{pc}

//returns
//0 if good
//1 for error

switch45:
	PUSH	{lr}
	LDR	r0, =slopeCode
	LDR	r1, [r0]

	CMP	r1, #9
	MOVEQ	r2, #7

	CMP	r1, #89
	MOVEQ	r2, #7

	CMP	r1, #87
	MOVEQ	r2, #9

	CMP	r1, #7
	MOVEQ	r2, #9

	CMP	r1, #21
	MOVEQ	r2, #3

	CMP	r1, #1
	MOVEQ	r2, #3

	CMP	r1, #3
	MOVEQ	r2, #1

	CMP	r1, #23
	MOVEQ	r2, #1

	STR	r2, [r0]
	POP	{pc}


.global drawBall
drawBall:
	PUSH	{r4-r6, lr}
	LDR	r0, =curX
	LDR	r5, [r0]

	LDR	r1, =curY
	LDR	r6, [r1]


	//crosswise
	ADD	r0, r5, #0
	ADD	r1, r6, #4
	MOV	r2, #0x0000FF
	MOV	r3, #32
	MOV	r4, #24
	BL	makeTile

	//lengthwise
	ADD	r0, r5, #4		//x
	ADD	r1, r6, #0		//y
	MOV	r2, #0x000FF
	MOV	r3, #23
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
	MOV	r4, #32
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
	MOV	r1, #23	// 60 up right
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
	MOVEQ	r0, #0
	MOVNE	r0, #1
	POP	{pc}

.section	.data

	illegalSlope:	.asciz	"here"
	xandy:		.asciz	"x: %d y: %d slope: %d \n"

	prevX:	.int	370
	curX:	.int	326

	prevY:	.int	740
	curY:	.int	740


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
