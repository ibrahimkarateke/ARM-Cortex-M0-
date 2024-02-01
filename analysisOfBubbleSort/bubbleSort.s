					AREA realArray, data, READONLY
					ALIGN
ArraySize			EQU 0x64						
ArrayStart						
Array	  			DCD 0xa603e9e1, 0xb38cf45a, 0xf5010841, 0x32477961, 0x10bc09c5, 0x5543db2b, 0xd09b0bf1, 0x2eef070e, 0xe8e0e237, 0xd6ad2467, 0xc65a478b, 0xbd7bbc07, 0xa853c4bb, 0xfe21ee08, 0xa48b2364, 0x40c09b9f, 0xa67aff4e, 0x86342d4a, 0xee64e1dc, 0x87cdcdcc, 0x2b911058, 0xb5214bbc, 0xff4ecdd7, 0x03da3f26, 0xc79b2267, 0x6a72a73a, 0xd0d8533d, 0x5a4af4a6, 0x5c661e05, 0xc80c1ae8, 0x2d7e4d5a, 0x84367925, 0x84712f8b, 0x2b823605, 0x17691e64, 0x0ea49cba, 0x1d4386fb, 0xb085bec8, 0x4cc0f704, 0x76a4eca9, 0x83625326, 0x95fa4598, 0xe82d995e, 0xc5fb78cb, 0xaf63720d, 0x0eb827b5, 0x0cc11686d, 0x18db54ac, 0x8fe9488c, 0x0e35cf1, 0xd80ec07d, 0xbdfcce51, 0x9ef8ef5c, 0x3a1382b2, 0x0e1480a2a, 0x0fe3aae2b, 0x2ef7727c, 0xda0121e1, 0x4b610a78, 0xd30f49c5, 0x1a3c2c63, 0x984990bc, 0xdb17118a, 0x7dae238f, 0x77aa1c96, 0xb7247800, 0xb117475f, 0xe6b2e711, 0x1fffc297, 0x144b449f, 0x6f08b591, 0x4e614a80, 0x204dd082, 0x163a93e0, 0x0eb8b565a, 0x005326831, 0xf0f94119, 0x0eb6e5842, 0xd9c3b040, 0x9a14c068, 0x38ccce54, 0x33e24bae, 0xc424c12b, 0x5d9b21ad, 0x355fb674, 0xb224f668, 0x296b3f6b, 0x59805a5f, 0x8568723b, 0xb9f49f9d, 0xf6831262, 0x78728bab, 0x10f12673, 0x984e7bee, 0x214f59a2, 0xfb088de7, 0x8b641c20, 0x72a0a379, 0x225fe86a, 0xd98a49f3 

ArrayEnd
					AREA timeArray, data, READWRITE
TimeArrayStart 
TimeArray  			SPACE 400
TimeArrayEnd
					AREA sortedArray, data, READWRITE
SortedArrayStart
SortedArray			SPACE 400
SortedArrayEnd
					AREA main, CODE, READONLY
					ENTRY
					THUMB
					EXPORT	__main
					ALIGN
SYS_CTRL	        EQU    	0xE000E010 
SYS_RELOAD     	 	EQU    	0xE000E014 
SYS_VAL         	EQU    	0xE000E018  
							;; Fcpu = 64 Mhz  and timer_interrupt_period = 16 ms
							;; period = (1+ reloadValue) / Fcpu
							;; (1 + reloadValue) = Fcpu * period
							;; (1 + reloadValue) = 64 * 1,000,000 * 16 * 0.001
							;; (1 + reloadValue) = 1,024,000
							;;  reloadValue = 1,023,999  ----> 0xF9FFF (in hexadecimal)
RELOAD				EQU		0xF9FFF
START				EQU		0x7;#0111  enabling all flags 
	
	
__main				FUNCTION
	

initTimer			LDR	r0, =SYS_CTRL		;; SysTick control and status register
					LDR r1, =SYS_RELOAD		;; SysTick reload value register
					LDR r2, =SYS_VAL		;; SysTick current value register
					MOVS r3, #3				;; arbitrary value
					STR r3, [r0]			;; storing this value in control and status register
					LDR r3, =RELOAD			;; loading reload value calculated via formula above
					STR r3, [r1]			;; saving the reload value in reload value register
					
					PUSH {r0-r2}			;; keeping SYS_CTRL, SYS_RELOAD, SYS_VAL in stack in order to not to lose them
					
					LDR r4, =TimeArray		;; r4 = address of the time array
					LDR r5, =ArraySize		;; r5 = size of the original array

					
					MOVS r7, #2				;; beginning of the outmost for i = 2 -- determines that how many elements from original array is going to be sorted

