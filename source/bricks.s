.section .text

.global getBrickState
getBrickState:
	PUSH	{r4-r9, lr}
	MOV	r4, r0
	MOV	r5, r1

	//convert to brick state
		SUB	r4, r0, #36
		ASR	r0, r4, #7	// getting rid of the remainder ensures
		LSL	r0, r4, #1	// that y points to the edge, not half way

		SUB	r5, r5, #32
		ASR	r1, r4, #5

		BL	codeToTile

	// return brick state
	MOV	r0, r8
	POP	{r4-r9, pc}

.global	hitBrick
hitBrick:
	PUSH	{r4-r9, lr}
	BL	getBrickState
	//change brick state


	//recolor brick

	// return brick state
	MOV	r0, r8
	POP	{r4-r9, pc}


// params
//r0 - xcode
//r1 - r code

// return
// r0 - brickStateAddress
codeToTile:
	PUSH	{lr}

	CMP	r1, #1
	BLT	fromZero
	BEQ	fromTen
	// BG	from Twenty
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


// 0 - broken
// 1 - 1 hit to break
// 2 - 2 hits to break
// 3 - 3 hits to break
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

	tile4:	.byte	2	// turns to special
	tile14:	.byte	1
	tile24:	.byte	3	// turns to special

	tile5:	.byte	2
	tile15:	.byte	1
	tile25:	.byte	3

	tile6:	.byte	2	// turns to special
	tile16:	.byte	1
	tile26:	.byte	3	// turns to special

	tile7:	.byte	2
	tile17:	.byte	1
	tile27:	.int	3

	tile8:	.byte	2
	tile18:	.byte	4	// special
	tile28:	.byte	3

	tile9:	.byte	2
	tile19:	.byte	1
	tile29:	.byte	3

