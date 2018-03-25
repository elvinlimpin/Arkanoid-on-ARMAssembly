.text
.global initScore
initScore:
	PUSH	{lr}

	// r0 - character
	// r1 - intial x
	// r2 - y
	// r3 - color

	LDR	r0, =scoreChar
	MOV	r1, #88
	MOV	r2, #864
	LDR	r3, =cWhite
	BL	drawWord
	POP	{pc}

.text
.global	initLives
initLives:
	PUSH	{lr}

	// r0 - character
	// r1 - intial x
	// r2 - y
	// r3 - color

	LDR	r0, =livesChar
	MOV	r1, #468
	MOV	r2, #864
	LDR	r3, =cWhite
	BL	drawWord
	POP	{pc}


.data
	scoreChar:	.asciz		"SCORE: "
	livesChar:	.asciz		"LIVES: "
