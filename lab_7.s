	.data

	.global board
	.global brick_menu
	.global paddle
	.global paddle_pos
	.global ptr_to_paddle_pos
	.global paddle_line
	.global brick_row
	.global ptr_to_brick_row
	.global brick_count
	.global ptr_to_brick_count
	.global level
	.global ptr_to_level
	.global brick_row_num
	.global brick_row
	.global ptr_to_brick_row
	.global score_prompt
	.global ptr_to_score_prompt
	.global ptr_to_brick_row_num
	.global game_state
	.global ptr_to_game_state
	.global cur_left
	.global ptr_to_cur_left
	.global game_over_prompt
	.global ptr_to_game_over_prompt
	.global ptr_to_paddle_line
	.global paddle_left
	.global ptr_to_paddle_left
	.global speed
	.global cur_right
	.global ptr_to_cur_right
	.global ball_row
	.global ball_col
	.global current_dir
	.global prompt
	.global score
	.global ptr_to_score
	.global score_str
	.global ptr_to_score_str
	.global ball_start
	.global ptr_to_ball_start
	.global reset_foreground
	.global ptr_to_reset_foreground
	.global current_dir
	.global end_pos
	.global ptr_to_speed
	.global save_cur

board:					.string	"+---------------------+", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"|                     |", 0xA, 0xD
						.string	"+---------------------+", 0xA, 0xD, 0

paddle:					.string 27, "[36m-----", 0
prompt:					.string 	"Welcome to breakout, use the 'a' and 'd' keys to move the paddle. Don't let the ball miss the paddle and clear all the bricks to move on to the next level. You have 4 lives, press 's' key to begin.", 0
brick_menu:						.string		"Use Alice EduBase board to set the rows of bricks. Push SW2: for 1 row, SW3: for 2 rows, SW4: for 3 rows, SW5: for 4 rows", 0
score_prompt:					.string 	"Score: ", 0
red_brick:						.string 27, "[31mXXX", 0
green_brick:					.string 27, "[32mXXX", 0
purple_brick:					.string 27, "[35mXXX", 0
blue_brick:						.string 27, "[34mXXX", 0
yellow_brick:					.string 27, "[33mXXX", 0
reset_back:				.string		27, "[40m", 0
ball_start:				.string 	27, "[10;12H*", 0


	.text
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global timer_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler		; This is needed for Lab #6
	.global simple_read_character
	.global read_character
	.global output_character	; This is from your Lab #4 Library
	.global read_string		; This is from your Lab #4 Library
	.global output_string		; This is from your Lab #4 Library
	.global uart_init		; This is from your Lab #4 Library
	.global gpio_btn_and_LED_init
	.global int2string		; This is from our Lab #3 Library
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global print_bricks
	.global lab7

UARTIM: 	.equ 0x038


ptr_to_board:					.word board
ptr_to_brick_menu:				.word brick_menu
ptr_to_paddle:					.word paddle
ptr_to_prompt:					.word prompt
ptr_to_score_prompt:			.word score_prompt
ptr_to_game_over_prompt:		.word game_over_prompt
ptr_to_score_str:				.word score_str
ptr_to_speed:					.word speed
ptr_to_reset_foreground:		.word reset_foreground
ptr_to_score:					.word score
ptr_to_paddle_line:				.word paddle_line
ptr_to_paddle_left:				.word paddle_left
ptr_to_paddle_pos:				.word paddle_pos
ptr_to_ball_row:				.word ball_row
ptr_to_ball_col:				.word ball_col
ptr_to_cur_right:				.word cur_right
ptr_to_save_cur:				.word save_cur
ptr_to_current_dir:				.word current_dir
ptr_to_end_pos:					.word end_pos
ptr_to_reset_back:				.word reset_back
ptr_to_ball_start:				.word ball_start
ptr_to_game_state:				.word game_state
ptr_to_cur_left:				.word cur_left
ptr_to_brick_count:				.word brick_count
ptr_to_brick_row:				.word brick_row
ptr_to_brick_row_num:			.word brick_row_num


lab7:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack

	ldr r4, ptr_to_board
	ldr r5, ptr_to_paddle


    bl uart_init

