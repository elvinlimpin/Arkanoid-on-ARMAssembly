.section	.text

.global drawPaddleDrop
drawPaddleDrop:
	PUSH	{r4-r8, lr}

	

	POP	{r4-r8, pc}



.section	.data

	willDropPaddle:		.int	0
	willDropSlowBall:	.int	0
