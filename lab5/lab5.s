	.data

	.global prompt
	.global sw1_pressed_prompt
	.global mydata
	.global mydata_sw1

prompt:					.string "Your prompt with instructions is place here", 0
sw1_pressed_prompt:		.string "SW1 has been pressed", 0
mydata:					.byte	0x20	; This is where you can store data.
							; The .byte assembler directive stores a byte
							; (initialized to 0x20) at the label mydata.
							; Halfwords & Words can be stored using the
							; directives .half & .word
mydata_sw1: .byte 0x00

	.text

DIR:		.equ 0x400
DEN:		.equ 0x51C
PUR:		.equ 0x510
GPIOIS:		.equ 0x404
GPIOIBE:	.equ 0x408
GPIOEV:		.equ 0x40C
GPIOIM:		.equ 0x410
GPIOICR:	.equ 0x41C
U0FR: 		.equ 0x18

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
	.global lab5

ptr_to_prompt:				.word prompt
ptr_to_mydata:				.word mydata
ptr_to_mydata_sw1:			.word mydata_sw1
ptr_to_sw1_pressed_prompt: 	.word sw1_pressed_prompt

lab5:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata
	ldr r6, ptr_to_mydata_sw1
	ldr r7, ptr_to_sw1_pressed_prompt


        bl uart_init
	bl uart_interrupt_init
	bl uart_interrupt_init

	; This is where you should implement a loop, waiting for the user to
	; enter a q, indicating they want to end the program.

	POP {lr}		; Restore lr from the stack
	MOV pc, lr



uart_interrupt_init:

	; Your code to initialize the UART0 interrupt goes here

	MOV pc, lr


gpio_interrupt_init:

	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.

	; Enable Clock for Port F
	MOV r0, #0xE608
	MOVT r0, #0x400F
	LDRB r1, [r0]
	ORR r1, r1, #0x20
	STRB r1, [r0]

	; Enable processor to be able to receive interrupt signals from SW1
	MOV r0, #0xE100
	MOVT r0, #0xE000
	LDR r1, [r0]
	MOVT r2, #0x4000
	MOV r2, #0x0000
	ORR r1, r1, r2
	STRB r1, [r0]

	; Move base address of Port F to r0
	MOV r0, #0x5000
	MOVT r0, #0x4002

	; Enable Pull-Up Register for SW1 (Port F Pin 4)
	LDRB r1, [r0, #PUR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #PUR]

	; Set SW1 pin to input
	LDRB r1, [r0, #DIR]
	AND r1, r1, #0xEF
	STRB r1, [r0, #DIR]

	; Enable digital for SW1 pin
	LDRB r1, [r0, #DEN]
	ORR r1, r1, #0x10
	STRB r1, [r0, #DEN]

	; Set SW1 Interrupt to Edge Sensitivity
	LDRB r1, [r0, #GPIOIS]
	AND r1, r1, #0xEF
	STRB r1, [r0, #GPIOIS]

	; Set SW1 Interrupt to only have 1 Edge Sensitivity
	LDRB r1, [r0, #GPIOIBE]
	AND r1, r1, #0xEF
	STRB r1, [r0, #GPIOIBE]

	; Set SW1 Interrupt to have the Falling Edge as a trigger
	LDRB r1, [r0, #GPIOEV]
	AND r1, r1, #0xEF
	STRB r1, [r0, #GPIOEV]

	; Enable SW1 Interrupt to be able to send signals to the processor
	LDRB r1, [r0, #GPIOIM]
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPIOIM]

	MOV pc, lr


UART0_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	; Move base address of Port F to r0
	MOV r0, #0x5000
	MOVT r0, #0x4002

	; Clear SW1 Interrupt
	LDRB r1, [r0, #GPIOICR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPIOICR]

	; Print that SW1 has been pressed to console
	MOV r0, r7
	BL output_string

	; Increment SW1 press counter
	LDRB r2, [r6]
	ADD r2, r2, #1
	STRB r2, [r6]

	BX lr       	; Return


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed
	; for Lab #5, but will be used in Lab #6.  It is referenced here
	; because the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.

	BX lr       	; Return


simple_read_character:

	MOV PC,LR      	; Return


output_character:
	PUSH {lr} ; Store register lr on stack

	 ; Your code is placed here

		; Your code to output a character to be displayed in PuTTy
		; is placed here.  The character to be displayed is passed
		; into the routine in r0.
		MOV r1, #0xC000 ; Save bottom half of UART address to r1
		MOVT r1, #0x4000 ; Save top half of UART address to r1

check:	; Checks if data was recieved in data register
		LDRB r2, [r1, #U0FR] ; Loads UART flag register to r2
		MOV r3, #0x20 ; Create masking register in r3
		AND r2, r2, r3 ; Mask r2 to isolate TxFF
		CMP r2, #0x00 ; Check if TxFF flag is 0
		BNE check ; Branch if TxFF is 1 which meand the UART data register is occupied

		; Start to transmit data to UART data register
		STRB r0, [r1] ; Stores r0 to UART data register

	POP {lr}

	MOV PC,LR      	; Return


read_string:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
		MOV r1, #0
LOOP:	PUSH {r0, r1}
		BL simple_read_character
		MOV r2, r0
		CMP r2, #0x0D
		BEQ FINN
		PUSH {r2}
		BL output_character
		POP {r2}
		POP {r0, r1}
		STRB r2, [r0, r1]
		ADD r1, r1, #1
		B LOOP

FINN:	MOV r3, #0
		POP {r0, r1}
		STRB r3, [r0, r1]

	POP {lr}

	MOV PC,LR      	; Return


output_string:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
			; Your code for your output_string routine is placed here
LOOP__2: ; Parses string in memory and sends each character to UART individually to be outputted
	LDRB r2, [r0] ; Loads the [r0]th character from  memory into r2
	CMP r2, #0
	BEQ EXIT ; If r2 is a null character, stop loop. The full string has been sent to UART
	PUSH {r0} ; Preserve r0 whil output_character manipulates it
	MOV r0, r2 ; Move character to input register of output_character
	BL output_character ; Sends character to UART
	POP {r0} ; Get r0 as parser register back
	ADD r0, r0, #0x01 ; Add 1 to r0 as parser register
	B LOOP__2 ; Restart loop__2
EXIT:
	POP {lr}

	MOV PC,LR      	; Return


	.end