outmostFor			CMP r7, r5				;; checks whethet number of elements that is going to be sorted is greater than array size
					BGT endingProgram		;; if greater ends program, we reach the size of the whole array and all the elements are sorted
					
					LDR r1, [r2]			;; r1 = initial value in SYS_VAL register
					PUSH {r1, r2, r3, r4, r5} ;; saving registers
					BL bubbleSort			;; performing buble sort for firts n elements
					POP {r1, r2, r3, r4, r5} ;; poping back the registers which are related with interrupt
					LDR r3, [r2]			;;  r3 = end value in SYS_VAL register
					SUBS r1, r1, r3			;; 	r1 = r1 - r3 calculating how much time is consumed
					STR r1, [r4]			;; storing measured time in time array
					ADDS r4, r4, #4			;; increment for word in time array for the next measurement
					ADDS r7, r7, #1			;; incrementing number of elements that is going to be sorted
					B outmostFor			;; sorting again with the incremented number of elements 
					
endingProgram		POP {r0-r2}       		;; end of the program stop the SysTick timer and clear interrupt configuration
					LDR r3, =0x0			;; end of the program stop the SysTick timer and clear interrupt configuration
					STR r3, [r0]			;; end of the program stop the SysTick timer and clear interrupt configuration
					STR r3, [r1]			;; end of the program stop the SysTick timer and clear interrupt configuration
					STR r3, [r2]			;; end of the program stop the SysTick timer and clear interrupt configuration
					
					LDR r0, =SortedArray 	;; saving the address of sorted array in r0	
					LDR r1, =TimeArray		;; saving the address of time array in r1
	
stop				B stop					;; while(true)
					
bubbleSort			LDR r0, =Array			;; loading address of original array to r0
					LDR r1, =SortedArray	;; loading address of filled array (not sorted yet) to r1	
					MOVS r2, #0				;; filling loop i = 0
					
filling				CMP r2, r7  		 ;; r7=  current array size
					BEQ bubbleFirstBegin ;; if not equal to desired array size contine to fill SortedArray (now unsorted -- not sorted yet)	
					LDR r3, [r0]		 ;; load from original array
					STR r3, [r1]		 ;; store in the sorted array (now unsorted -- not sorted yet)	
					ADDS r2, r2, #1		 ;; traversing (filling loop i = i + 1)
					ADDS r0, r0, #4		 ;; increment cursor in original array (in address )
					ADDS r1, r1, #4		 ;; increment cursor in sorted array (now unsorted -- not sorted yet) (in address )	 
					B filling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; BEGINNING OF BUBBLE SORT FOR FILLED CURRENT ARRAY 
bubbleFirstBegin	MOVS r0, #0    			; i=0 as index value
					MOVS r3, r7				;; r3 holds the current array size
					LSLS r3, r3, #2 		;; adjusting sized multiplying by 4 for word
					SUBS r3,r3,#4     		;; size = size -1 
					LDR r2,=SortedArray		;; load starting address of current array that is going to be sorted
L1					CMP r0, r3				;; check if i < arraySize
					BGE endSort				;; if not finish loop
					MOVS r1, #0				;; j=1 as second index
					MOVS r4, r3				;; r4 = size - 1 
					SUBS r4, r4, r0			;; r4 = size - 1 - i  
L2					CMP r1, r4				;; inner loop -- check if  j < size - 1 - i 
					BGE EndL2				;; if not finish inner loop 
					LDR r5, [r2,r1]			;; load first value for compare
					ADDS r1, r1, #4			;; increment cursor
					LDR r6, [r2,r1]			;; load second value for compare
					CMP	r5, r6				;; comparison CHECK first value > second value
					BLS	L2					;; if not jump inner loop
					STR r5, [r2,r1]			;; if true
					SUBS r1, r1, #4			;;
					STR r6, [r2,r1]			;;
					ADDS r1, r1, #4			;; swaps first value with the second value in sortedArray
					B L2					;; go to inner loop
EndL2				ADDS r0, r0, #4			;; i = i+4 for word
					B L1					;; go to outer loop
						
endSort				BX	LR					;; exit from subroutine and contine to program 
					
					ENDP
					END