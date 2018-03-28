
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
	CMP	r0, #1
	POPEQ	{r4-r6, pc}


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

	LDR	r0, =launched
	MOV	r1, #1
	STRB	r1, [r0]

	POP	{pc}

.global unlaunch
unlaunch:
	PUSH	{lr}

	LDR	r0, =launched
	MOV	r1, #0
	STRB	r1, [r0]

	POP	{pc}


.global	isLaunched
isLaunched:
	PUSH	{lr}
	LDR	r0, =launched
	LDRB	r0, [r0]
	POP	{pc}

.section	.data

	prevX:	.int	370
	curX:	.int	326

	prevY:	.int	738
	curY:	.int	738


	launched: .byte	0
