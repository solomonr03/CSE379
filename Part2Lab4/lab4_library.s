	.text
	.global uart_init
	.global gpio_btn_and_LED_init
	.global keypad_init ; Downloaded from the course website
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global read_keypad

**************************************************************************************************
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
**************************************************************************************************

*********************************
* KEYPAD_INIT					;
* This subroutine initializes 	;
*	the daughter board keypad	;
*								;
* Authors:						;
*	Caroline Hart				;
*	Anthony Roberts				;
								;
* Register Usage:				;
*	R0	- stores an address		;
*	R1	- stores the contents	;
*		   of a memory register	;
keypad_init:					;
	PUSH {lr}					;
* Enable the clock for GPIO Port A and Port D
	LDR r1, SYSCTL				; Load base address of System Control
	LDRB r0, [r1,#RCGCGPIO]		; Load contents of RCGCGPIO register
	ORR r0, r0, #0x9			; Set bit 3 to enalbe and provide a clock to GPIO Port A & Port D
	STRB r0, [r1,#RCGCGPIO]		; Store modifed value of RCGCGPIO register back to memory
								;
* Set GPIO Port D, Pints 0-3 direction to Output
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODIR] 	; Load contents of GPIODIR register
	ORR r0, r0, #0xF			; Set bits 0-3 to set GPIO direction to Output
	STRB r0, [r1, #GPIODIR] 	; Store modifed value of GPIODIR register back to memory
								;
* Set GPIO Port A, Pints 2-5 direction to Input
	LDR r1, GPIO_PORT_A			; Load base address of GPIO Port A
	LDRB r0, [r1, #GPIODIR] 	; Load contents of GPIODIR register
	BIC r0, r0, #0x3C			; Clear bits 2-5 to set GPIO direction to input
	STRB r0, [r1, #GPIODIR] 	; Store modifed value of GPIODIR register back to memory
								;
* Enable GPIO Port D, Pins 0-3 as Digital
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #0xF			; Set bits 0-3 to set pins to digital
	STRB r0, [r1, #GPIODEN] 	; Store modifed value of GPIODEN register back to memory
								;
* Enable GPIO Port A, Pins 2-5 as Digital
	LDR r1, GPIO_PORT_A			; Load base address of GPIO Port A
	LDRB r0, [r1, #GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #0x3C			; Set bits 2-5 to set pins to digital
	STRB r0, [r1, #GPIODEN] 	; Store modifed value of GPIODEN register back to memory
								;
* Enable GPIO Port D, Pins 0-3  ;
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODATA] 	; Load contents of GPIODATA register
	ORR r0, r0, #0xF			; Set bits 0-3 to set pins to digital
	STRB r0, [r1, #GPIODATA] 	; Store modifed value of GPIODATA register back to memory
								;
	POP {pc}					; Return to caller
* END OF KEYPAD_INIT			;
*********************************

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
	MOV pc, lr


read_character:
	PUSH {lr} ; Store register lr on stack

	 ; Your code is placed here

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
	MOV pc, lr


read_string:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
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

FINN:	MOV r3, #0
		POP {r0, r1}
		STRB r3, [r0, r1]

	POP {lr}
	MOV pc, lr


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
	MOV pc, lr


read_from_push_btns:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here

	 MOV r0, #0x7000
	 MOVT r0, #0x4000
	 LDRB r1, [r0, #GPIODATA]
	 AND r1, r1, #0x0F
	 CMP r1, #0x00
	 BEQ ZERO
	 CMP r1, #0x08
	 BEQ TWO
	 CMP r1, #0x04
	 BEQ THREE
	 CMP r1, #0x02
	 BEQ FOUR
	 CMP r1, #0x01
	 BEQ FIVE
	 B ZERO

ZERO:	MOV r0, #0
		B END

TWO:	MOV r0, #2
		B END
THREE:	MOV r0, #3
		B END
FOUR:	MOV r0, #4
		B END
FIVE:	MOV r0, #5
		B END

END:	POP {lr}
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


read_tiva_push_button:
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
	CMP r1, #0x00
    BEQ ISP
    MOV r0, #0
    B END2

ISP:  MOV r0, #1

END2:    POP {lr}
	MOV pc, lr


read_keypad:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	LDR r1, GPIO_PORT_D ; Assign base address of Port D to r1
	LDR r2, GPIO_PORT_A ; Assign base address of Port A to r2

	; 1ST ROW
	LDRB r3, [r1, #GPIODATA] ; Load Port D Data Register from memory to r3
	MOV r5, #0x1 ; Assign r5 to 0x1 to respresent the 1st row exclusively
	BFI r3, r5, #0, #4 ; Insert r5 into first 4 bits of r3 to only turn on 1st row of keypad
	STRB r3, [r1, #GPIODATA] ; Store Port D Data register back to memory

	ADD r8, r8, #0
	ADD r8, r8, #0

	LDRB r4, [r2, #GPIODATA] ; Load Port A Data Register from memory to r4 (load columns)
	; 1st col
	TST r4, #0x4 ; Test if button in 1st col is pressed (pin 2)
	BEQ SONE ; Skip to next col if not pressed
	MOV r0, #1 ; 1 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

SONE:
	; 2nd col
	TST r4, #0x8 ; Test if button in 2nd col is pressed (pin 3)
	BEQ STWO ; Skip to next col if not pressed
	MOV r0, #2 ; 2 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

STWO:
	; 3rd col
	TST r4, #0x10 ; Test if button in 3rd col is pressed (pin 4)
	BEQ STHREE ; Skip to next col if not pressed
	MOV r0, #3 ; 3 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

STHREE:
	; 2ND ROW
	LDRB r3, [r1, #GPIODATA] ; Load Port D Data Register from memory to r3
	MOV r5, #0x2 ; Assign r5 to 0x2 to respresent the 2nd row exclusively
	BFI r3, r5, #0, #4 ; Insert r5 into first 4 bits of r3 to only turn on 2nd row of keypad
	STRB r3, [r1, #GPIODATA] ; Store Port D Data register back to memory

	ADD r8, r8, #0
	ADD r8, r8, #0

	LDRB r4, [r2, #GPIODATA] ; Load Port A Data Register from memory to r4 (load columns)
	; 1st col
	TST r4, #0x4 ; Test if button in 1st col is pressed (pin 2)
	BEQ SFOUR ; Skip to next col if not pressed
	MOV r0, #4 ; 4 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

SFOUR:
	; 2nd col
	TST r4, #0x8 ; Test if button in 2nd col is pressed (pin 3)
	BEQ SFIVE ; Skip to next col if not pressed
	MOV r0, #5 ; 5 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

SFIVE:
	; 3rd col
	TST r4, #0x10 ; Test if button in 3rd col is pressed (pin 4)
	BEQ SSIX ; Skip to next col if not pressed
	MOV r0, #6 ; 6 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

SSIX:
	; 3RD ROW
	LDRB r3, [r1, #GPIODATA] ; Load Port D Data Register from memory to r3
	MOV r5, #0x4 ; Assign r5 to 0x4 to respresent the 3rd row exclusively
	BFI r3, r5, #0, #4 ; Insert r5 into first 4 bits of r3 to only turn on 2nd row of keypad
	STRB r3, [r1, #GPIODATA] ; Store Port D Data register back to memory

	ADD r8, r8, #0
	ADD r8, r8, #0

	LDRB r4, [r2, #GPIODATA] ; Load Port A Data Register from memory to r4 (load columns)
	; 1st col
	TST r4, #0x4 ; Test if button in 1st col is pressed (pin 2)
	BEQ SSEV ; Skip to next col if not pressed
	MOV r0, #7 ; 7 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

SSEV:
	; 2nd col
	TST r4, #0x8 ; Test if button in 2nd col is pressed (pin 3)
	BEQ SEIGHT ; Skip to next col if not pressed
	MOV r0, #8 ; 8 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

SEIGHT:
	; 3rd col
	TST r4, #0x10 ; Test if button in 3rd col is pressed (pin 4)
	BEQ SNINE ; Skip to next col if not pressed
	MOV r0, #9 ; 9 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

SNINE:
	; 4TH ROW
	LDRB r3, [r1, #GPIODATA] ; Load Port D Data Register from memory to r3
	MOV r5, #0x8 ; Assign r5 to 0x8 to respresent the 4th row exclusively
	BFI r3, r5, #0, #4 ; Insert r5 into first 4 bits of r3 to only turn on 2nd row of keypad
	STRB r3, [r1, #GPIODATA] ; Store Port D Data register back to memory

	ADD r8, r8, #0
	ADD r8, r8, #0

	LDRB r4, [r2, #GPIODATA] ; Load Port A Data Register from memory to r4 (load columns)
	; 2nd col
	TST r4, #0x8 ; Test if button in 2nd col is pressed (pin 3)
	BEQ STEN ; Skip to next col if not pressed
	MOV r0, #0 ; 0 WAS PRESSED
	POP {lr}
	MOV pc, lr ; End subroutine

STEN:
	POP {lr}
	MOV pc, lr

.end
