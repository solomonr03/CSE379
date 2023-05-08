	.data

	.global board
	.global paddle
	.global paddle_pos
	.global level
	.global paddle_line
	.global paddle_left
	.global	game_state
	.global brick_count
	.global reset_foreground
	.global brick_row_num
	.global cur_left
	.global prompt
	.global score_prompt
	.global ball_row
	.global ball_col
	.global current_dir
	.global speed
	.global score
	.global game_over_prompt
	.global brick_row
	.global score_str
	.global hit_prompt
	.global cur_right
	.global start_pos
	.global save_cur
	.global end_pos
	.global ball_start
	.global brick_stat
	.global current_dir
	.global rest_cur
	.global save_cur
	.global cur_right
	.global level
	.global reset_foreground
	.global set_blue
	.global set_green
	.global set_purple
	.global set_red
	.global set_yellow
	.global clear_ball
	.global ball_color
	.global cur_up
	.global cur_down
	.global clear_brick



brick_menu:					.string		"Use Alice EduBase board to set the rows of bricks. Push SW2: for 1 row, SW3: for 2 rows, SW4: for 3 rows, SW5: for 4 rows", 0
game_over_prompt:			.string 	"Game Over. Press 's' to start a new game or 'q' to quit.", 0
score_str:					.string 	"Placeholder for string version of score", 0
clear_pause:				.string		27, "[10;12H     ", 0
pause_prompt:				.string		27, "[10;12HPAUSE", 0
clear_ball:					.string		" ", 0
lives:						.byte		0x04
level:						.byte		0x01
speed:						.byte 		0x01
score:						.byte		0x00
count_time:					.byte 		0x00
ball_row:					.byte		0x08
ball_col:					.byte 		0x0B
ball_color:					.byte		0x05	;0=red, 1=green, 2=purple, 3=blue, 4=yellow, 5=white
game_state:					.byte		0x00	;0=start, 1=play, 2=pause, 3 =game over, 4=new level
paddle_pos:					.half		0x0199
paddle_left:				.byte		0x09
paddle_right:				.byte		0x0D
brick_count:				.byte		0x00
brick_color:				.byte		0x00	;0=red, 1=green, 2=purple, 3=blue, 4=yellow
brick_row:					.byte		0x00
brick_row_num:				.byte		0x00
current_dir:				.byte 		0x01   ;0=u, 1=d, 2=ne-45, 3=ne-60, 4=se-45, 5=se-60, 6=sw-45, 7=sw-60, 8=nw-45, 9=nw-60
move_up:					.string		27, "[1A*", 0
move_down:					.string 	27, "[1B*", 0
move_right:					.string 	27, "[1C*", 0
move_left:					.string 	27, "[1D*", 0
cur_up:						.string 	27, "[1A", 0
cur_down:					.string 	27, "[1B", 0
cur_right:					.string 	27, "[1C", 0
cur_left:					.string 	27, "[1D", 0
paddle_line:				.string 	27, "[17;1H",0
save_cur:					.string		27, "[s",0
rest_cur:					.string		27, "[u",0
end_pos:					.string		27, "[25;1H", 0
brick_start:				.string		27, "[5;2H", 0
red_brick:					.string 	27, "[41m   ", 0
green_brick:				.string 	27, "[42m   ", 0
purple_brick:				.string 	27, "[48;5;55m   ", 0
blue_brick:					.string 	27, "[44m   ", 0
yellow_brick:				.string 	27, "[43m   ", 0
clear_brick:				.string		27, "[40m   ", 0
reset_foreground:			.string		27, "[37m", 0
set_red:					.string		27, "[31m",0
set_green:					.string		27, "[32m",0
set_purple:					.string		27, "[38;5;55m",0
set_blue:					.string		27, "[34m",0
set_yellow:					.string		27, "[33m",0
brick_stat:					.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX"
							.string		"XXXXXXX", 0
red_stat:					.byte 		0x52
green_stat:					.byte 		0x47
purple_stat:				.byte 		0x50
blue_stat:					.byte 		0x42
yellow_stat:				.byte 		0x59


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
GPTMTAR:	.equ 0x048
SYSCTL:			.word	0x400FE000	; Base address for System Control
GPIO_PORT_A:	.word	0x40004000	; Base address for GPIO Port A
GPIO_PORT_B:	.word	0x40005000	; Base address for GPIO Port B
GPIO_PORT_D:	.word	0x40007000	; Base address for GPIO Port D
GPIO_PORT_F:	.word	0x40025000	; Base address for GPIO Port F
RCGCGPIO:		.equ	0x608		; Offset for GPIO Run Mode Clock Gating Control Register
GPIODIR:		.equ	0x400		; Offset for GPIO Direction Register
GPIODEN:		.equ	0x51C		; Offset for GPIO Digital Enable Register
GPIODATA:		.equ	0x3FC		; Offset for GPIO Data Register
GPIOPUR:		.equ	0x510		; Offset for GPIO Pull-Up Register
U0FR: 			.equ 	0x18

	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global timer_interrupt_init
	.global gpio_btn_and_LED_init
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
	.global check_brick_hit
	.global set_ball_color
	.global NO_HIT
	.global modulo