start:
    MOV r0, #0xC		;Clear the screen
	BL output_character

    LDR r0, ptr_to_prompt			;Move the initial start prompt and output it to the user
	BL output_string

	BL read_character	;Check to see if the correct character was pressed
	CMP r0, #0x73
	BNE start

    bl gpio_btn_and_LED_init ;Initialize the gpio btn and LEDS
	bl uart_interrupt_init	;Initialize UART0 for interrupts
	bl gpio_interrupt_init	;Initialize GPIO for interrupts
	bl timer_interrupt_init	;Initialize timer for interrupts


	LDR r0, ptr_to_brick_menu				;Move the brick menu prompt and output it to the user
	BL output_string

	MOV r0, #0x0A
	BL output_character 	; New line
	MOV r0, #0x0A
	BL output_character 	; New line
	MOV r0, #0x0D
	BL output_character 	; Reset line position

	; Waits for buttons on Alice board to be hit
	MOV r0, #4
	LDR r1, ptr_to_brick_row_num
	STRB r0, [r1]

	LDR r0, ptr_to_brick_row
	MOV r1, #7
	STRB r1, [r0]

	MOV r1, #28
	LDR r0, ptr_to_brick_count
	STRB r1, [r0]


BUT_LOOP:
	BL read_from_push_btns
	CMP r0, #0
	BEQ BUT_LOOP

	MOV r2, #7
	MUL r1, r0, r2
	LDR r2, ptr_to_brick_count
	STRB r1, [r2]


cont:
	MOV r0, #0xC		;Clear the screen
	BL output_character

	LDR r0, ptr_to_score_prompt ;Load the base address of the score prompt into r0
	BL output_string			;Output Score prompt to terminal

	LDR r0, ptr_to_score		;Load the address of the score into r0
	LDRB r0, [r0]				;Get the actual score
	LDR r1, ptr_to_score_str	;Load the placeholder string for conversion
	BL int2string				;Convert the score into a string

	LDR r0, ptr_to_score_str	;Output the converted score to the board
	BL output_string

	MOV r0, #0x0A
	BL output_character 	; New line
	MOV r0, #0x0D
	BL output_character 	; Reset line position

	MOV r0, r4		;Output the board
	BL output_string

	LDR r0, ptr_to_brick_row_num
	LDRB r0, [r0]
	BL print_bricks

	LDR r0, ptr_to_reset_foreground
	BL output_string

	; Reset background
	LDR r0, ptr_to_reset_back
	BL output_string

	; Print ball
	LDR r0, ptr_to_ball_start
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string


	LDR r0, ptr_to_paddle_line	;Move the cursor to the beginning of the paddle line
	BL output_string

	LDR r0, ptr_to_paddle_left	;Load the column of the leftmost part of the paddle
	LDRB r1, [r0]

move_to_paddle:					;Move the cursor to the paddle
	LDR r0, ptr_to_cur_right
	BL output_string
	SUB r1, r1, #1
	CMP r1, #0
	BNE move_to_paddle

print_paddle:					;Output the new paddle
	MOV r0, r5
	BL output_string

	LDR r0, ptr_to_reset_foreground
	BL output_string

	MOV r0, #0x0F				;Illuminate all LEDs to represent the amount of lives
	BL illuminate_LEDs

	MOV r0, #1
	LDR r1, ptr_to_game_state
	STRB r0, [r1]

game_over:
    LDR r0, ptr_to_game_state
    LDRB r1, [r0]
    CMP r1, #4
    BEQ cont
    CMP r1, #3
    BNE game_over


    LDR r0, ptr_to_end_pos
    BL output_string

    LDR r0, ptr_to_score_prompt ;Load the base address of the score prompt into r0
    BL output_string            ;Output Score prompt to terminal

    LDR r0, ptr_to_score        ;Load the address of the score into r0
    LDRB r0, [r0]                ;Get the actual score
    LDR r1, ptr_to_score_str    ;Load the placeholder string for conversion
    BL int2string                ;Convert the score into a string

    LDR r0, ptr_to_score_str    ;Output the converted score to the board
    BL output_string


    MOV r0, #0x0A
    BL output_character     ; New line
    MOV r0, #0x0A
    BL output_character     ; New line
    MOV r0, #0x0D
    BL output_character     ; Reset line position

    MOV r0, #0xC000
    MOVT r0, #0x4000
    LDRB r1, [r0, #UARTIM]
    AND r1, r1, #0x00
    STRB r1, [r0, #UARTIM]

    LDR r0, ptr_to_game_over_prompt
    BL output_string

    BL read_character
    CMP r0, #0x73
    BNE finn
    B start

finn:

	POP {lr}		; Restore lr from the stack
	MOV pc, lr
