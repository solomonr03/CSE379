	.data

	.global prompt
	.global sw1_counter_prompt
	.global key_counter_prompt
	.global bar_prompt
	.global sw1_bar
	.global key_bar
	.global mydata_key
	.global mydata_sw1

prompt:					.string "Press SW1 on Tiva Board or any key on the keyboard, press 'q' when finished.", 0
sw1_counter_prompt:		.string "SW1 COUNTER: ", 0
key_counter_prompt:		.string "KEY COUNTER: ", 0
bar_prompt:				.string "COUNTER BAR GRAPH", 0
sw1_bar:				.string "SW1: ", 0
key_bar:				.string "KEY: ", 0
mydata_key:				.byte	0x00	; This is where you can store data.
							; The .byte assembler directive stores a byte
							; (initialized to 0x20) at the label mydata.
							; Halfwords & Words can be stored using the
							; directives .half & .word
mydata_sw1: 			.byte 0x00

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


ptr_to_prompt:					.word prompt
ptr_to_mydata_key:				.word mydata_key
ptr_to_mydata_sw1:				.word mydata_sw1
ptr_to_sw1_counter_prompt: 		.word sw1_counter_prompt
ptr_to_key_counter_prompt: 		.word key_counter_prompt
ptr_to_bar_prompt:				.word bar_prompt
ptr_to_sw1_bar:					.word sw1_bar
ptr_to_key_bar:					.word key_bar


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
