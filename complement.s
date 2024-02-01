	    AREA complement, CODE, READONLY		;Declare new area
		ENTRY 							;Declare as antry point
		ALIGN							;Ensures that __main addresses the following instruction
__main  FUNCTION						;Enable Debug
		EXPORT __main					;Make __main as global to access from startup file
		MOVS R0, var1					; move 21 -> R0 (i.e var1 -> R0)
		LDR R1, =0xFFFFFFFF				; Load R1 with full of ones. 
		EORS R0, R1,R0					;XOR R1 and R0, and keep the result in R0, Hence 1's complement of var1 will be kept in R0



stop	B    stop						;Branch stop


var1    EQU  2_10101					;Declaration of symbolic value

		ENDFUNC							;Finish function
		END								;Finish assembly file
		