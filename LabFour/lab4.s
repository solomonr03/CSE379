.text
	.global lab4
DIR:	.equ 0x400
DEN:	.equ 0x51C
DATA:	.equ 0x3FC
PUR:	.equ 0x510	
lab4:
	PUSH {lr}

          ; Your code is placed here

    MOV r0, #0xE608
	MOVT r0, #0x400F
	LDRB r1, [r0]
	ORR r1, r1, #0x20
	STRB r1, [r0]

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #PUR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #PUR]

LOOP:
	BL read_from_push_btn
	CMP r0, #0x01
	BEQ LOOP

	MOV r0, #0x02 ; red
	BL illuminate_RGB_LED
	MOV r0, #0x04 ; blue
	BL illuminate_RGB_LED
	MOV r0, #0x08 ; green
	BL illuminate_RGB_LED
	MOV r0, #0x06 ; purple
	BL illuminate_RGB_LED
	MOV r0, #0x0A ; yellow
	BL illuminate_RGB_LED
	MOV r0, #0x0E ; white
	BL illuminate_RGB_LED



	POP {lr}
	MOV pc, lr

read_from_push_btn:
	PUSH {lr}

          ; Your code is placed here

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #DIR]
	AND r1, r1, #0xEF
	STRB r1, [r0, #DIR]

	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #DEN]
	ORR r1, r1, #0x10
	STRB r1, [r0, #DEN]


	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0, #DATA]
	AND r1, r1, #0x10
	CMP r1, #0x10
    BEQ NOTP
    MOV r0, #0
    B END

NOTP:  MOV r0, #1

END:    POP {lr}
        MOV pc, lr


illuminate_RGB_LED:
	PUSH {lr}

          ; Your code is placed here
           ; Enabling Port F Clock **Move to lab4 subroutine when combining Solomon's code
          ; MOV r1, #0xE608
          ; MOVT r1, #0x400F ; Assign effective address of Clock Control Register into r1
          ; LDRB r2, [r1] ; Load Clock Control Register from memory into r2
          ; ORR r2, r2, #0x20 ; Enable the Port F bit to 1
          ; STRB r2, [r1] ; Store Enabled Clock Control Register back to memory
          
          MOV r1, #0x5000
          MOVT r1, #0x4002 ; Assign base address of Port F to r1
          ; Setting pins 1 (red), 2 (blue), and 3 (green) of Port F to output
          LDRB r2, [r1, #DIR] ; Load Port F Direction Register from memory to r2
          ORR r2, r2, #0x0E ; Set pin 1, 2, and 3 to 1
          STRB r2, [r1, #DIR] ; Store Port F Direction Register back to memory
          
          ;Enabling pins 1 (red), 2 (blue), and 3 (green) of Port F to digital
          LDRB r2, [r1, #DEN] ; Load Port F Digitial Enable Register from memory to r2
          ORR r2, r2, #0x0E ; Set pin 1, 2, and 3 to 1
          STRB r2, [r1, #DEN] ; Store Port F Digital Enable Register back to memory
          
          ; Turn on LED Light (r0 = Red: 0b001; Blue: 0b010; Green: 0b100; Purple: 0b011; Yellow: 0b101; White: 0b111)
          LDRB r2, [r1, #DATA] ; Load Port F Data Register from memory to r2
          AND r2, r2, #0xF1 ; Reset all LED lights
          ORR r2, r2, r0 ; Turn on desited LED lights
          STRB r2, [r1, #DATA] ; Store Port F Data Register back to memory

	POP {lr}
	MOV pc, lr


	.end
