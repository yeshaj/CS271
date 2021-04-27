TITLE Program05 (Proj5_jhalay.asm)

; Author: Yesha Jhala
; Description: This program displays the title and the authors name, describes to the
; user what the program is going to do, displays a prompt for the user to enter how
; many random numbers they want to generate, creates an array the length of the number
; that the user specified and fills it with random numbers that are within a specific
; range, displays the unsorted array, sorts the array and displays the sorted array,
; displays the median value, and says goodbye to the user.


INCLUDE Irvine32.inc


LO					EQU		10
HI					EQU		29
COUNTSIZE		EQU		20
ARRAYSIZE		EQU		200


.data
;messages to be printed to the screen
progTitle			BYTE	"Generating, Sorting, and Counting Random Integers!", 0
author				BYTE	"Programmed by Yesha Jhala", 0
instruct1			BYTE	"This program generates 200 random numbers in the range [10 ... 29], displays the ", 0
instruct2			BYTE	"original list, sorts the list, displays the median value, displays the list sorted in ", 0
instruct3			BYTE	"ascending order, then displays the number of instances of each generated value. ", 0
median				BYTE	"The median value of this array is ", 0
unsorted			BYTE	"Your unsorted random numbers: ", 0
sorted				BYTE	"Your sorted random numbers: ", 0
output				BYTE	"Your list of instances of each generated number, starting with the number of 10s: ", 0
conclusion		BYTE	"Goodbye, and thanks for using this program!", 0
array					DWORD	ARRAYSIZE	DUP(?)
countArray		DWORD	COUNTSIZE	DUP(0)

.code

main PROC

	call		Randomize
	; Introduce the program
	push		OFFSET progTitle
	push		OFFSET author
	call		introduction

	; Print the instructions
	push		OFFSET instruct1
	push		OFFSET instruct2
	push		OFFSET instruct3
	call		description

	; Fill array with 200 numbers between 10-29
	push		OFFSET array
	push		ARRAYSIZE
	push		LO
	push		HI
	call		fillArray

	; Display the unsorted list
	push		OFFSET array
	push		ARRAYSIZE
	push		OFFSET unsorted
	call		displayList

	push		OFFSET array
	push		ARRAYSIZE
	call		sortList

	; calculate median
	push		OFFSET array
	push		ARRAYSIZE
	push		OFFSET median
	call		displayMedian

	; Sort array in list
	push		OFFSET array
	push		ARRAYSIZE
	push		OFFSET sorted
	call		displayList

	; calculate how many times value shows up
	push		OFFSET array
	push		ARRAYSIZE
	push		OFFSET countArray
	push		COUNTSIZE
	push		LO
	call		countList

	; Sort 20 numbers in each line
	push		OFFSET countArray
	push		COUNTSIZE
	push		OFFSET output
	call		displayList

	; Say goodbye
	call		Crlf
	mov			edx, OFFSET conclusion
	call		WriteString
	call		Crlf

	exit
main ENDP


;------------------------------------------------------------------------
; Procedure: introduction
; Description: Introduce the program and author, and the instructions
; Receive: the address of parameters on system stack
; Return: none
; Registers changed: edx
;------------------------------------------------------------------------
introduction PROC
	push		ebp
	mov			ebp, esp
	mov			edx, [ebp+12]
	call		WriteString
	call		Crlf
	mov			edx, [ebp+8]
	call		WriteString
	call		Crlf
	call		Crlf
	pop			ebp
	ret			8
introduction ENDP

;------------------------------------------------------------------------
; Procedure: instruction
; Description: print out the instructions of what the program will do
; Receive: the address of parameters on system stack
; Return: none
; Registers changed: edx
;------------------------------------------------------------------------
instruction PROC
	push		ebp
	mov			ebp, esp
	mov			edx, [ebp+16]
	call		WriteString
	call		Crlf
	mov			edx, [ebp+12]
	call		WriteString
	call		Crlf
	mov			edx, [ebp+8]
	call		WriteString
	call		Crlf
	call		Crlf
	pop			ebp
	ret			12
instruction ENDP

;------------------------------------------------------------------------
; Procedure: fillArray
; Description: fill the array with 200 random integers as unsorted array
; Receive: array, LO and HI values, ARRAYSIZE
; Return: none
; Registers changed: eax, ecx, esi
;------------------------------------------------------------------------
fillArray PROC
	push		ebp
	mov			ebp, esp
	mov			esi, [ebp+20]
	mov			ecx, [ebp+16]

