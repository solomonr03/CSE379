	.data

	.global brick_stat
	.global current_dir
	.global rest_cur
	.global save_cur
	.global cur_right
	.global cur_left
	.global cur_up
	.global cur_down
	.global ball_col
	.global ball_row
	.global ball_color
	.global clear_brick
	.global set_red
	.global set_green
	.global set_purple
	.global set_blue
	.global set_yellow
	.global reset_foreground
	.global score
	.global level
	.global clear_ball
	.global game_state
	.global brick_count
	.global score_prompt
	.global score_str

board_start:				.string		27, "[3;2H", 0
score_start:				.string		27, "[1;1H", 0
clear_line:					.string		27, "[K", 0


	.text

	.global NO_HIT
	.global output_string
	.global illuminate_RGB_LED
	.global check_brick_hit
	.global	set_ball_color
	.global modulo
	.global int2string

ptr_to_brick_stat:				.word brick_stat
ptr_to_current_dir:				.word current_dir
ptr_to_rest_cur:				.word rest_cur
ptr_to_save_cur:				.word save_cur
ptr_to_cur_right:				.word cur_right
ptr_to_cur_left:				.word cur_left
ptr_to_cur_up:					.word cur_up
ptr_to_cur_down:				.word cur_down
ptr_to_ball_col:				.word ball_col
ptr_to_ball_row:				.word ball_row
ptr_to_clear_brick:				.word clear_brick
ptr_to_ball_color:				.word ball_color
ptr_to_set_red:					.word set_red
ptr_to_set_green:				.word set_green
ptr_to_set_purple:				.word set_purple
ptr_to_set_blue:				.word set_blue
ptr_to_set_yellow:				.word set_yellow
ptr_to_reset_foreground:		.word reset_foreground
ptr_to_score:					.word score
ptr_to_level:					.word level
ptr_to_board_start:				.word board_start
ptr_to_clear_ball:				.word clear_ball
ptr_to_game_state:				.word game_state
ptr_to_brick_count:				.word brick_count
ptr_to_score_start:				.word score_start
ptr_to_clear_line:				.word clear_line
ptr_to_score_prompt:			.word score_prompt
ptr_to_score_str:				.word score_str



check_brick_hit: ; r0=current direction; r1=ball row; r2=ball column

	; Convert column number to brick number in given row and save to r4
	MOV r4, #0
	CMP r2, #3
	BLE SKIP_COL_CHNG

	SUB r4, r2, #4 ; Subtract col by 4
	MOV r5, #3
	SDIV r4, r4, r5 ; Divide col by 3
	ADD r4, r4, #1 ; Add 1 to col

SKIP_COL_CHNG:


	; 45� movement
	CMP r0, #2 ; NE
	BEQ BR_H_NE45

	CMP r0, #4 ; SE
	BEQ BR_H_SE45

	CMP r0, #6 ; SW
	BEQ BR_H_SW45

	CMP r0, #8 ; NW
	BEQ BR_H_NW45

	; 60� movement
	CMP r0, #3 ; NE
	BEQ BR_H_NE60

	CMP r0, #5 ; SE
	BEQ BR_H_SE60

	CMP r0, #7 ; SW
	BEQ BR_H_SW60

	CMP r0, #9 ; NW
	BEQ BR_H_NW60

	; up & down movement
	CMP r0, #0 ; N
	BEQ BR_H_U

	CMP r0, #1 ; S
	BEQ BR_H_D

BR_H_NE45:
	; Check if space above is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r1, r2}
	SUB r1, r1, #2
	MOV r2, #7
	MUL r5, r1, r2
	POP {r1, r2}

	; Get brick status of 1 space above
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2}
	SUB r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2}

	; Change direction from NE to SE
	LDR r7, ptr_to_current_dir
	MOV r8, #4
	STRB r8, [r7]

	B NO_HIT

BR_H_SE45:
	; Check if space below is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0}
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0}

	; Get brick status of 1 space below
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2}
	ADD r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2}

	; Change direction from SE to NE
	LDR r7, ptr_to_current_dir
	MOV r8, #2
	STRB r8, [r7]

	B NO_HIT

BR_H_NW45:
	; Check if space above is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0, r1}
	SUB r1, r1, #2
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0, r1}

	; Get brick status of 1 space above
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2}
	SUB r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2}

	; Change direction from NW to SW
	LDR r7, ptr_to_current_dir
	MOV r8, #6
	STRB r8, [r7]

	B NO_HIT

BR_H_SW45:
	; Check if space below is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0}
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0}

	; Get brick status of 1 space below
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2}
	ADD r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2}

	; Change direction from SW to NW
	LDR r7, ptr_to_current_dir
	MOV r8, #8
	STRB r8, [r7]

	B NO_HIT

