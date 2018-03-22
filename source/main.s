// SNES Assignment
// Elvin Limpin			Jocelyn Donnelly
// 30018832			30016617


.section    .text

//constants

.global main
main:
	gBase	.req	r10
	prevbtn	.req	r9

	// Creator Credits
	LDR	r0, =msgCreator		// get the creator
	BL	printf

//cell 32x32

	// Get GPIO base address
	// Store in memory for future use
	// Store base in variable
	BL	initSNES
	BL	Init_Frame

	MOV	r0, #20
	MOV	r1, #20
	LDR	r2, =cIndigo
	MOV	r3, #720
	MOV	r4, #480
	BL	makeTile

	MOV	r0, #270	// x
	MOV	r1, #420	// y
	MOV	r2, #0xFF0000	// color
	MOV	r3, #180	// length
	MOV	r4, #16		// height
	BL	makeTile

	BL	drawScore

	BL	paddle

	BL	terminate

	terminate:				// infinite loop ending program
		LDR	r0, =msgTerminate
		BL	printf

		haltLoop$:
			B	haltLoop$

	gBase	.req	r10
	prevbtn	.req	r9

drawScore:
	PUSH	{lr}

	// r0 - character
	// r1 - intial x
	// r2 - y
	// r3 - color

	LDR	r0, =scoreChar
	MOV	r1, #32
	MOV	r2, #450
	LDR	r3, =cWhite
	BL	drawWord
	POP	{pc}

paddle:
	PUSH	{r4-r9, lr}
	MOV	r8, #270	// default xstart

	paddleLoop:
		MOV	r0, #2000
		BL	delayMicroseconds

			LDR	r0, =log
			MOV	r1, r8
			BL	printf

		BL	readSNES
		CMP	r0, #512		// L
		BEQ	moveLeft
		CMP	r0, #256		// R
		BNE	paddleLoop

		// move Right
		CMP	r8, #540
		BGT	paddleLoop


		MOV	r0, r8
		MOV	r1, #420
		LDR	r2, =cIndigo
		MOV	r3, #8
		MOV	r4, #16
		BL	makeTile

 		MOV	r0, r8
		ADD	r0, #180
		MOV	r1, #420
		MOV	r2, #0xFF00000
		MOV	r3, #8
		BL	makeTile

		ADD	r8, r8, #8

			LDR	r0, =log
			MOV	r1, r8
			BL	printf

		BL	paddleLoop

		moveLeft:
			CMP	r8, #32
			BLT	paddleLoop

			MOV	r0, r8
			ADD	r0, r0, #172
			MOV	r1, #420
			LDR	r2, =cIndigo
			MOV	r3, #8
			BL	makeTile

			MOV	r0, r8
			SUB	r0, r0, #8
			MOV	r1, #420
			MOV	r2, #0xFF00000
			MOV	r3, #180
			BL	makeTile

			SUB	r8,r8, #8

				LDR	r0, =log
				MOV	r1, r8
				BL	printf

			BL	paddleLoop

	POP	{r4-r9, pc}


$:	PUSH	{r0-r3, lr}
	LDR	r0, =log$
	BL	printf
	POP	{r0-r3, pc}

.section .data
	scoreChar:	.asciz		"SCORE: "

.align 2

	msgCreator:
		.asciz 			"Created by: Elvin Limpin and Jocelyn Donnelly\n"

	msgTerminate:
		.asciz	 		"Program is terminating...\n"

	log$:
		.asciz			"here\n"

	log:
		.asciz			"log: %d\n"

	cWhite:
		.word	0xFFFFFFFF

	cIndigo:
		.word 0x4B0082FF

	frameBufferInfo:
		.int 0		// frame buffer pointer
		.int 0		// screen width
		.int 0		// screen height

.global gpioBaseAddress
gpioBaseAddress:
	.int	0
