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

	// Get GPIO base address
	// Store in memory for future use
	// Store base in variable
	BL	initSNES
	BL	Init_Frame

	MOV r4, #0 //initial state is 0
	B	startMenuLoop

	startMenuLoop:
		BL	$

	    	CMP 	r4, #0 //check state

    		MOV 	r1, #720
    		MOV 	r2, #960
    		LDREQ	r0, =startselect
    		LDRNE	r0, =quitselect

		BL	drawTile

		MOV	r0, #2000
		BL	readSNES //check button press

			CMP	r0, #512		// L
			MOVEQ 	r4, #0
			CMP	r0, #256		// R
			MOVEQ	r4, #1
			CMP	r0, #128  		//A

		BNE startMenuLoop

		//branch based on state
		CMP	r4, #0
		BNE	terminate

	   //insert code to clear screen here

makeGame:
	//walls
	MOV	r0, #4
	MOV	r1, #4
	MOV	r2, #0x007770
	MOV	r3, #704
	MOV	r4, #944
	BL	makeTile

	// foreground
	MOV	r0, #36
	MOV	r1, #36
	MOV	r2, #0x0
	MOV	r3, #640
	MOV	r4, #880
	BL	makeTile


	// paddle
	MOV	r0, #228	// x
	MOV	r1, #772	// y
	MOV	r2, #0x880000	// color
	MOV	r3, #192	// length
	MOV	r4, #32		// height
	BL	makeTile

	BL	drawScore
	BL	outerBrickLoop
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
	MOV	r1, #68
	MOV	r2, #864
	LDR	r3, =cWhite
	BL	drawWord
	POP	{pc}

paddle:
	PUSH	{r4-r9, lr}
	MOV	r8, #228	// default xstart
	MOV	r7, #1750
	paddleLoop:
			LDR	r0, =log
			MOV	r1, r8
			BL	printf

		MOV	r0, r7			// delay
		BL	readSNES
		MOV	r7, #1750

		CMP	r0, #32768		// select
		BEQ	initMenu

		CMP	r0, #512		// L
		BEQ	moveLeft
		CMP	r0, #256		// R
		BEQ	moveRight

		CMP	r0, #640		// L + A
		MOVEQ	r7, #750
		BEQ	moveLeft

		CMP	r0, #384		// R + A
		MOVEQ	r7, #750
		BNE	paddleLoop

		moveRight:
		CMP	r8, #484
		BGE	paddleLoop

			//repaint
			MOV	r0, r8
			MOV	r1, #772
			MOV	r2, #0x0
			MOV	r3, #32
			MOV	r4, #32
			BL	makeTile

			//paddle
 			MOV	r0, r8
			ADD	r0, r0, #32
			MOV	r1, #772
			MOV	r2, #0x8800000
			MOV	r3, #192
			BL	makeTile

			ADD	r8, r8, #32

				LDR	r0, =log
				MOV	r1, r8
				BL	printf

		BL	paddleLoop

		moveLeft:
			CMP	r8, #36
			BLE	paddleLoop

			// repaint
			MOV	r0, r8
			ADD	r0, r0, #160
			MOV	r1, #772
			MOV	r2, #0x0
			MOV	r3, #32
			BL	makeTile

			//paddle
			MOV	r0, r8
			SUB	r0, r0, #32
			MOV	r1, #772
			MOV	r2, #0x8800000
			MOV	r3, #192
			BL	makeTile

			SUB	r8,r8, #32

				LDR	r0, =log
				MOV	r1, r8
				BL	printf

			BL	paddleLoop

	POP	{r4-r9, pc}

outerBrickLoop:
	PUSH	{r4-r9, lr}
	MOV	r4, #0		// x position
	MOV	r5, #0		// y position
	MOV	r6, #0

	brickLoop:
		MOV	r0, r4
		MOV	r1, r5
		MOV	r2, r6
		BL	drawBrick
		ADD	r4, r4, #1
		CMP	r4, #9
		BLE	brickLoop

	MOV	r4, #0
	ADD	r5, r5, #1
	MOV	r6, #1
	CMP	r5, #5
	BLE	brickLoop

	POP	{r4-r9, pc}

.global $
$:	PUSH	{r0-r3, lr}
	LDR	r0, =log$
	BL	printf
	POP	{r0-r3, pc}


initMenu:
	


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

	cWhite:	c1:
		.word	0xFFFFFFFF

	cIndigo: c2:
		.word 	0x4B0082FF

	cGreen: c3:
		.word	0x00FF00

	frameBufferInfo:
		.int 0		// frame buffer pointer
		.int 0		// screen width
		.int 0		// screen height

.global gpioBaseAddress
gpioBaseAddress:
	.int	0