ptr_to_prompt:				.word prompt
ptr_to_game_state:			.word game_state
ptr_to_level:				.word level
ptr_to_clear_pause:			.word clear_pause
ptr_to_pause_prompt:		.word pause_prompt
ptr_to_score_prompt:		.word score_prompt
ptr_to_lives:				.word lives
ptr_to_clear_ball:			.word clear_ball
ptr_to_current_dir:			.word current_dir
ptr_to_paddle_pos:			.word paddle_pos
ptr_to_paddle_line: 		.word paddle_line
ptr_to_paddle_left:			.word paddle_left
ptr_to_paddle_right:		.word paddle_right
ptr_to_paddle:				.word paddle
ptr_to_move_up:				.word move_up
ptr_to_move_down:			.word move_down
ptr_to_move_right:			.word move_right
ptr_to_move_left:			.word move_left
ptr_to_cur_up:				.word cur_up
ptr_to_cur_down:			.word cur_down
ptr_to_cur_right:			.word cur_right
ptr_to_cur_left:			.word cur_left
ptr_to_speed:				.word speed
ptr_to_board:				.word board
ptr_to_score:				.word score
ptr_to_ball_row:			.word ball_row
ptr_to_ball_col:			.word ball_col
ptr_to_ball_color:			.word ball_color
ptr_to_save_cur:			.word save_cur
ptr_to_rest_cur:			.word rest_cur
ptr_to_brick_count:			.word brick_count
ptr_to_brick_color:			.word brick_color
ptr_to_brick_row:			.word brick_row
ptr_to_brick_row_num:		.word brick_row_num
ptr_to_brick_start:			.word brick_start
ptr_to_red_brick:			.word red_brick
ptr_to_green_brick:			.word green_brick
ptr_to_purple_brick:		.word purple_brick
ptr_to_blue_brick:			.word blue_brick
ptr_to_yellow_brick:		.word yellow_brick
ptr_to_clear_brick:			.word clear_brick
ptr_to_brick_stat:			.word brick_stat
ptr_to_red_stat:			.word red_stat
ptr_to_green_stat:			.word green_stat
ptr_to_purple_stat:			.word purple_stat
ptr_to_blue_stat:			.word blue_stat
ptr_to_yellow_stat:			.word yellow_stat
ptr_to_reset_foreground:	.word reset_foreground
ptr_to_ball_start:			.word ball_start
ptr_to_set_red:				.word set_red
ptr_to_set_green:			.word set_green
ptr_to_set_purple:			.word set_purple
ptr_to_set_blue:			.word set_blue
ptr_to_set_yellow:			.word set_yellow

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