BR_H_NE60:
	; Check if space 1 above and 1 to the right is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0, r1}
	SUB r1, r1, #2
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0, r1}

	; Move column one the the right
	ADD r4, r4, #1

	; Get brick status of 1 space above
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5


	; If there is no brick, move to CHECK_2_NE60 in Timer_Handler
	PUSH {r6}
	LDRB r6, [r6]
	CMP r6, #0x58
	MOV r10, r6
	POP {r6}
	BEQ CHECK_2_NE60

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r6]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2, r4}
	SUB r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r10 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2, r4}

	; Prep for redirection. Move ball location one space to the right
	LDR r0, ptr_to_rest_cur
	BL output_string
	LDR r0, ptr_to_clear_ball
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string

	LDR r11, ptr_to_ball_col
	LDRB r10, [r11]
	ADD r10, r10, #1
	STRB r10, [r11]

	; Change direction from NE to SE
	LDR r7, ptr_to_current_dir
	MOV r8, #5
	STRB r8, [r7]

	B NO_HIT


CHECK_2_NE60:
	; Check if space 2 above and 1 to the right is a brick
	SUB r6, r6, #7

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2, r4}
	SUB r0, r1, #2
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2, r4}

	; Prep for redirection. Move ball location one space to the right
	LDR r0, ptr_to_rest_cur
	BL output_string
	LDR r0, ptr_to_clear_ball
	BL output_string
	LDR r0, ptr_to_cur_up
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string

	LDR r11, ptr_to_ball_col
	LDRB r10, [r11]
	ADD r10, r10, #1
	STRB r10, [r11]

	LDR r11, ptr_to_ball_row
	LDRB r10, [r11]
	SUB r10, r10, #1
	STRB r10, [r11]

	; Change direction from NE to SE
	LDR r7, ptr_to_current_dir
	MOV r8, #5
	STRB r8, [r7]

	B NO_HIT

BR_H_SE60:
	; Check if space 1 below and 1 to the right is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0}
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0}

	; Move column one the the right
	ADD r4, r4, #1

	; Get brick status of 1 space below
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	; If there is no brick, move to CHECK_2_SE60 in Timer_Handler
	PUSH {r6}
	LDRB r6, [r6]
	CMP r6, #0x58
	MOV r10, r6
	POP {r6}
	BEQ CHECK_2_SE60

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r6]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2, r4}
	ADD r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r10 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2, r4}

	; Prep for redirection. Move ball location one space to the right
	LDR r0, ptr_to_rest_cur
	BL output_string
	LDR r0, ptr_to_clear_ball
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string

	LDR r11, ptr_to_ball_col
	LDRB r10, [r11]
	ADD r10, r10, #1
	STRB r10, [r11]

	; Change direction from SE to NE
	LDR r7, ptr_to_current_dir
	MOV r8, #3
	STRB r8, [r7]

	B NO_HIT


CHECK_2_SE60:
	; Check if space 2 below and 1 to the right is a brick
	ADD r6, r6, #7

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2, r4}
	ADD r0, r1, #2
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2, r4}

	; Prep for redirection. Move ball location one space to the right
	LDR r0, ptr_to_rest_cur
	BL output_string
	LDR r0, ptr_to_clear_ball
	BL output_string
	LDR r0, ptr_to_cur_down
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string

	LDR r11, ptr_to_ball_col
	LDRB r10, [r11]
	ADD r10, r10, #1
	STRB r10, [r11]

	LDR r11, ptr_to_ball_row
	LDRB r10, [r11]
	ADD r10, r10, #1
	STRB r10, [r11]

	; Change direction from SE to NE
	LDR r7, ptr_to_current_dir
	MOV r8, #3
	STRB r8, [r7]

	B NO_HIT

BR_H_SW60:
	; Check if space 1 below and 1 to the left is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0}
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0}

	; Move column one the the left
	SUB r4, r4, #1

	; Get brick status of 1 space below
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	; If there is no brick, move to CHECK_2_SW60 in Timer_Handler
	PUSH {r6}
	LDRB r6, [r6]
	CMP r6, #0x58
	MOV r10, r6
	POP {r6}
	BEQ CHECK_2_SW60

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r6]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2, r4}
	ADD r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r10 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2, r4}

	; Prep for redirection. Move ball location one space to the left
	LDR r0, ptr_to_rest_cur
	BL output_string
	LDR r0, ptr_to_clear_ball
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string

	LDR r11, ptr_to_ball_col
	LDRB r10, [r11]
	SUB r10, r10, #1
	STRB r10, [r11]

	; Change direction from SE to NE
	LDR r7, ptr_to_current_dir
	MOV r8, #3
	STRB r8, [r7]

	B NO_HIT


