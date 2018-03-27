.global initBall
initBall:
	PUSH	{r4-r6, lr}
	MOV	r5, r0
	MOV	r6, r1

	MOV	r0, r5
	ADD	r1, r6, #12
	MOV	r2, #0x0000FF
	MOV	r3, #32
	MOV	r4, #24
	BL	makeTile

	ADD	r0, r5, #4
	ADD	r1, r6, #8
	MOV	r2, #0x000FF
	MOV	r3, #24
	MOV	r4, #32
	BL	makeTile

	POP	{r4-r6, pc}

.global testBall
testBall:
	PUSH	{lr}

	MOV	r0, #308
	MOV	r1, #730
	BL	initBall

	POP	{lr}
	MOV	pc, lr

//.global redrawBall
