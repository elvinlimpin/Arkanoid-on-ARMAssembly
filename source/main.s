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
		BEQ	makeGame
	   //insert code to clear screen here

.global terminate
terminate:				// infinite loop ending program
	LDR	r0, =msgTerminate
	BL	printf

	haltLoop$:
		B	haltLoop$

	gBase	.req	r10
	prevbtn	.req	r9

// logger
.global $
$:	PUSH	{r0-r3, lr}
	LDR	r0, =log$
	BL	printf
	POP	{r0-r3, pc}

.global initMenu
initMenu:
	B terminate


.section .data

.align 2

	msgCreator:
		.asciz 			"Created by: Elvin Limpin and Jocelyn Donnelly\n"

	msgTerminate:
		.asciz	 		"Program is terminating...\n"

	log$:
		.asciz			"logger invoked\n"
	.global log
	log:
		.asciz			"log: %d\n"

	frameBufferInfo:
		.int 0		// frame buffer pointer
		.int 0		// screen width
		.int 0		// screen height


	.global cWhite
	cWhite:	c1:
		.word	0xFFFFFFFF

	.global cIndigo
	cIndigo: c2:
		.word 	0x4B0082FF

	.global cGreen
	cGreen: c3:
		.word	0x00FF00

.global gpioBaseAddress
gpioBaseAddress:
	.int	0

