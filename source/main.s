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
	
	    mov r4, #0 //initial state is 0
startmenuloop:
MOV	r0, #2000
	BL	delayMicroseconds
    cmp r4, #0 //check state
    mov r1, #720
    mov r2, #960
    ldreq	r0, =startselect
    ldrne	r0, =quitselect
    BL	drawTile
    
    BL	readSNES //check button press
    
    CMP	r0, #512		// L
	MOVEQ r4, #0
	CMP	r0, #256		// R
	MOVEQ r4, #1
	cmp r0, #128  		//A
	BNE startmenuloop
	
	//branch based on state
	cmp r4, #1
	BNE startmenuloop
    //insert code to clear screen here
	B haltLoop$
	

	// Back
	MOV	r0, #4
	MOV	r1, #4
	MOV	r2, #0x0
	MOV	r3, #704
	MOV	r4, #960
	BL	makeTile

	// foreground
	MOV	r0, #4
	MOV	r1, #4
	LDR	r2, =cIndigo
	MOV	r3, #720
	MOV	r4, #896
//	BL	makeTile

	//walls
	MOV	r0, #4
	MOV	r1, #4
	MOV	r2, #0x007770
	MOV	r3, #31
	MOV	r4, #960
	BL	makeTile

	MOV	r0, #677
	MOV	r1, #4
	MOV	r2, #0x007770
	MOV	r3, #32
	MOV	r4, #960
	BL	makeTile

	MOV	r0, #4
	MOV	r1, #4
	MOV	r2, #0x007770
	MOV	r3, #704
	MOV	r4, #32
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
	MOV	r2, #932
	LDR	r3, =cWhite
	BL	drawWord
	POP	{pc}

paddle:
	PUSH	{r4-r9, lr}
	MOV	r8, #228	// default xstart

	paddleLoop:
			LDR	r0, =log
			MOV	r1, r8
			BL	printf

		BL	readSNES
		CMP	r0, #512		// L
		BEQ	moveLeft
		CMP	r0, #256		// R
		BNE	paddleLoop

		// move Right
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
	MOV	r6, #2		// color code

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
	CMP	r5, #5
	BLE	brickLoop

	POP	{r4-r9, pc}

.global $
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
