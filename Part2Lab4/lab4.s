	.data

prompt:	.string "What subroutine would you like to test?(1:read_from_push_btns, 2:illuminate_LEDs, 3:illuminate_RGB_LED, 4:read_tiva_pushbutton, 5:read_keypad)", 0
restart_prompt: .string "Do you want to try again? (type 'y' for yes & anything else for no): ", 0
bye:			.string "Bye:)", 0

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

ptr_to_prompt:			.word prompt
ptr_to_restart_prompt:	.word restart_prompt
ptr_to_bye:				.word bye


lab4:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here

	BL gpio_btn_and_LED_init
	BL keypad_init

	BL read_keypad
	BL read_keypad
	BL read_keypad
	BL read_keypad
	BL read_keypad
	BL read_keypad
	BL read_keypad
	BL read_keypad
	BL read_keypad
	BL read_keypad

	POP {lr}
	MOV pc, lr


.end
