	    AREA power, CODE, READONLY		;Declare new area
		ENTRY 							;Declare as antry point
		ALIGN							;Ensures that __main addresses the following instruction						;Enable Debug
__main  FUNCTION						;Enable Debug
		EXPORT __main		
	MOVS R5, #var1	;; base ;; at the end the result will be kept in R5
	MOVS R6, #var2	;; exponent
	BL	POW
stopp B	stopp
	
POW 	MOVS R7, #var1
		CMP R5, #1
		BEQ	result1
		CMP R6, #0
		BGT cont
result1	MOVS R5,#1
		BX LR
cont	PUSH {LR}
		PUSH {R5}
		SUBS R6,R6,#1
		BL POW
		POP {R1}
		POP	{R2}
		MULS R5,R7,R5
		BX R2
		

var1    EQU  2                 ; Declaration of symbolic value
var2    EQU  6                  ; Declaration of symbolic value
	ENDFUNC	
    END                         ; Finish assembly file