CHECK_2_SW60:
	; Check if space 2 below and 1 to the left is a brick
	PUSH {r0}
	MOV r0, #7
	ADD r6, r6, r0
	POP {r0}

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2, r4}
	ADD r0, r1, #2
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2, r4}

	; Prep for redirection. Move ball location one space to the left
	LDR r0, ptr_to_rest_cur
	BL output_string
	LDR r0, ptr_to_clear_ball
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_cur_down
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string

	LDR r11, ptr_to_ball_col
	LDRB r10, [r11]
	SUB r10, r10, #1
	STRB r10, [r11]

	LDR r11, ptr_to_ball_row
	LDRB r10, [r11]
	ADD r10, r10, #1
	STRB r10, [r11]

	; Change direction from SE to NE
	LDR r7, ptr_to_current_dir
	MOV r8, #3
	STRB r8, [r7]

	B NO_HIT

BR_H_NW60:
	; Check if space 1 above and 1 to the elft is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0, r1}
	SUB r1, r1, #2
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0, r1}

	; Move column one the the left
	SUB r4, r4, #1

	; Get brick status of 1 space above
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	; If there is no brick, move to CHECK_2_NW60 in Timer_Handler
	PUSH {r6}
	LDRB r6, [r6]
	CMP r6, #0x58
	MOV r10, r6
	POP {r6}
	BEQ CHECK_2_NW60

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r6]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2, r4}
	SUB r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r10 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2, r4}

	; Prep for redirection. Move ball location one space to the left
	LDR r0, ptr_to_rest_cur
	BL output_string
	LDR r0, ptr_to_clear_ball
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string

	LDR r11, ptr_to_ball_col
	LDRB r10, [r11]
	SUB r10, r10, #1
	STRB r10, [r11]

	; Change direction from NW to SW
	LDR r7, ptr_to_current_dir
	MOV r8, #7
	STRB r8, [r7]

	B NO_HIT


CHECK_2_NW60:
	; Check if space 2 above and 1 to the left is a brick
	SUB r6, r6, #7

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2, r4}
	SUB r0, r1, #2
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2, r4}

	; Prep for redirection. Move ball location one space to the left
	LDR r0, ptr_to_rest_cur
	BL output_string
	LDR r0, ptr_to_clear_ball
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_cur_left
	BL output_string
	LDR r0, ptr_to_cur_up
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string

	LDR r11, ptr_to_ball_col
	LDRB r10, [r11]
	SUB r10, r10, #1
	STRB r10, [r11]

	LDR r11, ptr_to_ball_row
	LDRB r10, [r11]
	SUB r10, r10, #1
	STRB r10, [r11]

	; Change direction from NW to SW
	LDR r7, ptr_to_current_dir
	MOV r8, #7
	STRB r8, [r7]

	B NO_HIT

BR_H_U:
	; Check if space above is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0, r1}
	SUB r1, r1, #2
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0, r1}

	; Get brick status of 1 space above
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2}
	SUB r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2}

	; Change direction from NE to SE
	LDR r7, ptr_to_current_dir
	MOV r8, #1
	STRB r8, [r7]

	B NO_HIT

BR_H_D:
	; Check if space below is a brick
	; Convert row number to offset of the beginning of the row in brick_stat
	PUSH {r0}
	MOV r0, #7
	MUL r5, r1, r0
	POP {r0}

	; Get brick status of 1 space below
	LDR r6, ptr_to_brick_stat
	ADD r6, r6, #7 ; skip padding
	ADD r6, r6, r4
	ADD r6, r6, r5

	MOV r10, r6

	; If there is no brick, move to NO_HIT in Timer_Handler
	LDRB r6, [r6]
	CMP r6, #0x58
	BEQ NO_HIT

	; Store 'X' in current spot of brick_stat
	PUSH {r4}
	MOV r4, #0x58
	STRB r4, [r10]
	POP {r4}

	BL increase_score

	;Decrease brick count
	LDR r0, ptr_to_brick_count
	LDRB r1, [r0]
	SUB r1, r1, #1
	STRB r1, [r0]

	PUSH {r0, r1, r2}
	ADD r0, r1, #1
	MOV r2, #3
	MUL r1, r4, r2
	BL del_brick

	MOV r0, r6 ; Move brick stat to r0
	BL chng_color
	POP {r0, r1, r2}

	; Change direction from SE to NE
	LDR r7, ptr_to_current_dir
	MOV r8, #0
	STRB r8, [r7]

	B NO_HIT

