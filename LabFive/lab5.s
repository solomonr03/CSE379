	.data

	.global prompt
	.global sw1_pressed_prompt
	.global mydata
	.global mydata_sw1

prompt:					.string "Press SW1 on Tiva Board or any key on the keyboard, press 'q' when finished.", 0
sw1_counter_prompt:		.string "SW1 COUNTER: ", 0
key_counter_prompt:		.string "KEY COUNTER: ", 0
bar_prompt:				.string "COUNTER BAR GRAPH", 0
sw1_bar:				.string "SW1: ", 0
key_bar:				.string "KEY: ", 0
sw1_count_str:			.string "Placeholder for string version of sw1 count". 0
key_count_str:			.string "Placeholder for string version of key count". 0
mydata_key:				.byte	0x00	; This is where you can store data.
							; The .byte assembler directive stores a byte
							; (initialized to 0x20) at the label mydata.
							; Halfwords & Words can be stored using the
							; directives .half & .word
mydata_sw1: 			.byte 0x00

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
EN0:		.equ 0x100
UARTIM: 	.equ 	0x038
UARTICR:	.equ	0x044

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

ptr_to_prompt:					.word prompt
ptr_to_mydata_key:				.word mydata_key
ptr_to_mydata_sw1:				.word mydata_sw1
ptr_to_sw1_counter_prompt: 		.word sw1_counter_prompt
ptr_to_key_counter_prompt: 		.word key_counter_prompt
ptr_to_bar_prompt:				.word bar_prompt
ptr_to_sw1_bar:					.word sw1_bar
ptr_to_key_bar:					.word key_bar
ptr_to_sw1_count_str:			.word sw1_count_str
ptr_to_key_count_str:			.word key_count_str

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

uart_init:
	PUSH {lr} ; Store register lr on stack

	 ; Your code is placed here

	MOV r0, #0xE618
	MOVT r0, #0x400F
	MOV r1, #1
	STR r1, [r0]

	MOV r0, #0xE608
	MOVT r0, #0x400F
	MOV r1, #1
	STR r1, [r0]

	MOV r0, #0xC030
	MOVT r0, #0x4000
	MOV r1, #0
	STR r1, [r0]

	MOV r0, #0xC024
	MOVT r0, #0x4000
	MOV r1, #8
	STR r1, [r0]

	MOV r0, #0xC028
	MOVT r0, #0x4000
	MOV r1, #44
	STR r1, [r0]

	MOV r0, #0xCFC8
	MOVT r0, #0x4000
	MOV r1, #0
	STR r1, [r0]

	MOV r0, #0xC02C
	MOVT r0, #0x4000
	MOV r1, #0x60
	STR r1, [r0]

	MOV r0, #0xC030
	MOVT r0, #0x4000
	MOV r1, #0x301
	STR r1, [r0]

	MOV r0, #0x451C
	MOVT r0, #0x4000
	LDR r1, [r0]
	ORR r1, r1, #0x03
	STR r1, [r0]

	MOV r0, #0x4420
	MOVT r0, #0x4000
	LDR r1, [r0]
	ORR r1, r1, #0x03
	STR r1, [r0]

	MOV r0, #0x452C
	MOVT r0, #0x4000
	LDR r1, [r0]
	ORR r1, r1, #0x11
	STR r1, [r0]

	POP {lr}
	MOV pc, lr

