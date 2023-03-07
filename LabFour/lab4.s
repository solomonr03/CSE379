.text
	.global lab4
DIR:	.equ 0x400
DEN:	.equ 0x51C
DATA:	.equ 0x3FC
PUR:	.equ 0x510	
lab4:
	PUSH {lr}

          ; Your code is placed here

	POP {lr}
	MOV pc, lr

read_from_push_btn:
	PUSH {lr}

          ; Your code is placed here
	MOV r0, #0xE608
	MOV r0, #400F
	LDRB r1, [r0]
	ORR r1, r1 0x20
	STRB r1, [r0]

	MOV r0, #5000
	MOVT r0, #4000
	LDRB r1, [r0, #DIR]
	AND r1, r1 0xF7
	STRB r1, [r0, #DIR

	MOV r0, #5000
	MOVT r0, #4000
	LDRB r1, [r0, #DATA]
	AND r1, r1, 0xFF

	MOV r0, r1 

	POP {lr}
	MOV pc, lr

illuminate_RGB_LED:
	PUSH {lr}

          ; Your code is placed here

	POP {lr}
	MOV pc, lr


	.end
