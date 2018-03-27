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

	MOV	r4, #0 //initial state is 0
	B	startMenuLoop

	startMenuLoop:
		BL	$

	    	CMP 	r4, #0 //check state

    		MOV 	r1, #720
    		MOV 	r2, #960
    		LDREQ	r0, =startselect
    		LDRNE	r0, =quitselect

		BL	drawTile

		MOV	r0, #5000
		BL	readSNES //check button press

			CMP	r0, #2048		// U
			MOVEQ 	r4, #0
			CMP	r0, #1024		// D
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

    BL blackScreen
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

.global pauseMenu
pauseMenu:
		PUSH	{r4, lr}
		MOV	r4, #0

		MOV	r0, #10000
		BL	delayMicroseconds
	pauseMenuLoop:
		BL	$

	   	CMP 	r4, #0 //check state

    		MOV 	r1, #200
    		MOV 	r2, #200
 
    		LDREQ	r0, =pauserestart
    		LDRNE	r0, =pausequit

		Import: BL	drawCenterTile

		MOV	r0, #5500
		BL	readSNES //check button press

			CMP	r0, #2048		// U
			MOVEQ 	r4, #0
			CMP	r0, #1024		// D
			MOVEQ	r4, #1
			CMP	r0, #4096		// Start
			BLEQ	clearScreen
			POPEQ	{r4, pc}
			CMP	r0, #128  		//A

		BNE pauseMenuLoop

		//branch based on state
		CMP	r4, #0
		POP	{r4, r0}
		BNE	main
		BEQ	makeGame

clearScreen:
	PUSH	{r4,r5, lr}
	
	MOV r4, #260 //start x position of where menu is drawn
	MOV r5, #380 //start y position of where meun is drawn
	
clearScreenLoop:
    MOV r0, r4
    MOV r1, r5
    MOV r2, #0
    BL drawPx
    
    ADD r4, r4, #1
    CMP r4, #460
    MOVEQ	r4, #260
    ADDEQ   r5, r5, #1
    
    CMP		r5, #580
    BLT		clearScreenLoop
    

	POP	{r4, r5, pc}

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
		.int	0xFFFFFF

	.global cIndigo
	cIndigo: c2:
		.int 	0x4B0082

	.global cGreen
	cGreen: c3:
		.int	0x00FF00

	.global cYellow
	cYellow:
		.int	0xFFFF00

.global gpioBaseAddress
gpioBaseAddress:
	.int	0