del_brick: ; r0=row offset, r1=col offset
	PUSH {r4-r8, r10-r11, lr}

	; Move cursor to brick
	PUSH {r0, r1}
	BL cur_to_brick
	POP {r0, r1}

	; Delete brick on board
	LDR r0, ptr_to_clear_brick
	BL output_string

	POP {r4-r8, r10-r11, lr}
	MOV pc, lr

cur_to_brick: ; moves cursor to brick we want to delete
	PUSH {r4-r8, r10-r11, lr}

	SUB r4, r0, #1 ; Move row offset to r4
	MOV r5, r1 ; Move col offset to r5

	LDR r0, ptr_to_board_start
	BL output_string

CUR_LOOP:
	LDR r0, ptr_to_cur_down
	BL output_string
	SUB r4, r4, #1
	CMP r4, #0
	BNE CUR_LOOP

	CMP r5, #0
	BEQ CUR_END

CUR_LOOP2:
	LDR r0, ptr_to_cur_right
	BL output_string
	SUB r5, r5, #1
	CMP r5, #0
	BNE CUR_LOOP2

CUR_END:

	POP {r4-r8, r10-r11, lr}
	MOV pc, lr

chng_color: ; r0=color stat
	PUSH {r4-r8, r10-r11, lr}

	CMP r0, #0x52
	BEQ C_RED

	CMP r0, #0x47
	BEQ C_GREEN

	CMP r0, #0x50
	BEQ C_PURPLE

	CMP r0, #0x42
	BEQ C_BLUE

	CMP r0, #0x59
	BEQ C_YELLOW

C_RED:
	MOV r4, #0
	LDR r5, ptr_to_ball_color

	STRB r4, [r5]

	MOV r0, #0x02
	BL illuminate_RGB_LED

	B C_END

C_GREEN:
	MOV r4, #1
	LDR r5, ptr_to_ball_color

	STRB r4, [r5]

	MOV r0, #0x08
	BL illuminate_RGB_LED

	B C_END

C_PURPLE:
	MOV r4, #2
	LDR r5, ptr_to_ball_color

	STRB r4, [r5]

	MOV r0, #0x06
	BL illuminate_RGB_LED

	B C_END

C_BLUE:
	MOV r4, #3
	LDR r5, ptr_to_ball_color

	STRB r4, [r5]

	MOV r0, #0x04
	BL illuminate_RGB_LED

	B C_END

C_YELLOW:
	MOV r4, #4
	LDR r5, ptr_to_ball_color

	STRB r4, [r5]

	MOV r0, #0x0A
	BL illuminate_RGB_LED

	B C_END

C_END:

	POP {r4-r8, r10-r11, lr}
	MOV pc, lr

set_ball_color:
	PUSH {r4-r8, r10-r11, lr}

	LDR r4, ptr_to_ball_color
	LDRB r4, [r4]

	CMP r4, #0
	BEQ S_RED

	CMP r4, #1
	BEQ S_GREEN

	CMP r4, #2
	BEQ S_PURPLE

	CMP r4, #3
	BEQ S_BLUE

	CMP r4, #4
	BEQ S_YELLOW

	CMP r4, #5
	BEQ S_WHITE

S_RED:
	LDR r0, ptr_to_set_red
	BL output_string

	B S_END

S_GREEN:
	LDR r0, ptr_to_set_green
	BL output_string

	B S_END

S_PURPLE:
	LDR r0, ptr_to_set_purple
	BL output_string

	B S_END

S_BLUE:
	LDR r0, ptr_to_set_blue
	BL output_string

	B S_END

S_YELLOW:
	LDR r0, ptr_to_set_yellow
	BL output_string

	B S_END

S_WHITE:
	LDR r0, ptr_to_reset_foreground
	BL output_string

	B S_END

S_END:

	POP {r4-r8, r10-r11, lr}
	MOV pc, lr

increase_score:
	PUSH {r4-r8, r10-r11, lr}

	LDR r4, ptr_to_score
	LDR r4, [r4]

	LDR r5, ptr_to_level
	LDR r5, [r5]

	ADD r4, r4, r5

	LDR r5, ptr_to_score
	STRB r4, [r5]

	LDR r0, ptr_to_score_start
	BL output_string

	LDR r0, ptr_to_clear_line
	BL output_string

	LDR r0, ptr_to_score_prompt ;Load the base address of the score prompt into r0
    BL output_string            ;Output Score prompt to terminal

    LDR r0, ptr_to_score        ;Load the address of the score into r0
    LDRB r0, [r0]                ;Get the actual score
    LDR r1, ptr_to_score_str    ;Load the placeholder string for conversion
    BL int2string                ;Convert the score into a string

    LDR r0, ptr_to_score_str    ;Output the converted score to the board

	POP {r4-r8, r10-r11, lr}
	MOV pc, lr

	.end
