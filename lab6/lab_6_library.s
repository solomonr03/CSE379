	.data

	.global board
	.global prompt
	.global row
	.global col
	.global current_dir
	.global speed
	.global counter
	.global counter_str
	.global hit_prompt
	.global start_pos

prompt:				.string 	"Press w, a, s, d to move the ball, or press sw1 to increase speed", 0
hit_prompt:			.string 	"Moves the ball made: ", 0
counter_str:		.string 	"Placeholder for string version of counter", 0
speed:				.byte 		0x00
counter:			.byte 		0x00
row:				.byte		0x00
col:				.byte 		0x00
current_dir:		.byte 		0x02   ;0=u, 1=d, 2=r, 3=l
move_up:			.string		27, "[1A*", 0
move_down:			.string 	27, "[1B*", 0
move_right:			.string 	27, "[1C*", 0
move_left:			.string 	27, "[1D*", 0
start_pos:			.string		27, "[13;11H*",0

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
UARTIM: 	.equ 0x038
UARTICR:	.equ 0x044
GPTMCTL:	.equ 0x00C
GPTMCFG:	.equ 0x000
GPTMTAMR:	.equ 0x004
GPTMTAILR:	.equ 0x028
GPTMIMR:	.equ 0x018
GPTMICR:	.equ 0x024

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

ptr_to_current_dir:			.word current_dir
ptr_to_move_up:				.word move_up
ptr_to_move_down:			.word move_down
ptr_to_move_right:			.word move_right
ptr_to_move_left:			.word move_left
ptr_to_speed:				.word speed
ptr_to_board:				.word board
ptr_to_counter:				.word counter
ptr_to_row:					.word row
ptr_to_col:					.word col

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


timer_interrupt_init:

	; Enable Clock for Timer
	MOV r0, #0xE604
	MOVT r0, #0x400F
	LDRB r1, [r0]
	ORR r1, r1, #0x01
	STRB r1, [r0]

	; Enable processor to be able to receive interrupt signals from Timer0
	MOV r0, #0xE100
	MOVT r0, #0xE000
	LDR r1, [r0]
	MOV r2, #0x0000
	MOVT r2, #0x0008
	ORR r1, r1, r2
	STR r1, [r0]

	; Move base address of Timer0 to r0
	MOV r0, #0x0000
	MOVT r0, #0x4003

	; Disable Timer Before Setup
	LDRB r1, [r0, #GPTMCTL]
	AND r1, r1, #0xFE
	STRB r1, [r0, #GPTMCTL]

	; Put timer in 32-bit mode
	LDRB r1, [r0, #GPTMCFG]
	MOV r2, #0x0
	BFI r1, r2, #0, #3
	STRB r1, [r0, #GPTMCFG]

	; Put timer in periodic mode
	LDRB r1, [r0, #GPTMTAMR]
	MOV r2, #0x2
	BFI r1, r2, #0, #2
	STRB r1, [r0, #GPTMTAMR]

	; Setup timer's interval period
	LDR r1, [r0, #GPTMTAILR]
	MOV r1, #0x2400
	MOVT r1, #0x00F4
	STR r1, [r0, #GPTMTAILR]

	; Enable Timer After Setup
	LDRB r1, [r0, #GPTMCTL]
	ORR r1, r1, #0x01
	STRB r1, [r0, #GPTMCTL]

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


	BL simple_read_character		; Read character to tell which key was pressed
	CMP r0, #0x77					; Compare to hex value for 'w'
	BEQ UP
	CMP r0, #0x73					; Compare to hex value for 's'
	BEQ DOWN
	CMP r0, #0x61					; Compare to hex value for 'a'
	BEQ LEFT
	CMP r0, #0x64					; Compare to hex value for 'd'
	BEQ RIGHT
	B DONE

UP:
	MOV r0, #0
	STRB r0, [r7]					; Store the number for up in current_dir
	B DONE
DOWN:
	MOV r0, #1						; Store the number for down in current_dir
	STRB r0, [r7]
	B DONE
LEFT:								; Store the number for left in current_dir
	MOV r0, #2
	STRB r0, [r7]
	B DONE
RIGHT:								; Store the number for right in current_dir
	MOV r0, #3
	STRB r0, [r7]
	B DONE

DONE:

	POP {r4-r11}

	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r11,LR}

	LDR r1, ptr_to_speed		; Load address of speed num in r1
	LDRB r0, [r1]				; Load the number store at the address into r0
	ADD r0, r0, #1				; Increment the speed
	STRB r0, [r1]				; Store the new number at contents of address

	POP {r4-r11}

	BX lr       	; Return


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed
	; for Lab #5, but will be used in Lab #6.  It is referenced here
	; because the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.
	PUSH {r4-r11,LR}

	; Move base address of Timer0 to r0
	MOV r0, #0x0000
	MOVT r0, #0x4003

	; Clear SW1 Interrupt
	LDRB r1, [r0, #GPTMICR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPTMICR]

	; Clear the screen
	MOV r0, #0x0C
	BL output_character

	; Print board
	LDR r0, ptr_to_board
	BL output_string

	; Get direction of '*'
	LDR r4, ptr_to_current_dir

	; Branch to up direction
	CMP r4, #0
	BEQ UP

	; Branch to dowm direction
	CMP r4, #1
	BEQ DOWN

	; Branch to right direction
	CMP r4, #2
	BEQ RIGHT

	; Branch to left direction
	CMP r4, #3
	BEQ LEFT

U:	; Move '*' up on board
	LDR r0, ptr_to_move_up
	BL output_string

	; Change row postion value
	LDRB r2, [r5]
	SUB r2, r2, #1
	STRB r2, [r5]

	B DNE

D:	; Move '*' down on board
	LDR r0, ptr_to_move_down
	BL output_string

	; Change row postion value
	LDRB r2, [r5]
	ADD r2, r2, #1
	STRB r2, [r5]

	B DNE

L:	; Move '*' left on board
	LDR r0, ptr_to_move_left
	BL output_string

	; Change col postion value
	LDRB r2, [r6]
	SUB r2, r2, #1
	STRB r2, [r6]

	B DNE

R:	; Move '*' right on board
	LDR r0, ptr_to_move_right
	BL output_string

	; Change col postion value
	LDRB r2, [r6]
	ADD r2, r2, #1
	STRB r2, [r6]

	B DNE

DNE:

	; Update counter for amount of times '*'
	LDRB r2, [r7]
	ADD r2, r2, #1
	STRB r2, [r7]

	POP {r4-r11,LR}

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
	PUSH {lr, r2-r5}   ; Store register lr on stack

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


	POP {lr, r2-r5}
	mov pc, lr


	.end
