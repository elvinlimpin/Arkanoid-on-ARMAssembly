//r0= address of image data
//r1=image width
//r2=image length
.section	.text
.global drawTile
drawTile:

	push	{r5-r9, lr}
	
	address	.req	r5
	width	.req	r6
	length	.req	r7
	x	.req	r8
	y	.req	r9

	//intialize offset, x and y to 0
	mov		x, #0
	mov		y, #0
	
	mov	address, r0
	
	mov	width,	r1
	mov	length,	r2
	
tileloop:

    //draw a pixel
    mov r0, x
    mov r1, y
    ldr r3, [address], #4
    mov r2, r3
    bl  DrawPx
    
    add x, x, #1
    
    cmp x, width
    MOVEQ x, #0
    ADDEQ y, y, #1
    
    cmp y, length
    BLT tileloop

  	.unreq	address
	.unreq	width
	.unreq	length
	.unreq	x
	.unreq	y
    
    pop		{r5-r9, pc}
