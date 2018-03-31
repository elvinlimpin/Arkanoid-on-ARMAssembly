.global	moveBall
moveBall:
	PUSH	{r4-r5,lr}

	BL	changeSlope

	LDR	r0, =slopeCode
	LDR	r0, [r0]

	CMP	r0, #0		// ignore if not launched
	POPEQ	{r4-r5,pc}

	//going up
	CMP	r0, #9
	MOVEQ	r4, #32
	MOVEQ	r5, #32

	CMP	r0, #7
	MOVEQ	r4, #-32
	MOVEQ	r5, #32

	CMP	r0, #89
	MOVEQ	r4, #32
	MOVEQ	r5, #64

	CMP	r0, #87
	MOVEQ	r4, #-32
	MOVEQ	r5, #64

	//going down
	CMP	r0, #3
	MOVEQ	r4, #32
	MOVEQ	r5, #-32

	CMP	r0, #1
	MOVEQ	r4, #-32
	MOVEQ	r5, #-32

	CMP	r0, #23
	MOVEQ	r4, #32
	MOVEQ	r5, #-64

	CMP	r0, #21
	MOVEQ	r4, #-32
	MOVEQ	r5, #-64

	ASR	r4, r4, #1
	ASR	r5, r5, #1

	// move ball here
	LDR	r0, =curX
	LDR	r1, [r0]
	ADD	r1, r1, r4
	STR	r1, [r0]

	LDR	r0, =curY
	LDR	r1, [r0]
	SUB	r1, r1, r5
	STR	r1, [r0]

	BL	getRidOfBall
	BL	drawBall

	POP	{r4-r5,pc}


changeSlope:
	PUSH	{r4-r9, lr}

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

	CMP	r5, #740
	BLGE	checkIfCaught

	CMP	r4,#644
	BLGE	switch45

	CMP	r5, #36
	BLLE	switch60

	CMP	r4, #36
	BLLE	switch45

	LDR	r0, =curX //top left corner
	LDR	r0, [r0]

	LDR	r1, =curY
	LDR	r1, [r1]

	BL	hitBrick
	MOV	r9, r0
        LDR     r1, =scoreCount
	LDR	r2, [r1]
        ADD	r2, r2, r0
	STR	r2, [r1]

	LDR	r0, =curX //top right corner
	LDR	r0, [r0]
        ADD	r0, r0, #32

	LDR	r1, =curY
	LDR	r1, [r1]

	BL	hitBrick
        LDR     r1, =scoreCount
	LDR	r2, [r1]
        add	r2, r2, r0
	str	r2, [r1]
	ORR	r9, r9, r0

	LDR	r0, =curX //bottom left corner
	LDR	r0, [r0]

	LDR	r1, =curY
	LDR	r1, [r1]
  	ADD	r1, r1, #32

	BL	hitBrick
        LDR     r1, =scoreCount
	LDR	r2, [r1]
        ADD	r2, r2, r0
	STR	r2, [r1]
	ORR	r9, r9, r0

	LDR	r0, =curX //bottom right corner
	LDR	r0, [r0]
	ADD	r0, r0, #32

	LDR	r1, =curY
	LDR	r1, [r1]
  	ADD	r1, r1, #32

	BL	hitBrick
        LDR     r1, =scoreCount
	LDR	r2, [r1]
        add	r2, r2, r0
	str	r2, [r1]
	ORR	r9, r9, r0
        CMP	r9, #0
	BLNE	switch60

	BL	makeAllBricks
	POP	{r4-r9, lr}
	mov      pc, LR


checkIfCaught:
	PUSH	{lr}

	LDR	r0, =curX		// get ball x
	LDR	r0, [r0]

	LDR	r1, =paddlePosition	// get paddle X (left bound)
	LDR	r1, [r1]
	ADD	r1, #32

	CMP	r0, r1			// if not caught, check extended paddle range
	MOVLT	r2, #0
	BLLT	checkExtendedPaddle	// for 45 degree launch
	POPLT	{pc}

	LDR	r2, =paddleSize		// get end of paddle
	LDR	r2, [r2]		// right bound

	ADD	r1, r1, r2		// get unextended paddle range
	SUB	r1, r1, #32

	CMP	r0, r1
	MOVGT	r2, #1
	BLGT	checkExtendedPaddle
	BLLE	switch60

	POP	{pc}

// r0 - ball x
// r1 - paddle x
// r2 - left or right side?
checkExtendedPaddle:
	PUSH	{lr}

	CMP	r2, #0		// is this the left side or the right side?
	SUBEQ	r1, r1, #64
	ADDNE	r1, r1, #64

	CMPEQ	r0, r1		// right side, r0 has to be greater
	CMPNE	r1, r0		// left side, r1 has to be greater

	BLGT	switch45Paddle
	BLLT	ballDies

	POP	{pc}


ballDies:
	PUSH	{r4,lr}
	LDR	r4, =slopeCode
	LDR	r4, [r4]
	CMP	r4, #0
	BLNE	unlaunch
	POP	{r4,pc}

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

	CMP	r1, #0
	MOVEQ	r2, #0

	STR	r2, [r0]

	POP	{pc}


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


switch45Paddle:
	PUSH	{lr}
	LDR	r0, =slopeCode
	LDR	r1, [r0]
	MOV	r2, #0

	CMP	r1, #21
	MOVEQ	r2, #7

	CMP	r1, #1
	MOVEQ	r2, #7

	CMP	r1, #3
	MOVEQ	r2, #9

	CMP	r1, #23
	MOVEQ	r2, #9

	STR	r2, [r0]
	POP	{pc}


.section	.data


	illegalSlope:	.asciz	"here"
	xandy:		.asciz	"x: %d y: %d slope: %d\n"