randArray:
	mov			eax, [ebp+8]
	sub			eax, [ebp+12]
	inc			eax
	call		RandomRange
	add			eax, [ebp+12]
	mov			[esi], eax
	add			esi, 4
	loop		randArray
	pop			ebp
	ret			16
fillArray ENDP

;------------------------------------------------------------------------
; Procedure: sortList
; Description: sort the array in ascending order (smallest value first)
; Receive: array and ARRAYSIZE
; Return: none
; Registers changed: eax, ebx, ecx
;------------------------------------------------------------------------
sortList PROC
	push		ebp
	mov			ebp, esp
	mov			ecx, [ebp+8]
	dec			ecx

outLoop:
	push		ecx
	mov			esi, [ebp+12]

inLoop:
	mov			eax, [esi]
	cmp			[esi+4], eax
	jg			nextElement

swap:
	mov			ebx, [esi+4]
	mov			[esi], ebx
	mov			[esi+4], eax

nextElement:
	add			esi, 4
	loop		inLoop
	pop			ecx
	loop		outLoop
	pop			ebp
	ret			8
sortList ENDP

;------------------------------------------------------------------------
; Procedure: displayMedian
; Description: calculate and display the median
; Receive: array, LO and HI, ARRAYSIZE
; Return: none
; Registers changed: eax, ebx, edx
;------------------------------------------------------------------------
displayMedian PROC
	push		ebp
	mov			ebp, esp
	mov			esi, [ebp+16]
	mov			eax, [ebp+12]
	mov			edx, 0
	mov			ebx, 2
	div			ebx
	cmp			edx, 0
	je			medianEven

; if odd number of values, will take beginning address with distance to the middle
medianOdd:
	mov			ebx, 4
	mul			ebx
	add			esi, eax
	mov			eax, [esi]
	jmp			printMedian

; if even, will divide the two values in the middle
medianEven:
	dec			eax
	mov			ebx, 4
	mul			ebx
	add			esi, eax
	mov			eax, [esi]
	mov			ebx, [esi+4]
	add			eax, ebx
	mov			ebx, 2
	mov			edx, 0
	div			ebx
	cmp			edx, 1
	jne			printMedian
	inc			eax

printMedian:
	mov			edx, OFFSET median
	call		WriteString
	call		WriteDec
	mov			eax, "."
	call		WriteChar
	call		Crlf

	pop			ebp
	ret			12
displayMedian ENDP

;------------------------------------------------------------------------
; Procedure: displayList
; Description: display the array
; Receive: title, array, ARRAYSIZE and COUNTSIZE
; Return: none
; Registers changed: eax, ebx, ecx, edx
;------------------------------------------------------------------------
displayList PROC
	push		ebp
	mov			ebp, esp
	mov			edx, [ebp+8]
	call		WriteString
	call		Crlf
	mov			esi, [ebp+16]
	mov			ecx, [ebp+12]
	mov			ebx, 0

printValue:
	mov			eax, [esi]
	call		WriteDec
	mov			eax, "  "
	call		WriteChar
	call		WriteChar
	add			esi, 4
	inc			ebx
	cmp			ebx, 20
	jne			nextValue
	call		Crlf
	mov			ebx, 0

nextValue:
	loop		printValue

	call		Crlf
	pop			ebp
	ret			12
displayList	ENDP

;------------------------------------------------------------------------
; Procedure: countList
; Description: after counting how many times each value appears in array, display
; Receive: array, ARRAYSIZE and COUNTSIZE, countArray, LO
; Return: none
; Registers changed: eax, ebx, ecx, edi, esi
;------------------------------------------------------------------------
countList PROC
	push		ebp
	mov			ebp, esp
	mov			ecx, [ebp+20]
	mov			esi, [ebp+24]
	mov			edi, [ebp+16]
	mov			ebx, [ebp+8]

check:
	mov			eax, [esi]
	cmp			ebx, eax
	jne			nextElement

countInst:
	mov			eax, [edi]
	inc			eax
	mov			[edi], eax
	jmp			continue

nextElement:
	inc			ebx
	add			edi, 4
	jmp			countInst

continue:
	add			esi, 4
	loop		check

	pop			ebp
	ret			20
countList ENDP

END main
