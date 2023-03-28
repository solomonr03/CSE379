	.data

prompt:							.string "What subroutine would you like to test?('1':read_from_push_btns, '2':illuminate_LEDs, '3':illuminate_RGB_LED, '4':read_tiva_push_button, '5':read_keypad)", 0
read_push_btns_prompt: 			.string "Press and hold one of the buttons on Alice EduBase Board", 0
illuminate_LEDs_prompt: 		.string "Select which LED(s) you want to illuminate (type '1', '2', '3', '4', or '5' for all)", 0
illuminate_RGB_LED_prompt: 		.string "Please select which color you would like, '1':red, '2':blue, '3':green, '4':purple, '5':yellow, or '6':white", 0
read_tiva_push_button_prompt: 	.string "Press and hold SW1 on the Tiva Board", 0
read_from_keypad_prompt: 		.string "Press and hold button on keypad", 0
button_read_prompt: 			.string "You pressed button:",0
restart_prompt: 				.string "Do you want to try again? (type 'y' for yes & anything else for no): ", 0
bye:							.string "Bye:)", 0

	.text
	.global uart_init
	.global keypad_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global read_keypad
	.global lab4

ptr_to_prompt:						.word prompt
ptr_to_read_push_btns_prompt: 		.word read_push_btns_prompt
ptr_to_illuminate_LEDs_prompt: 		.word illuminate_LEDs_prompt
ptr_to_illuminate_RGB_LED_prompt: 	.word illuminate_RGB_LED_prompt
ptr_to_read_tiva_push_button_prompt: 		.word read_tiva_push_button_prompt
ptr_to_read_from_keypad_prompt: 			.word read_from_keypad_prompt
ptr_to_button_read_prompt: 			.word button_read_prompt
ptr_to_restart_prompt:				.word restart_prompt
ptr_to_bye:							.word bye


lab4:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here

	 BL uart_init
	 BL gpio_btn_and_LED_init
	 BL keypad_init

RESTART:
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_read_push_btns_prompt
	ldr r6, ptr_to_illuminate_LEDs_prompt
	ldr r7, ptr_to_illuminate_RGB_LED_prompt
	ldr r8, ptr_to_read_tiva_push_button_prompt
	ldr r9, ptr_to_read_from_keypad_prompt
	ldr r10, ptr_to_button_read_prompt
	ldr r11, ptr_to_restart_prompt
	ldr r12, ptr_to_bye


	PUSH {r0, r2}
	MOV r0, r4
	BL output_string 	; Print out prompt
	PUSH {r0, r2}

	PUSH {r0, r1, r2, r3}
	MOV r0, r1			; Get subroutine ans
	BL read_string
	POP {r0, r1, r2, r3}

	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	LDRB r1, [r1]
	CMP r1, #0x31
	BEQ PUSHBTNS		; Break to push buttoons if user pressed 1
	CMP r1, #0x32
	BEQ LEDS			; Break to illuminate LEDS if user pressed 2
	CMP r1, #0x33
	BEQ RGBLED			; Break to RGB if user pressed 3
	CMP r1, #0x34
	BEQ PUSHBTN			; Break to push buttoon if user pressed 4
	CMP r1, #0x35
	BEQ KEYPAD			; Break to keypad if user pressed 5

PUSHBTNS:
	MOV r0, r5
	BL output_string	; Prompt user to push and hold button
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	MOV r0, r10
	BL output_string

	BL read_from_push_btns
	CMP r0, #0x00
	BEQ BZERO
	CMP r0, #0x01
	BEQ BONE
	CMP r0, #0x02
	BEQ BTWO
	CMP r0, #0x03
	BEQ BTHREE
	CMP r0, #0x04
	BEQ BFOUR

BZERO:
	MOV r0, #0x30
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
BONE:
	MOV r0, #0x31
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
BTWO:
	MOV r0, #0x32
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
BTHREE:
	MOV r0, #0x33
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN

BFOUR:
	MOV r0, #0x34
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN


