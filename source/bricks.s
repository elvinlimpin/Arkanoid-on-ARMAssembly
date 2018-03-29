.section .text

// r0 - x code
// r1 - y code
// r2 - colorCode
// draws Brick and changes brick state
.global makeBrick
makeBrick:
	PUSH	{r4-r6, lr}
	MOV	r4, r0
	MOV	r5, r1
	MOV	r6, r2
	BL	codeToTile
	STRB	r2, [r0]	// store the brick state

	MOV	r0, r4
	MOV	r1, r5
	MOV	r2, r6
	BL	drawBrick

	POP	{r4-r6, lr}
	MOV	pc, lr

// r0 - brick x position
// r1 - brick y position
// r2 - brick type (0, 1, 2, 3)
drawBrick:
	xpos		.req	r5
	ypos		.req	r6
	colorCode	.req	r7


	PUSH	{r3-r8, lr}
	BL	CodeToXY

	MOV	xpos, r0
	MOV	ypos, r1
	MOV	colorCode, r2

	MOV	r3, #64
	MOV	r4, #32

	MOV	r2, #0x0


	LDR	r8, =doTile
	LDRB	r8, [r8]
	CMP	r8, #1
	BLNE	$
	BLEQ 	makeTile		// make the outside brick

	ADD	xpos, xpos, #4
	ADD	ypos, ypos, #4

	MOV	r3, #56
	MOV	r4, #24

	CMP	colorCode, #0
	MOVEQ	r2, #0

	CMP	colorCode, #1
	MOVEQ	r2, #0x00FF00	// 1 hit

	CMP	colorCode, #2
	MOVEQ	r2, #0x007700	// 2 hits

	CMP	colorCode, #3
	MOVEQ	r2, #0x003300	// 3 hits


	MOV	r0, xpos
	MOV	r1, ypos


	LDR	r7, =doTile
	LDRB	r7, [r7]
	CMP	r7, #1
	BLNE	$
	BLEQ 	makeTile


	POP	{r3-r8, lr}
	MOV 	pc, lr


.global getBrickState
// takes XY
// return brick state
getBrickState:
       	PUSH    {lr}
	//convert to brick state
	BL	XYtoCode
	BL	codeToTile
	// return brick state
	LDRB	r0, [r0]
        POP	{lr}
	MOV	pc, lr


// params
// r0 - x coordinate
// r1 - y coordinate

// returns 0 - didn't hit brick
// 	   1 - hit brick
.global	hitBrick
hitBrick:
	PUSH	{r4-r7, lr}

	// store brick state on register
	BL	XYtoCode
	MOV	r4, r0
	MOV	r5, r1
	BL	codeToTile
        LDRB	r7, [r0]
        MOV	r6, r0

	MOV	r1, r0
	LDR	r0, =log
	BL	printf

	CMP	r7, #0

	MOVEQ	r0, #0		// didn't hit brick
	POPEQ	{r4-r7, lr}
	MOVEQ	pc, lr

	CMP	r7, #3		// check if normal brick
	SUBLE	r2, r7, #1	// normal brick, degrade the brick

//	BLGT	specialTile	// not a normal brick, do something
	MOVGT	r2, #0		// brick is now gone

	MOV	r0, r4
	MOV	r1, r5
	// r2 is the color
	BL	makeBrick	// recolor

	MOV	r0, #1		// brick is hit
	POP	{r4-r7, lr}
        MOV	pc, lr


	specialTile:
		PUSH	{lr}

		CMP	r0, #4
		BLEQ	dropSlowBall
		BLNE	dropBigPaddle
		POP	{lr}
		MOV	PC, LR

dropBigPaddle:
	PUSH	{lr}
	BL	bigPaddleDrop

	POP	{pc}


// r0 r1 - xy code
// returns r0 r1 - xy
CodeToXY:
	LSL	r0, r0, #6
	ADD	r0, r0, #36
	LSL	r1, r1, #5
	ADD	r1, r1, #64
	MOV	pc, lr

// r0 r1 - xy position
// returns r0 r1 - xy code
XYtoCode:
	PUSH	{r4,r5,lr}
	SUB	r0, r0, #36
	SUB	r1, r1, #64

	ASR	r2, r1, #5
	SUB	r2, r2, #-1
	MOV	r5, r2

	ASR	r0, r0, #6
	MOV	r4, r0

	LDR	r0, =codeLog
	BL	printf	//r1 - x code	// r2 - ycode


	MOV	r0, r4
	MOV	r1, r5

	POP	{r4,r5,pc}

// params
//r0 - xcode
//r1 - ycode

