	.data
	.text
	.global lab_2_test

lab_2_test:
	STMFD r13!, {r14} 	; Do NOT modify this line of code.  It ensures
    			      	; that the return address is preserved so that
 		              	; a proper return to the C wrapped can be
			      		; executed.

	; Your code to test your integer_digit routine goes here.
	; Use MOV & MOVT instructions to load the integer to test
	; in r0 and the position (n) in r1.  Then call integer_digit
	; using the BL integer_digit instruction.  The call is
	; shown below.
	MOV r0, #37192
	MOV r1, #3
	BL integer_digit

	; After the integer_digit routine has executed, you can
	; return to your C wrapper using the STMFD & MOV instructions
	; as shown below.  To test the values that were returned, set
  	; a breakpoint at this line to see the values integer_digit
	; returned in registers r0 and r1.

	LDMFD r13!, {r14}     ; Do NOT modify this line of code.  It ensures
    			      ; that the return address is preserved so that
 		              ; a proper return to the C wrapped can be
			      ; executed.
	MOV pc, lr

integer_digit:

	; Your code for the integer_digit routine goes here.

		MOV r2, #0	; Initialize counter
	
LOOP:	MOV r3, r0	; Store the value of r0 and
		CMP r2, r1	; check if it's in the position we want
		BEQ MOD		; If not branch to the increment
		B INC
	
MOD:	SUB r3, r3, #10	; Subtract 10 from the value in r3
		CMP r3, #0		; until we get the rightmost digit
		BGE MOD
		ADD r3, r3, #10
		B FOUND
	
INC:	ADD r2, r2, #1		; Increment the counter and
		MOV r3, #10			; shift the value in r0 to check the next digit
		UDIV r0, r0, r3		
		CMP r0, #0 			; If not we have found our value
		BNE LOOP			; store the counter and the nth number in r0 and r1

FOUND: 	ADD r2, r2, #1
		MOV r1, #10
		UDIV r0, r0, r1
		CMP r0, #0
		BNE FOUND


		MOV r0, r2
		MOV r1, r3

	; The following line is used to return from the subroutine 
	; and should be the last line in your subroutine.

		MOV pc, lr

	.end