LEDS:
	MOV r0, r6
	BL output_string	; Prompt user to enter which LED they want to illuminate

	MOV r0, r1
	BL read_string		; Get color ans
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	LDRB r1, [r1]
	CMP r1, #0x31
	BEQ ONE
	CMP r1, #0x32
	BEQ TWO
	CMP r1, #0x33
	BEQ THREE
	CMP r1, #0x34
	BEQ FOUR
	CMP r1, #0x35
	BEQ ALL
	B LEDS

ONE:
	MOV r0, #0x01
	BL illuminate_LEDs
	B AGAIN
TWO:
	MOV r0, #0x02
	BL illuminate_LEDs
	B AGAIN
THREE:
	MOV r0, #0x04
	BL illuminate_LEDs
	B AGAIN
FOUR:
	MOV r0, #0x08
	BL illuminate_LEDs
	B AGAIN
ALL:
	MOV r0, #0x0F
	BL illuminate_LEDs
	B AGAIN

RGBLED:
	MOV r0, r7
	BL output_string	; Prompt user to choose which color they want

	MOV r0, r1
	BL read_string		; Get color ans
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	LDRB r1, [r1]
	CMP r1, #0x31
	BEQ RED
	CMP r1, #0x32
	BEQ GREEN
	CMP r1, #0x33
	BEQ BLUE
	CMP r1, #0x34
	BEQ PURP
	CMP r1, #0x35
	BEQ	YELL
	CMP r1, #0x36
	BEQ	WHITE
	B RGBLED

RED:
	MOV r0, #0x1
	BL illuminate_RGB_LED
	B AGAIN
GREEN:
	MOV r0, #0x4
	BL illuminate_RGB_LED
	B AGAIN
BLUE:
	MOV r0, #0x2
	BL illuminate_RGB_LED
	B AGAIN
PURP:
	MOV r0, #0x3
	BL illuminate_RGB_LED
	B AGAIN
YELL:
	MOV r0, #0x5
	BL illuminate_RGB_LED
	B AGAIN
WHITE:
	MOV r0, #0x7
	BL illuminate_RGB_LED
	B AGAIN


PUSHBTN:
	MOV r0, r8
	BL output_string	; Prompt user to hold button
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
NOTP:
	BL read_tiva_push_button

	CMP r0, #0x01
	BEQ PUSHED
	B NOTP

PUSHED:
	MOV r0, r10
	BL output_string	; Let user know it worked
	MOV r0, #0x31
	BL output_character

	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	B AGAIN

KEYPAD:

	MOV r0, r9
	BL output_string	; Prompt user to hold button
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position

	BL read_keypad

	MOV r1, r0			; Store value in r1

	MOV r0, r10			; Tell user the buttoon they pressed
	BL output_string
	CMP r1, #0x01
	BEQ PONE
	CMP r1, #0x02
	BEQ PTWO
	CMP r1, #0x03
	BEQ PTHREE
	CMP r1, #0x04
	BEQ PFOUR
	CMP r1, #0x05
	BEQ PFIVE
	CMP r1, #0x06
	BEQ PSIX
	CMP r1, #0x07
	BEQ PSEV
	CMP r1, #0x08
	BEQ PEIGHT
	CMP r1, #0x09
	BEQ PNINE
	CMP r1, #0x00
	BEQ PZERO

PONE:
	MOV r0, #0x31
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PTWO:
	MOV r0, #0x32
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PTHREE:
	MOV r0, #0x33
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PFOUR:
	MOV r0, #0x34
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PFIVE:
	MOV r0, #0x35
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PSIX:
	MOV r0, #0x36
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PSEV:
	MOV r0, #0x37
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PEIGHT:
	MOV r0, #0x39
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PNINE:
	MOV r0, #0x31
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN
PZERO:
	MOV r0, #0x30
	BL output_character
	MOV r0, #0xA
	BL output_character ; New line
	MOV r0, #0xD
	BL output_character ; Reset line position
	B AGAIN


AGAIN:
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

	POP {lr}
	MOV pc, lr


.end
