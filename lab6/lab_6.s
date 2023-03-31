	.data

	.global board

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

direction:				.byte 0x00   ;0=u, 1=d, 2=r, 3=l


	.text
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler		; This is needed for Lab #6
	.global simple_read_character
	.global output_character	; This is from your Lab #4 Library
	.global read_string		; This is from your Lab #4 Library
	.global output_string		; This is from your Lab #4 Library
	.global uart_init		; This is from your Lab #4 Library
	.global int2string		; This is from our Lab #3 Library
	.global lab5


ptr_to_board:					.word board


lab5:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata_sw1
	ldr r6, ptr_to_mydata_key
	ldr r7, ptr_to_sw1_bar
	ldr r8, ptr_to_key_bar
	ldr r9, ptr_to_sw1_counter_prompt
	ldr r10, ptr_to_key_counter_prompt
	ldr r11, ptr_to_bar_prompt


    bl uart_init
	bl uart_interrupt_init
	bl gpio_interrupt_init

	; This is where you should implement a loop, waiting for the user to
	; enter a q, indicating they want to end the program.
	MOV r0, r4
	BL output_string

NOQ:

	BL simple_read_character
	CMP r0, #0x71
	BNE NOQ

	POP {lr}		; Restore lr from the stack
	MOV pc, lr
