	.data

	.global prompt
	.global results
	.global num_1_string
	.global num_2_string

prompt:	.string "Let's find the average of two numbers.", 0
result:	.string "Your results are reported here", 0
num_1_string: 	.string "Place holder string for your first number", 0
num_2_string:  	.string "Place holder string for your second number", 0
get_number_1:	.string "Enter your first number: ",  0
get_number_2:	.string "Enter your second number: ", 0
give_average: 	.string "Your average is: ", 0
restart_prompt: .string "Do you want to try again? (type 'y' for yes & anything else for no): ", 0
bye:			.string "Bye:)", 0


	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_prompt:			.word prompt
ptr_to_result:			.word result
ptr_to_num_1_string:	.word num_1_string
ptr_to_num_2_string:	.word num_2_string
ptr_to_get_num1:		.word get_number_1
ptr_to_get_num2:		.word get_number_2
ptr_to_give_average:	.word give_average
ptr_to_restart_prompt:	.word restart_prompt
ptr_to_bye:				.word bye


lab3:
	PUSH {lr}   ; Store lr to stack

	BL uart_init ; Initialize UART in assembly
RESTART:
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_result
	ldr r6, ptr_to_num_1_string
	ldr r7, ptr_to_num_2_string
	ldr r8, ptr_to_get_num1
	ldr r9, ptr_to_get_num2
	ldr r10, ptr_to_give_average
	ldr r11, ptr_to_restart_prompt

			; Your code is placed here.  This is your main routine for
			; Lab #3.  This should call your other routines such as
			; uart_init, read_string, output_string, int2string, &
			; string2int

	PUSH {r5} ; Preserve r5 while converting strings to int and vice versa

	MOV r0, r4
	BL output_string ; Print out prompt
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Restart line position

	MOV r0, r8
	BL output_string ; Ask for 1st number
	MOV r0, r6
	BL read_string ; Get 1st number
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Restart line position

	MOV r0, r9
	BL output_string ; Ask for 2nd number
	MOV r0, r7
	BL read_string ; Get 2nd number
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	MOV r0, r6
	BL string2int ; Convert 1st number to int
	MOV r1, r0 ; Save first int to r1

	MOV r0, r7
	PUSH {r1}
	BL string2int ; Convert 2nd number to int
	POP {r1}

	ADD r0, r0, r1 ; Add ints together
	MOV r1, #2
	SDIV r0, r0, r1 ; Divide sum by 2 to find average

	POP {r5} ; Recover address of result location after string2int changed r5
	MOV r1, r5
	PUSH {r5}
	BL int2string ; Convert average from int to string
	POP {r5}

	MOV r0, r10
	BL output_string ; Print average prompt
	MOV r0, r5
	BL output_string ; Print average number
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	MOV r0, r11
	BL output_string ; Print researt prompt

	MOV r0, r6
	BL read_string ; Get restart answer
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	LDRB r6, [r6]
	CMP r6, #0x79
	BEQ RESTART ; If user entered 'y' then restart

	ldr r0, ptr_to_bye
	BL output_string ; Say "bye"


	POP {lr}		; Restore lr from stack
	mov pc, lr


read_string:
	PUSH {lr}   ; Store register lr on stack

			; Your code for your read_string routine is placed here

		MOV r1, #0
LOOP:	PUSH {r0, r1}
		BL read_character
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

FINN:		MOV r3, #0
		POP {r0, r1}
		STRB r3, [r0, r1]

	POP {lr}
	mov pc, lr


output_string:
	PUSH {lr}   ; Store register lr on stack

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
	mov pc, lr

read_character:
	PUSH {lr}   ; Store register lr on stack

		; Your code to receive a character obtained from the keyboard
		; in PuTTy is placed here.  The character is received in r0.
GETC:	MOV r1, #0xC000
		MOVT r1, #0x4000
		LDRB r1, [r1, #U0FR]
		MOV r2, #0x10
		AND r1, r1, r2
		CMP r1, #0x10
		BEQ GETC

READ:	MOV r1, #0xC000
		MOVT r1, #0x4000
		LDRB r1, [r1]
		MOV r0, r1

	POP {lr}
	mov pc, lr



output_character:
	PUSH {lr}   ; Store register lr on stack

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
	mov pc, lr


uart_init:
	PUSH {lr}  ; Store register lr on stack

			; Your code for your uart_init routine is placed here
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
	mov pc, lr

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
