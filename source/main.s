// Elvin Limpin			Jocelyn Donnelly
// 30018832			30016617
// SNES Assignment


.section    .text

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
	BL	Init_SNES
	BL	Init_Frame

	MOV	r0, #200
	MOV	r1, #200
	MOV	r2, #0xFFFFFF

	BL	makePx

	BL	terminate

	terminate:				// infinite loop ending program
		LDR	r0, =msgTerminate
		BL	printf

		haltLoop$:
			B	haltLoop$

	gBase	.req	r10
	prevbtn	.req	r9

.align 2
.section .data
	msgCreator:
		.asciz 			"Created by: Elvin Limpin and Jocelyn Donnelly\n"

	msgTerminate:
		.asciz	 		"Program is terminating...\n"
	here:
		.asciz			"Is: %d\n"

	frameBufferInfo:
		.int 0		// frame buffer pointer
		.int 0		// screen width
		.int 0		// screen height
		
	.align 4	
	font: .incbin "font.bin" //font is base address of font map

.global gpioBaseAddress
gpioBaseAddress:
	.int	0