// return
// r0 - brickStateAddress
codeToTile:
	PUSH	{lr}

	CMP	r1, #1
	BLT	fromZero
	BEQ	fromTen

	CMPGT	r1, #2
	BEQ	fromTwenty
	// invaild input, return 0
	LDR	r0, =emptyTile
	POP	{pc}


	fromTwenty:
		CMP	r0, #0
		LDREQ	r0, =tile20
		POPEQ	{pc}

		CMP	r0, #1
		LDREQ	r0, =tile21
		POPEQ	{pc}


		CMP	r0, #2
		LDREQ	r0, =tile22
		POPEQ	{pc}

		CMP	r0, #3
		LDREQ	r0, =tile23
		POPEQ	{pc}


		CMP	r0, #4
		LDREQ	r0, =tile24
		POPEQ	{pc}


		CMP	r0, #5
		LDREQ	r0, =tile25
		POPEQ	{pc}

		CMP	r0, #6
		LDREQ	r0, =tile26
		POPEQ	{pc}

		CMP	r0, #7
		LDREQ	r0, =tile27
		POPEQ	{pc}

		CMP	r0, #8
		LDREQ	r0, =tile28
		POPEQ	{pc}

		LDR	r0, =tile29
		POP	{pc}

	fromZero:
		CMP	r0, #0
		LDREQ	r0, =tile0
		POPEQ	{pc}

		CMP	r0, #1
		LDREQ	r0, =tile1
		POPEQ	{pc}

		CMP	r0, #2
		LDREQ	r0, =tile2
		POPEQ	{pc}

		CMP	r0, #3
		LDREQ	r0, =tile3
		POPEQ	{pc}

		CMP	r0, #4
		LDREQ	r0, =tile4
		POPEQ	{pc}

		CMP	r0, #5
		LDREQ	r0, =tile5
		POPEQ	{pc}

		CMP	r0, #6
		LDREQ	r0, =tile6
		POPEQ	{pc}

		CMP	r0, #7
		LDREQ	r0, =tile7
		POPEQ	{pc}

		CMP	r0, #8
		LDREQ	r0, =tile8
		POPEQ	{pc}

		LDR	r0, =tile9
		POP	{pc}

	fromTen:
		CMP	r0, #0
		LDREQ	r0, =tile20
		POPEQ	{pc}

		CMP	r0, #1
		LDREQ	r0, =tile21
		POPEQ	{pc}

		CMP	r0, #2
		LDREQ	r0, =tile22
		POPEQ	{pc}

		CMP	r0, #3
		LDREQ	r0, =tile23
		POPEQ	{pc}

		CMP	r0, #4
		LDREQ	r0, =tile24
		POPEQ	{pc}

		CMP	r0, #5
		LDREQ	r0, =tile25
		POPEQ	{pc}

		CMP	r0, #6
		LDREQ	r0, =tile26
		POPEQ	{pc}

		CMP	r0, #7
		LDREQ	r0, =tile27
		POPEQ	{pc}

		CMP	r0, #8
		LDREQ	r0, =tile28
		POPEQ	{pc}

		LDR	r0, =tile29
		POP	{pc}

//returns 0 if not won or 1 if won
.global checkGameWon
checkGameWon:
	push {r4, r5, lr}
	mov r4, #0
        ldr r5, =tile0

checkallbricks:
	ldrb r0, [r5, r4]
	ADD  r4, r4, #1

        CMP  r0, #0
        MOVNE r0, #0
        POPNE {r4,r5,pc}

	CMP r4, #30
	BLT checkallbricks

	MOV r0, #1
        POP {r4, r5, pc}
	


// 0 - broken
// 1 - 1 hits to break
// 2 - 2 hits to break
// 3 - 3 hit to break
// 4 - special brick 1
// 5 - special brick 2
.section	.data

	tile0:	.byte	2
	tile10:	.byte 	1
	tile20:	.byte 	3

	tile1:	.byte	2
	tile11:	.byte	5	// special
	tile21:	.byte	3

	tile2:	.byte	2
	tile12:	.byte	1
	tile22:	.byte	3

	tile3:	.byte	2
	tile13:	.byte	1
	tile23:	.byte	3

	tile4:	.byte	2
	tile14:	.byte	1
	tile24:	.byte	3

	tile5:	.byte	2
	tile15:	.byte	1
	tile25:	.byte	3

	tile6:	.byte	2
	tile16:	.byte	1
	tile26:	.byte	3

	tile7:	.byte	2
	tile17:	.byte	1
	tile27:	.byte	3

	tile8:	.byte	2
	tile18:	.byte	4	// special
	tile28:	.byte	3

	tile9:	.byte	2
	tile19:	.byte	1
	tile29:	.byte	3

	doTile:	.byte	1

	emptyTile:	.byte	0
	codeLog:	.asciz	"code: (%d, %d)\n"