uart_interrupt_init:

	; Your code to initialize the UART0 interrupt goes here
	MOV r0, #0xC000
	MOVT r0, #0x4000
	LDRB r1, [r0, #UARTIM]
	ORR r1, r1, #0x10
	STRB r1, [r0, #UARTIM]

	MOV r0, #0xE000
	MOVT r0, #0xE000
	LDRB r1, [r0, #EN0]
	ORR r1, r1, #0x20
	STRB r1, [r0, #EN0]

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
	MOV r2, #0x0000
	MOVT r2, #0x4000
	ORR r1, r1, r2
	STR r1, [r0]

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
	PUSH {r4-r11,LR}

	MOV r0, #0xC000
	MOVT r0, #0x4000		; Set bit 4 in UART Interrupt Clear Register
	LDRB r1, [r0, #UARTICR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #UARTICR]


	LDRB r1, [r6] 		; Load value at ptr into r1
	ADD r1, r1, #1		; Increment the uart counter
	STRB r1, [r6]		; Store the new value at ptr

	MOV r0, #0x0C
	BL output_character ; Clear the screen

	MOV r0, r4			; Move the prompt into r0
	BL output_string 	; Display the prompt

	MOV r0, #0x0A
	BL output_character ; New line
	BL output_character ; New line
	MOV r0, #0x0D
	BL output_character ; Reset line position


	MOV r0, r10		; Move the uart prompt into r0
	BL output_string	; Display uart prompt

	LDRB r0, [r6]		; Move the address of the uart num
	LDR r1, ptr_to_key_count_str ; Load string placeholder location
	BL int2string
	MOV r0, r1
	BL output_string	; Output the uart num

	MOV r0, #0x0A
	BL output_character ; New line
	MOV r0, #0x0D
	BL output_character ; Reset line position

	MOV r0, r9		; Move the gpio prompt into r0
	BL output_string	; Display gpio prompt

	LDRB r0, [r5]		; Move the address of the gpio num
	LDR r1, ptr_to_sw1_count_str ; Load string placeholder location
	BL int2string
	MOV r0, r1
	BL output_string	; Output the gpio num

	MOV r0, #0x0A
	BL output_character ; New line
	BL output_character ; New line
	MOV r0, #0x0D
	BL output_character ; Reset line position

	MOV r0, r11			; Move the address of the bar title prompt into r0
	BL output_string		; Output bar title

	MOV r0, #0x0A
	BL output_character ; New line
	MOV r0, #0x0D
	BL output_character ; Reset line position

	MOV r0, r8			; Move the uart label address into r0
	BL output_string 		; Display the uart label

	LDRB r1, [r6]		; Initialize counter

UARTBAR:
	MOV r0, #0x58		; Move the ASCII value for 'X' into r0
	BL output_character		; Output bar for bar graph
	SUB r1, r1, #1		; Decrement counter
	CMP r1, #0			; Check if counter is at zero if not break do it again
	BNE UARTBAR


	MOV r0, #0x0A
	BL output_character ; New line
	MOV r0, #0x0D
	BL output_character ; Reset line position

	MOV r0, r7			; Move the gpio label address into r0
	BL output_string 		; Display the gpio label

	LDRB r1, [r5]		; Initialize counter
	CMP r1, #0
	BEQ NOBAR

GPIOBAR:
	MOV r0, #0x58		; Move the ASCII value for 'X' into r0
	BL output_character		; Output bar for bar graph
	SUB r1, r1, #1		; Decrement counter
	CMP r1, #0			; Check if counter is at zero if not break do it again
	BNE GPIOBAR
NOBAR:
	POP {r4-r11,LR}


	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r11,LR}

	; Move base address of Port F to r0
	MOV r0, #0x5000
	MOVT r0, #0x4002

	; Clear SW1 Interrupt
	LDRB r1, [r0, #GPIOICR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPIOICR]

	; Print that SW1 has been pressed to console
	;MOV r0, r7
	;BL output_string

	; Increment SW1 press counter
	LDRB r2, [r5]
	ADD r2, r2, #1
	STRB r2, [r5]

	; Clear screen
	MOV r0, #0xC
	BL output_character

	; Print directions
	MOV r0, r4
	BL output_string
	MOV r0, #0xD
	BL output_character ; Restart line position
	MOV r0, #0xA
	BL output_character ; New line
	BL output_character ; New line

	; Print key counter
	;MOV r0, r10
	;BL output_string ; Print key counter text
	;LDRB r3, [r6]
	;PUSH {r3}
	;ADD r3, r3, #0x30
	;MOV r0, r3
	;BL output_character
	;POP {r3}
	;MOV r0, #0xD
	;BL output_character ; Restart line position
	;MOV r0, #0xA
	;BL output_character ; New line

	; Print key counter (multi-digit)
	MOV r0, r10
	BL output_string ; Print key counter text
	LDRB r0, [r6] ; Load number into r0
	LDR r1, ptr_to_key_count_str ; Load string placeholder location in r1
	BL int2string ; Call int2string with r6 as number and 'ptr_to_key_count_str' as string location
	MOV r0, r1 ; Move string version of counter to r0
	BL output_string ; Print counter as string
	MOV r0, #0xD
	BL output_character ; Restart line position
	MOV r0, #0xA
	BL output_character ; New line

	; Print SW1 counter
	;MOV r0, r9
	;BL output_string
	;PUSH {r2}
	;ADD r2, r2, #0x30
	;MOV r0, r2
	;BL output_character
	;POP {r2}
	;MOV r0, #0xD
	;BL output_character ; Restart line position
	;MOV r0, #0xA
	;BL output_character ; New line
	;BL output_character ; New line

	; Print SW1 counter (multi-digit)
	MOV r0, r9
	BL output_string ; Print sw1 counter text
	MOV r0, r2 ; Load number into r0
	LDR r1, ptr_to_sw1_count_str ; Load string placeholder location in r1
	BL int2string ; Call int2string with r2 as number and 'ptr_to_sw1_count_str' as string location
	MOV r0, r1 ; Move string version of counter to r0
	BL output_string ; Print counter as string
	MOV r0, #0xD
	BL output_character ; Restart line position
	MOV r0, #0xA
	BL output_character ; New line
	BL output_character ; New line

	; Print bar graph title
	MOV r0, r11
	BL output_string
	MOV r0, #0xD
	BL output_character ; Restart line position
	MOV r0, #0xA
	BL output_character ; New line

	; Print key bar graph section
	MOV r0, r8
	BL output_string
	; Print 'X' however many times keys were pressed
	PUSH {r3}
LOOP_1:
	CMP r3, #0
	BEQ END_1
	MOV r0, #0x58
	BL output_character
	SUB r3, r3, #1
	B LOOP_1
END_1:
	POP {r3}

	MOV r0, #0xD
	BL output_character ; Restart line position
	MOV r0, #0xA
	BL output_character ; New line

	; Print SW1 bar graph section
	MOV r0, r7
	BL output_string
	; Print 'X' however many times SW1 was pressed
	PUSH {r2}
LOOP_2:
	CMP r2, #0
	BEQ END_2
	MOV r0, #0x58
	BL output_character
	SUB r2, r2, #1
	B LOOP_2
END_2:
	POP {r2}


	POP {r4-r11,LR}

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

	MOV r0, #0xC000
	MOVT r0, #0x4000
	LDRB r0, [r0]

	MOV PC,LR      	; Return


output_character:
	PUSH {lr, r1, r2, r3} ; Store register lr on stack

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

	POP {lr, r1, r2, r3}

	MOV PC,LR      	; Return


read_string:
	PUSH {lr} ; Store register lr on stack
	PUSH {r1, r2, r3}
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

	POP {r1, r2, r3}
	POP {lr}

	MOV PC,LR      	; Return


output_string:
	PUSH {lr} ; Store register lr on stack
	PUSH {r0, r2}
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
	POP {r0, r2}
	POP {lr}

	MOV PC,LR      	; Return


int2string:
	PUSH {lr}   ; Store register lr on stack

			; Your code for your int2string routine is placed here
		MOV r2, #10
		MOV r4, #0
		MOV r5, #0

		PUSH {r0}
COUNT:		ADD r4, r4, #1
		SDIV r0, r0, r2
		CMP r0, #0
		BNE COUNT
		POP {r0}
		STRB r5, [r1, r4]
		SUB r4, r4, #1

MOD:		SDIV r3, r0, r2
		MUL r3, r3, r2		;Mod the intial integer
		SUB r3, r0, r3
		SDIV r0, r0, r2


		ADD r3, r3, #0x30	;Add hex 30 to convert integer to string
		STRB r3, [r1, r4]		;Store string at r1
		SUB r4, r4, #1
		CMP r0, #0			;If integer is not 0 mod it again and convert it to string
		BNE MOD


	POP {lr}
	mov pc, lr


string2int:
	PUSH {lr}   ; Store register lr on stack

			; Your code for your string2int routine is placed here
	MOV r1, #0 ; Initalize parser
	MOV r2, #-1 ; Initialize postion counter *starting at -1
	MOV r5, #0 ; Intialize total register
LOOP_1:   ;Finds how many digits are in the string
	LDRB r3, [r0, r1] ; Loads the [r1]th character from  memory into r3
	CMP r3, #0
	BEQ EXIT_L1 ; If r3 is a null character, stop loop. Amount of digits found
	ADD r1, r1, #1 ; Increment parser
	ADD r2, r2, #1 ; Increment position counter
	B LOOP_1 ; Restart loop_1
EXIT_L1:
	MOV r1, #0 ; Reset parser
LOOP_2: ; Builds the int by multiplying each digit by 10 to the power of its postion and adding it to total output number
	LDRB r3, [r0, r1] ; Loads the [r1]th character from  memory into r3
	CMP r3, #0
	BEQ EXIT_L2 ; If r3 is a null character, stop loop_2. Int found
	SUB r3, r3, #0x30 ; Subtract ASCII value by 0x30 to convert into int
	MOV r4, #1; ; Save 1 to r4 if in the 0th position
	CMP r2, #0
	BEQ SKIP ; Skip finding power of 10 if in the 0th postion
	MOV r4, #10 ; Save 10 to r4 to find power of 10
	PUSH {r2, r1} ; Preserve postion of current digit and parser register while finding power of 10
LOOP_2_1: ; Finds 10 to the power of the position my mulipying 10 by itself multiple times
	CMP r2, #1
	BEQ EXIT_L2_1 ; If power of 10 is found, exit loop
	MOV r1, #10 ;
	MUL r4, r4, r1 ; Muliply 10 by itself
	SUB r2, r2, #1 ; Decrement r2 as a counter of how many times we need to multiply
	B LOOP_2_1 ; Restart loop2_1
EXIT_L2_1:
	POP {r2, r1} ; Get back the postion we are in and parser register
SKIP:
	MUL r3, r3, r4 ; Mulitply digit of focus by some power of 10 to get it in the desired digit
	ADD r5, r5, r3 ; Add digit in the correct position to total output int
	ADD r1, r1, #1 ; Increment parser
	SUB r2, r2, #1 ; Decrement position count
	B LOOP_2 ; Restart loop_2
EXIT_L2:
	MOV r0, r5 ; Move int to output register

	POP {lr}
	mov pc, lr


	.end
