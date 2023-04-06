	.data

	.global board
	.global speed
	.global row
	.global col
	.global prompt
	.global counter
	.global counter_str
	.global hit_prompt
	.global start_pos

board:					.string	"----------------------", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"|                    |", 0xA, 0xD
						.string	"----------------------", 0xA, 0xD

current_direction:				.byte 0x00   ;0=u, 1=d, 2=r, 3=l


	.text
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global timer_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler		; This is needed for Lab #6
	.global simple_read_character
	.global output_character	; This is from your Lab #4 Library
	.global read_string		; This is from your Lab #4 Library
	.global output_string		; This is from your Lab #4 Library
	.global uart_init		; This is from your Lab #4 Library
	.global int2string		; This is from our Lab #3 Library
	.global lab6
	.global ptr_to_speed


ptr_to_board:					.word board
ptr_to_prompt:					.word prompt
ptr_to_hit_prompt:				.word hit_prompt
ptr_to_counter_str:				.word counter_str
ptr_to_speed:					.word speed
ptr_to_counter:					.word counter
ptr_to_row:						.word row
ptr_to_col:						.word col
ptr_to_start_pos:				.word start_pos


lab6:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_row
	ldr r6, ptr_to_col
	ldr r7, ptr_to_counter


    bl uart_init
	bl uart_interrupt_init
	bl gpio_interrupt_init
	bl timer_interrupt_init

	MOV r0, r4
	BL output_string

	MOV r0, #0x0A
	BL output_character ; New line
	MOV r0, #0x0A
	BL output_character 	; New line
	MOV r0, #0x0D
	BL output_character 	; Reset line position

	LDR r0, ptr_to_board 	; Output board
	BL	output_string

	LDR r0, ptr_to_start_pos
	BL output_string

	MOV r0, #1
	LDR r1, ptr_to_speed				; Move the initial speed into r0
	STRB r0, [r1]		; Store the initial speed at the pointer

	MOV r0, #11				; Update row to starting position
 	STRB r0, [r5]

 	MOV r0, #11				; Update col to starting position
 	STRB r0, [r6]

NOHIT:

	LDRB r0, [r5]			; Check to see if the ball hit the leftmost wall
	CMP r0, #0
	BEQ HIT

	LDRB r0, [r5]			; Check to see if the ball hit the rightmost wall
	CMP r0, #21
	BEQ HIT

	LDRB r0, [r6]			; Check to see if the ball hit the top wall
	CMP r0, #0
	BEQ HIT

	LDRB r0, [r6]			; Check to dee if the bal hit the bottom wall
	CMP r0, #21
	BEQ HIT

	B NOHIT

HIT:

	MOV r0, #0
	LDR r1, ptr_to_speed	; Stop the ball from moving
	STRB r0, [r1]

	MOV r0, #0x0A
	BL output_character 	; New line
	MOV r0, #0x0D
	BL output_character 	; Reset line position

	LDR r0, ptr_to_hit_prompt ; Print out the hit prompt
	BL output_string

	LDR r1, ptr_to_counter	; Load the counter into r0
	LDRB r0, [r1]
	LDR r1, ptr_to_counter_str	; Move address of where we want to store conversion in r1
	BL int2string				; COnvert the counter int to a string

	MOV r0, r1				; Move the converted string address into r0
	BL output_string		; Output move counter



	POP {lr}		; Restore lr from the stack
	MOV pc, lr