gpio_btn_and_LED_init:
	PUSH {lr} ; Store register lr on stack

	 ; Your code is placed here
	LDR	r0, SYSCTL
	LDRB r1, [r0, #RCGCGPIO] ;Enable clock for Ports B, D F
	ORR r1, #0x2A
	STRB r1, [r0, #RCGCGPIO]

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #GPIODIR] 	;Enable SW1 for input
	AND r1, r1, #0xEF
	STRB r1, [r0, #GPIODIR]

	MOV r0, #0x7000
	MOVT r0, #0x4000		;Enable Alice push buttons for input
	LDRB r1, [r0, #GPIODIR]
	AND r1, r1, #0xF0
	STRB r1, [r0, #GPIODIR]

	MOV r0, #0x5000
	MOVT r0, #0x4002		;Enable RGB LED for output
	LDRB r1, [r0, #GPIODIR]
	ORR r1, r1, #0x0E
	STRB r1, [r0, #GPIODIR]

	MOV r0, #0x5000
	MOVT r0, #0x4000		;Enable Alice LEDs for output
	LDRB r1, [r0, #GPIODIR]
	ORR r1, r1, #0x0F
	STRB r1, [r0, #GPIODIR]

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #GPIODEN]		;Enable SW1 as digital
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPIODEN]

	MOV r0, #0x7000
	MOVT r0, #0x4000
	LDRB r1, [r0, #GPIODEN]		;Enable Alice push buttons as digital
	ORR r1, r1, #0x0F
	STRB r1, [r0, #GPIODEN]

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #GPIODEN]		;Enable RGB LED as digital
	ORR r1, r1, #0x0E
	STRB r1, [r0, #GPIODEN]

	MOV r0, #0x5000
	MOVT r0, #0x4000
	LDRB r1, [r0, #GPIODEN]		;Enable ALice LEDs as digital
	ORR r1, r1, #0x0F
	STRB r1, [r0, #GPIODEN]

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #GPIOPUR]			;Enable Pull-Up Resistor for SW1
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPIOPUR]
	POP {lr}
	MOV pc, lr

uart_interrupt_init:

	; Your code to initialize the UART0 interrupt goes here
	PUSH{lr}

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

	POP{lr}
	MOV pc, lr


gpio_interrupt_init:

	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.

	PUSH{lr}

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

	POP{lr}

	MOV pc, lr


timer_interrupt_init:

	PUSH{lr}

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
	LDRB r1, [r0, #GPTMIMR]
	ORR r1, r1, #0x01
	STRB r1, [r0, #GPTMIMR]

	; Enable Timer After Setup
	LDRB r1, [r0, #GPTMCTL]
	ORR r1, r1, #0x01
	STRB r1, [r0, #GPTMCTL]

	POP{lr}

	MOV pc, lr


UART0_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r11,LR}

	MOV r0, #0xC000				;Clear thhe UART
	MOVT r0, #0x4000
	LDRB r1, [r0, #UARTICR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #UARTICR]

	LDR r1, ptr_to_game_state
	LDRB r1, [r1]
	CMP r1, #0
	BEQ done
	CMP r1, #2
	BEQ done
	CMP r1, #3
	BEQ done
	CMP r1, #4
	BEQ done

	bl simple_read_character

	CMP r0, #0x61				;Check if left or right key was pressed
	BEQ left
	CMP r0, #0x64
	BEQ right
	B done

left:
	LDR r0, ptr_to_reset_foreground
	BL output_string

	LDR r0, ptr_to_paddle_left	;Check if paddle is at left wall
	LDRB r0, [r0]
	CMP r0, #1
	BEQ done

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

	MOV r1, #5

clear_paddle:					;Clear the current paddle
	MOV r0, #0x20
	BL output_character
	SUB r1, r1, #1
	CMP r1, #0
	BNE clear_paddle

	LDR r0, ptr_to_paddle_left	;Update the left most column
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	MOV r1, #6

move_new_paddle:				;Move to the position of the new paddle
	LDR r0, ptr_to_cur_left
	BL output_string
	SUB r1, r1, #1
	CMP r1, #0
	BNE move_new_paddle

	MOV r1, #5

print_paddle:					;Output the new paddle
	LDR r0, ptr_to_paddle
	BL output_string

	LDR r0, ptr_to_reset_foreground
	BL output_string

	LDR r0, ptr_to_paddle_right	;Update the right most column
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	ADD r1, r1, #1

print_line:						;Print the rest of the line
	MOV r0, #0x20
	BL output_character
	ADD r1, r1, #1
	CMP r1, #22
	BNE print_line

	LDR r0, ptr_to_reset_foreground
	BL output_string

	MOV r0, #0x7C				;Output the wall, the new line, and the return character
	BL output_character
	MOV r0, #0x0A
	BL output_character
	MOV r0, #0x0D
	BL output_character

	B done

right:
	LDR r0, ptr_to_reset_foreground
	BL output_string

	LDR r0, ptr_to_paddle_right	;Check if paddle is at right wall
	LDRB r0, [r0]
	CMP r0, #21
	BEQ done

	LDR r0, ptr_to_paddle_line	;Move the cursor to the paddle line
	BL output_string

	LDR r0, ptr_to_paddle_left	;Load the left most part of the paddle
	LDRB r1, [r0]

move_to_paddle_r:				;Move the cursor to where the paddle is
	LDR r0, ptr_to_cur_right
	BL output_string
	SUB r1, r1, #1
	CMP r1, #0
	BNE move_to_paddle_r

	MOV r1, #5

clear_paddle_r:					;Clear the current paddle
	MOV r0, #0x20
	BL output_character
	SUB r1, r1, #1
	CMP r1, #0
	BNE clear_paddle_r

	LDR r0, ptr_to_paddle_left	;Update the left most column
	LDRB r1, [r0]
	ADD r1, r1, #1
	STRB r1, [r0]

	MOV r1, #4

move_new_paddle_r:				;Move the cursor to the new paddle spot
	LDR r0, ptr_to_cur_left
	BL output_string
	SUB r1, r1, #1
	CMP r1, #0
	BNE move_new_paddle_r



print_paddle_r:					;Print the new paddle
	LDR r0, ptr_to_paddle
	BL output_string

	LDR r0, ptr_to_reset_foreground
	BL output_string

	LDR r0, ptr_to_paddle_right	;Update the right most column
	LDRB r1, [r0]
	ADD r1, r1, #1
	STRB r1, [r0]

	ADD r1, r1, #1

	CMP r1, #22
	BEQ at_wall

print_line_r:					;Print the rest of the line
	MOV r0, #0x20
	BL output_character
	ADD r1, r1, #1
	CMP r1, #22
	BNE print_line_r

at_wall:
	LDR r0, ptr_to_reset_foreground
	BL output_string

	MOV r0, #0x7C				;Print the wall, the new line, and the return
	BL output_character
	MOV r0, #0x0A
	BL output_character
	MOV r0, #0x0D
	BL output_character

done:
	POP {r4-r11,LR}

	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r11,LR}

	; Move base address of GPIO Port F to r0
	MOV r0, #0x5000
	MOVT r0, #0x4002

	; Clear SW1 Interrupt
	LDRB r1, [r0, #GPIOICR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPIOICR]

	LDR r0, ptr_to_game_state
	LDRB r1, [r0]
	CMP r1, #1
	BEQ pause
	CMP r1, #2
	BEQ play
	B end

pause:
	MOV r1, #2		;Move two into the r1 register
	STRB r1, [r0]	;Store the byte at the address of the game_state to set it to paused

	MOV r0, #4		;Move two into r0
	BL illuminate_RGB_LED	;Call illuminate RGB LED to set the color to blue

	LDR r0, ptr_to_pause_prompt		;Load the base address of the PAUSE prompt into r0
	BL output_string				;Call output_string to Output that the game is paused

	B end

play:
	MOV r1, #1		;Move one into the r1 register
	STRB r1, [r0]	;Store the byte at the address of the game_state to set it to play

	LDR r0, ptr_to_ball_color	;Move the value of the ball color before this into r0
	LDRB r0, [r0]

	CMP r0, #0
	BEQ last_red

	CMP r0, #1
	BEQ last_green

	CMP r0, #2
	BEQ last_purple

	CMP r0, #3
	BEQ last_blue

	CMP r0, #4
	BEQ last_yellow

	CMP r0, #5
	BEQ last_white


last_red:
	MOV r0, #0x02
	BL illuminate_RGB_LED

	LDR r0, ptr_to_clear_pause		;Load the base address of the clear pause prompt
	BL output_string				;Call output_string to output that the game is no longer paused

	B end

last_green:
	MOV r0, #0x08
	BL illuminate_RGB_LED

	LDR r0, ptr_to_clear_pause		;Load the base address of the clear pause prompt
	BL output_string				;Call output_string to output that the game is no longer paused

	B end

last_purple:
	MOV r0, #0x06
	BL illuminate_RGB_LED

	LDR r0, ptr_to_clear_pause		;Load the base address of the clear pause prompt
	BL output_string				;Call output_string to output that the game is no longer paused

	B end

last_blue:
	MOV r0, #0x04
	BL illuminate_RGB_LED

	LDR r0, ptr_to_clear_pause		;Load the base address of the clear pause prompt
	BL output_string				;Call output_string to output that the game is no longer paused

	B end


last_yellow:
	MOV r0, #0x0A
	BL illuminate_RGB_LED

	LDR r0, ptr_to_clear_pause		;Load the base address of the clear pause prompt
	BL output_string				;Call output_string to output that the game is no longer paused

	B end

last_white:
	MOV r0, #0x00
	BL illuminate_RGB_LED

	LDR r0, ptr_to_clear_pause		;Load the base address of the clear pause prompt
	BL output_string				;Call output_string to output that the game is no longer paused

	B end

end:

	POP {r4-r11, LR}

	BX lr       	; Return


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed
	; for Lab #5, but will be used in Lab #6.  It is referenced here
	; because the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.ww
	PUSH {r4-r11,LR}

	; Move base address of Timer0 to r0
	MOV r0, #0x0000
	MOVT r0, #0x4003

	; Clear Timer Interrupt
	LDRB r1, [r0, #GPTMICR]
	ORR r1, r1, #0x01
	STRB r1, [r0, #GPTMICR]

	LDR r1, ptr_to_game_state
	LDRB r1, [r1]
	CMP r1, #0
	BEQ skip
	CMP r1, #2
	BEQ skip
	CMP r1, #3
	BEQ skip
	CMP r1, #4
	BEQ skip

	; Get direction of '*'
	LDR r4, ptr_to_current_dir
	LDRB r4, [r4]

	; Check if left wall hit
	LDR r5, ptr_to_ball_col
	LDRB r5, [r5]
	CMP r5, #1
	BEQ L_HIT

	; Check if right wall hit
	CMP r5, #21
	BEQ R_HIT

	; Check if top wall hit
	LDR r6, ptr_to_ball_row
	LDRB r6, [r6]
	CMP r6, #1
	BEQ T_HIT

	; Check if about to hit bottom
	CMP r6, #15
	BEQ B_HIT

	; Check if brick was hit
	LDR r0, ptr_to_current_dir
	LDRB r0, [r0]

	LDR r1, ptr_to_ball_row
	LDRB r1, [r1]

	LDR r2, ptr_to_ball_col
	LDRB r2, [r2]

	CMP r1, #8
	BLE check_brick_hit

	B NO_HIT

L_HIT: ; Change direction from NW to NE or SW to SE
	LDR r5, ptr_to_current_dir

	CMP r6, #1
	BEQ L_HIT_45_D

	CMP r6, #15
	BEQ B_HIT

	CMP r4, #8
	BEQ L_HIT_45_U

	CMP r4, #9
	BEQ L_HIT_60_U

	CMP r4, #6
	BEQ L_HIT_45_D

	CMP r4, #7
	BEQ L_HIT_60_D

L_HIT_45_U:
	MOV r4, #2
	STRB r4, [r5]
	B NO_HIT

L_HIT_60_U:
	MOV r4, #3
	STRB r4, [r5]
	B NO_HIT

L_HIT_45_D:
	MOV r4, #4
	STRB r4, [r5]
	B NO_HIT

L_HIT_60_D:
	MOV r4, #5
	STRB r4, [r5]
	B NO_HIT

R_HIT: ; Change direction from NE to NW or SE to SW
	LDR r5, ptr_to_current_dir

	CMP r6, #1
	BEQ R_HIT_45_D

	CMP r6, #15
	BEQ B_HIT

	CMP r4, #2
	BEQ R_HIT_45_U

	CMP r4, #3
	BEQ R_HIT_60_U

	CMP r4, #4
	BEQ R_HIT_45_D

	CMP r4, #5
	BEQ R_HIT_60_D

R_HIT_45_U:
	MOV r4, #8
	STRB r4, [r5]
	B NO_HIT

R_HIT_60_U:
	MOV r4, #9
	STRB r4, [r5]
	B NO_HIT

R_HIT_45_D:
	MOV r4, #6
	STRB r4, [r5]
	B NO_HIT

R_HIT_60_D:
	MOV r4, #7
	STRB r4, [r5]
	B NO_HIT

T_HIT: ; Change direction from NE to SE or NW to SW
	LDR r5, ptr_to_current_dir

	CMP r4, #2
	BEQ T_HIT_45_R

	CMP r4, #3
	BEQ T_HIT_60_R

	CMP r4, #8
	BEQ T_HIT_45_L

	CMP r4, #9
	BEQ T_HIT_60_L

	CMP r4, #0
	BEQ T_HIT_U

T_HIT_45_R:
	MOV r4, #4
	STRB r4, [r5]
	B NO_HIT

T_HIT_60_R:
	MOV r4, #5
	STRB r4, [r5]
	B NO_HIT

T_HIT_45_L:
	MOV r4, #6
	STRB r4, [r5]
	B NO_HIT

T_HIT_60_L:
	MOV r4, #7
	STRB r4, [r5]
	B NO_HIT

T_HIT_U:
	MOV r4, #1
	STRB r4, [r5]
	B NO_HIT

B_HIT: ; Change direction from SE to NE or SW to NW, change angle depending on paddle hit, or lose life
	LDR r6, ptr_to_paddle_left
	LDRB r6, [r6]

	CMP r5, r6
	BEQ OUT_PAD

	ADD r6, r6, #1
	CMP r5, r6
	BEQ IN_PAD

	ADD r6, r6, #1
	CMP r5, r6
	BEQ MID_PAD

	LDR r6, ptr_to_paddle_right
	LDRB r6, [r6]

	CMP r5, r6
	BEQ OUT_PAD

	SUB r6, r6, #1
	CMP r5, r6
	BEQ IN_PAD

	B LOSE

OUT_PAD: ; Change angle to 45�
	LDR r6, ptr_to_current_dir

	CMP r4, #4
	BEQ OUT_PAD_45_R

	CMP r4, #5
	BEQ OUT_PAD_60_R

	CMP r4, #6
	BEQ OUT_PAD_45_L

	CMP r4, #7
	BEQ OUT_PAD_60_L

	CMP r4, #1
	BEQ OUT_PAD_U

OUT_PAD_45_R:
	MOV r4, #2
	STRB r4, [r6]
	B NO_HIT

OUT_PAD_60_R:
	MOV r4, #2
	STRB r4, [r6]
	B NO_HIT

OUT_PAD_45_L:
	MOV r4, #8
	STRB r4, [r6]
	B NO_HIT

OUT_PAD_60_L:
	MOV r4, #8
	STRB r4, [r6]
	B NO_HIT

OUT_PAD_U:
	LDR r8, ptr_to_paddle_left
	LDRB r8, [r8]

	CMP r5, r8
	BEQ OUT_PAD_UL

	LDR r8, ptr_to_paddle_right
	LDRB r8, [r8]

	CMP r5, r8
	BEQ OUT_PAD_UR

OUT_PAD_UL:
	MOV r4, #8
	STRB r4, [r6]
	B NO_HIT

OUT_PAD_UR:
	MOV r4, #2
	STRB r4, [r6]
	B NO_HIT

IN_PAD: ; Change angle to 60�
	LDR r6, ptr_to_current_dir

	CMP r4, #4
	BEQ IN_PAD_45_R

	CMP r4, #5
	BEQ IN_PAD_60_R

	CMP r4, #6
	BEQ IN_PAD_45_L

	CMP r4, #7
	BEQ IN_PAD_60_L

	CMP r4, #1
	BEQ IN_PAD_U

IN_PAD_45_R:
	MOV r4, #3
	STRB r4, [r6]
	B NO_HIT

IN_PAD_60_R:
	MOV r4, #3
	STRB r4, [r6]
	B NO_HIT

IN_PAD_45_L:
	MOV r4, #9
	STRB r4, [r6]
	B NO_HIT

IN_PAD_60_L:
	MOV r4, #9
	STRB r4, [r6]
	B NO_HIT

IN_PAD_U:
	LDR r8, ptr_to_paddle_left
	LDRB r8, [r8]
	ADD r8, r8, #1

	CMP r5, r8
	BEQ IN_PAD_UL

	LDR r8, ptr_to_paddle_right
	LDRB r8, [r8]
	SUB r8, r8, #1

	CMP r5, r8
	BEQ IN_PAD_UR

IN_PAD_UL:
	MOV r4, #9
	STRB r4, [r6]
	B NO_HIT

IN_PAD_UR:
	MOV r4, #3
	STRB r4, [r6]
	B NO_HIT

MID_PAD: ; Change angle to 45�
	LDR r6, ptr_to_current_dir

	CMP r4, #4
	BEQ MID_PAD_45_R

	CMP r4, #5
	BEQ MID_PAD_60_R

	CMP r4, #6
	BEQ MID_PAD_45_L

	CMP r4, #7
	BEQ MID_PAD_60_L

	CMP r4, #1
	BEQ MID_PAD_U

MID_PAD_45_R:
	MOV r4, #0
	STRB r4, [r6]
	B NO_HIT

MID_PAD_60_R:
	MOV r4, #0
	STRB r4, [r6]
	B NO_HIT

MID_PAD_45_L:
	MOV r4, #0
	STRB r4, [r6]
	B NO_HIT

MID_PAD_60_L:
	MOV r4, #0
	STRB r4, [r6]
	B NO_HIT

MID_PAD_U:
	MOV r4, #0
	STRB r4, [r6]
	B NO_HIT


LOSE:
	LDR r0, ptr_to_clear_ball
	BL output_string

	LDR r0, ptr_to_lives
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]
	CMP r1, #3
	BEQ three
	CMP r1, #2
	BEQ two
	CMP r1, #1
	BEQ one
	CMP r1, #0
	BEQ zero

three:
	MOV r0, #7
	BL illuminate_LEDs

	LDR r0, ptr_to_ball_start
	BL output_string

	LDR r0, ptr_to_cur_left
	BL output_string

	LDR r0, ptr_to_save_cur
	BL output_string

	MOV r1, #8
	MOV r2, #12

	LDR r0, ptr_to_ball_row
	STRB r1, [r0]
	LDR r0, ptr_to_ball_col
	STRB r2, [r0]

	LDR r0, ptr_to_current_dir
	MOV r1, #1
	STRB r1, [r0]
	B NO_HIT

two:
	MOV r0, #3
	BL illuminate_LEDs

	LDR r0, ptr_to_ball_start
	BL output_string

	LDR r0, ptr_to_cur_left
	BL output_string

	LDR r0, ptr_to_save_cur
	BL output_string

	MOV r1, #8
	MOV r2, #12

	LDR r0, ptr_to_ball_row
	STRB r1, [r0]
	LDR r0, ptr_to_ball_col
	STRB r2, [r0]

	LDR r0, ptr_to_current_dir
	MOV r1, #1
	STRB r1, [r0]
	B NO_HIT

one:
	MOV r0, #1
	BL illuminate_LEDs

	LDR r0, ptr_to_ball_start
	BL output_string

	LDR r0, ptr_to_cur_left
	BL output_string

	LDR r0, ptr_to_save_cur
	BL output_string

	MOV r1, #8
	MOV r2, #12

	LDR r0, ptr_to_ball_row
	STRB r1, [r0]
	LDR r0, ptr_to_ball_col
	STRB r2, [r0]

	LDR r0, ptr_to_current_dir
	MOV r1, #1
	STRB r1, [r0]
	B NO_HIT

zero:
    MOV r0, #0
    BL illuminate_LEDs

    LDR r0, ptr_to_game_state
    MOV r1, #3
    STRB r1, [r0]

    B skip


NO_HIT:

	; Check if level is over
	LDR r0, ptr_to_brick_count
	LDRB r0, [r0]
	CMP r0, #0
	BEQ new_level

	; Restore cursor postion
	LDR r0, ptr_to_rest_cur
	BL output_string

	; Clear previous ball
	LDR r0, ptr_to_clear_ball
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Branch to up direction
	CMP r4, #0
	BEQ U

	; Branch to down direction
	CMP r4, #1
	BEQ D

	; Branch to 45� NE direction
	CMP r4, #2
	BEQ NE45

	; Branch to 60� NE direction
	CMP r4, #3
	BEQ NE60

	; Branch to 45� SE direction
	CMP r4, #4
	BEQ SE45

	; Branch to 60� SE direction
	CMP r4, #5
	BEQ SE60

	; Branch to 45� SW direction
	CMP r4, #6
	BEQ SW45

	; Branch to 60� SW direction
	CMP r4, #7
	BEQ SW60

	; Branch to 45� NW direction
	CMP r4, #8
	BEQ NW45

	; Branch to 60� NW direction
	CMP r4, #9
	BEQ NW60


U:	; Move '*' up on board

	; Move '*' up
	LDR r0, ptr_to_move_up
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	SUB r2, r2, #1
	STRB r2, [r5]

	B DNE

D:	; Move '*' down on board

	; Move '*' down
	LDR r0, ptr_to_move_down
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	ADD r2, r2, #1
	STRB r2, [r5]

	B DNE

NE45:	; Move '*' north east on board at 45� angle

	; Move cursor up
	LDR r0, ptr_to_cur_up
	BL output_string

	; Move cursor right and print '*'
	LDR r0, ptr_to_move_right
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row & col postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	SUB r2, r2, #1
	STRB r2, [r5]

	LDR r6, ptr_to_ball_col
	LDRB r2, [r6]
	ADD r2, r2, #1
	STRB r2, [r6]

	B DNE

NE60:	; Move '*' north east on board at 60� angle

	; Move cursor up
	LDR r0, ptr_to_cur_up
	BL output_string

	; Move cursor up
	LDR r0, ptr_to_cur_up
	BL output_string

	; Move cursor right and print '*'
	LDR r0, ptr_to_move_right
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row & col postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	SUB r2, r2, #2
	STRB r2, [r5]

	LDR r6, ptr_to_ball_col
	LDRB r2, [r6]
	ADD r2, r2, #1
	STRB r2, [r6]

	B DNE

SE45:	; Move '*' south east on board at 45� angle

	; Move cursor down
	LDR r0, ptr_to_cur_down
	BL output_string

	; Move cursor right and print '*'
	LDR r0, ptr_to_move_right
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row & col postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	ADD r2, r2, #1
	STRB r2, [r5]

	LDR r6, ptr_to_ball_col
	LDRB r2, [r6]
	ADD r2, r2, #1
	STRB r2, [r6]

	B DNE

SE60:	; Move '*' south east on board at 60� angle

	; Move cursor down
	LDR r0, ptr_to_cur_down
	BL output_string

	; Move cursor down
	LDR r0, ptr_to_cur_down
	BL output_string

	; Move cursor right and print '*'
	LDR r0, ptr_to_move_right
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row & col postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	ADD r2, r2, #2
	STRB r2, [r5]

	LDR r6, ptr_to_ball_col
	LDRB r2, [r6]
	ADD r2, r2, #1
	STRB r2, [r6]

	B DNE

SW45:	; Move '*' south west on board at 45� angle

	; Move cursor down
	LDR r0, ptr_to_cur_down
	BL output_string

	; Move cursor left and print '*'
	LDR r0, ptr_to_move_left
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row & col postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	ADD r2, r2, #1
	STRB r2, [r5]

	LDR r6, ptr_to_ball_col
	LDRB r2, [r6]
	SUB r2, r2, #1
	STRB r2, [r6]

	B DNE

SW60:	; Move '*' south west on board at 60� angle

	; Move cursor down
	LDR r0, ptr_to_cur_down
	BL output_string

	; Move cursor down
	LDR r0, ptr_to_cur_down
	BL output_string

	; Move cursor left and print '*'
	LDR r0, ptr_to_move_left
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row & col postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	ADD r2, r2, #2
	STRB r2, [r5]

	LDR r6, ptr_to_ball_col
	LDRB r2, [r6]
	SUB r2, r2, #1
	STRB r2, [r6]

	B DNE

NW45:	; Move '*' north west on board at 45� angle

	; Move cursor up
	LDR r0, ptr_to_cur_up
	BL output_string

	; Move cursor left and print '*'
	LDR r0, ptr_to_move_left
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row & col postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	SUB r2, r2, #1
	STRB r2, [r5]

	LDR r6, ptr_to_ball_col
	LDRB r2, [r6]
	SUB r2, r2, #1
	STRB r2, [r6]

	B DNE

NW60:	; Move '*' north west on board at 60� angle

	; Move cursor up
	LDR r0, ptr_to_cur_up
	BL output_string

	; Move cursor up
	LDR r0, ptr_to_cur_up
	BL output_string

	; Move cursor left and print '*'
	LDR r0, ptr_to_move_left
	BL output_string

	; Reset cursor
	LDR r0, ptr_to_cur_left
	BL output_string

	; Save cursor position
	LDR r0, ptr_to_save_cur
	BL output_string

	; Change row & col postion value
	LDR r5, ptr_to_ball_row
	LDRB r2, [r5]
	SUB r2, r2, #2
	STRB r2, [r5]

	LDR r6, ptr_to_ball_col
	LDRB r2, [r6]
	SUB r2, r2, #1
	STRB r2, [r6]

	B DNE

new_level:
	LDR r0, ptr_to_game_state
	MOV r1, #4
	STRB r1,[r0]
	B skip

DNE:

	; Update counter for amount of times '*'
	LDRB r2, [r7]
	ADD r2, r2, #1
	STRB r2, [r7]


skip:
	POP {r4-r11,LR}

	BX lr       	; Return


simple_read_character:

	MOV r0, #0xC000
	MOVT r0, #0x4000
	LDRB r0, [r0]

	MOV PC,LR      	; Return

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

read_from_push_btns:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here

	 MOV r0, #0x7000
	 MOVT r0, #0x4000
	 LDRB r1, [r0, #GPIODATA]
	 AND r1, r1, #0x0F
	 CMP r1, #0x08
	 BEQ ONE
	 CMP r1, #0x04
	 BEQ TWO
	 CMP r1, #0x02
	 BEQ THREE
	 CMP r1, #0x01
	 BEQ FOUR
	 B ZERO

ZERO:	MOV r0, #0
		B END
ONE:	MOV r0, #1
		B END
TWO:	MOV r0, #2
		B END
THREE:	MOV r0, #3
		B END
FOUR:	MOV r0, #4
		B END

END:	LDR r1, ptr_to_brick_row_num
	STRB r0, [r1]

	POP {lr}
	MOV pc, lr


illuminate_LEDs:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	;MOV r1, #0x5000
	;MOVT r1, #0x4000 ; Assign base address of Port B to r1
	LDR r1, GPIO_PORT_B ; Assign base address of Port B to r1

	; Setting pins 0-3 of Port B to output
	LDRB r2, [r1, #GPIODIR] ; Load Port B Direction Register from memory to r2
    ORR r2, r2, #0xF ; Set pin 0, 1, 2, and 3 to 0b1
    STRB r2, [r1, #GPIODIR] ; Store Port B Direction Register back to memory

    ; Enabling pins 0-3 of Port B to digital
    LDRB r2, [r1, #GPIODEN] ; Load Port B Digitial Enable Register from memory to r2
    ORR r2, r2, #0xE ; Set pin 0, 1, 2, and 3 to 0b1
    STRB r2, [r1, #GPIODEN] ; Store Port B Digital Enable Register back to memory

    ; Turn on LED Lights (Pin 3 = LED3; Pin 2  LED2; Pin 1 = LED1; Pin 0 = LED0)
    LDRB r2, [r1, #GPIODATA] ; Load Port B Data Register from memory to r2
    AND r2, r2, #0xF0 ; Reset all LED lights
    ORR r2, r2, r0 ; Turn on desited LED lights
    STRB r2, [r1, #GPIODATA] ; Store Port B Data Register back to memory

	POP {lr}
	MOV pc, lr


illuminate_RGB_LED:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
    ;MOV r1, #0x5000
    ;MOVT r1, #0x4002 ; Assign base address of Port F to r1
          LDR r1, GPIO_PORT_F ; Assign base address of Port F to r1

          ; Setting pins 1 (red), 2 (blue), and 3 (green) of Port F to output
          LDRB r2, [r1, #GPIODIR] ; Load Port F Direction Register from memory to r2
          ORR r2, r2, #0x0E ; Set pin 1, 2, and 3 to 1
          STRB r2, [r1, #GPIODIR] ; Store Port F Direction Register back to memory

          ;Enabling pins 1 (red), 2 (blue), and 3 (green) of Port F to digital
          LDRB r2, [r1, #GPIODEN] ; Load Port F Digitial Enable Register from memory to r2
          ORR r2, r2, #0x0E ; Set pin 1, 2, and 3 to 1
          STRB r2, [r1, #GPIODEN] ; Store Port F Digital Enable Register back to memory

          ; Turn on LED Light (r0 = Red: 0b001; Blue: 0b010; Green: 0b100; Purple: 0b011; Yellow: 0b101; White: 0b111)
          LDRB r2, [r1, #GPIODATA] ; Load Port F Data Register from memory to r2
          AND r2, r2, #0xF1 ; Reset all LED lights
          ORR r2, r2, r0 ; Turn on desited LED lights
          STRB r2, [r1, #GPIODATA] ; Store Port F Data Register back to memory

	POP {lr}
	MOV pc, lr


read_tiva_pushbutton:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #GPIOPUR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPIOPUR]

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #GPIODIR]
	AND r1, r1, #0xEF
	STRB r1, [r0, #GPIODIR]

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #GPIODEN]
	ORR r1, r1, #0x10
	STRB r1, [r0, #GPIODEN]


	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #GPIODATA]
	AND r1, r1, #0x10
	CMP r1, #0x10
    BEQ NOTP
    MOV r0, #0
    B END2

NOTP:  MOV r0, #1

END2:    POP {lr}
	MOV pc, lr


; Produces modulo operation - INPUTS: r0=divident, r1=modulus; OUTPUT: r0=result
modulo:
	PUSH {r4-r8, r10-r11, lr}

	SDIV r4, r0, r1
	MUL r4, r4, r1		;Mod the intial integer
	SUB r0, r0, r4

	POP {r4-r8, r10-r11, lr}
	MOV pc, lr

; Produces a random number between 0 and 4 to produce an option of 5 ranodom colors for the bricks and save to memory
color_rand:
	PUSH {r4-r8, r10-r11, lr}

	; Move base address of Timer0 to r0
	MOV r4, #0x0000
	MOVT r4, #0x4003

	; Set r0 to timer value and r1 to decimal 5 inorder to produce randomness between 0 and 4
	LDR r0, [r4, #GPTMTAR]
	MOV r1, #5
	BL modulo ; Returns random number to r0

	LDR r5, ptr_to_brick_color
	STRB r0, [r5]

	POP {r4-r8, r10-r11, lr}
	MOV pc, lr

; Print bricks with right amount of rows - INPUT: r0=num of rows
print_bricks:
	PUSH {r4-r8, r10-r11, lr}

	; Save address of Timer Interval Load Register to r7
	MOV r7, #0x0028
	MOVT r7, #0x4003

	; Get current timer interval
	LDR r8, [r7]

	; Push interval to stack
	PUSH {r8}

	; Reduce interval to imitate more randomness
	MOV r8, #0x00C0

	; Store new interval to memory
	STR r8, [r7]

	MOV r4, r0 ; Save number of rows to r4
	MOV r6, #1 ; Register that will be used to move cursor down to right line
	LDR r0, ptr_to_brick_start
	BL output_string

	; Save ptr_to_brick_stat to r10
	LDR r10, ptr_to_brick_stat

BR_LOOP:
	MOV r5, #7
BR_LOOP_2:
	BL color_rand

	CMP r0, #0
	BEQ RED

	CMP r0, #1
	BEQ GREEN

	CMP r0, #2
	BEQ PURPLE

	CMP r0, #3
	BEQ BLUE

	CMP r0, #4
	BEQ YELLOW

RED:
	; Print red brick
	LDR r0, ptr_to_red_brick
	BL output_string

	; Update brick_stat
	LDR r11, ptr_to_red_stat
	LDR r11, [r11]
	STRB r11, [r10]
	ADD r10, r10, #1

	B BR_L2_END
GREEN:
	; Print green brick
	LDR r0, ptr_to_green_brick
	BL output_string

	; Update brick_stat
	LDR r11, ptr_to_green_stat
	LDR r11, [r11]
	STRB r11, [r10]
	ADD r10, r10, #1

	B BR_L2_END
PURPLE:
	; Print purple brick
	LDR r0, ptr_to_purple_brick
	BL output_string

	; Update brick_stat
	LDR r11, ptr_to_purple_stat
	LDR r11, [r11]
	STRB r11, [r10]
	ADD r10, r10, #1

	B BR_L2_END
BLUE:
	; Print blue brick
	LDR r0, ptr_to_blue_brick
	BL output_string

	; Update brick_stat
	LDR r11, ptr_to_blue_stat
	LDR r11, [r11]
	STRB r11, [r10]
	ADD r10, r10, #1

	B BR_L2_END
YELLOW:
	; Print yellow brick
	LDR r0, ptr_to_yellow_brick
	BL output_string

	; Update brick_stat
	LDR r11, ptr_to_yellow_stat
	LDR r11, [r11]
	STRB r11, [r10]
	ADD r10, r10, #1

	B BR_L2_END

BR_L2_END:

	SUB r5, r5, #1
	CMP r5, #0
	BNE BR_LOOP_2

	SUB r4, r4, #1
	CMP r4, #0
	BEQ BRL_END

	; If we have more rows to create, move cursor down one line and back to first brick col
	LDR r0, ptr_to_brick_start
	BL output_string
	PUSH {r6}
L_DOWN:
	LDR r0, ptr_to_cur_down
	BL output_string
	SUB r6, r6, #1
	CMP r6, #0
	BNE L_DOWN
	POP {r6}
	ADD r6, r6, #1
	B BR_LOOP

BRL_END:

	; Restore old timer interval
	POP {r8}

	; Save interval to memory
	STR r8, [r7]

	POP {r4-r8, r10-r11, lr}
	MOV pc, lr

	.end
