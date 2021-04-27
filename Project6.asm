TITLE Program6    (Proj6_jhalay.asm)

; Author: Yesha Jhala
; Description: Get 10 valid signed integers from the user and display
; the integers, sum and average

INCLUDE Irvine32.inc

MAX_NUM_INPUTS = 10
SIGN = 45

; Macro that prints a string to the console
mDisplayString MACRO displayBuffer
	push edx
	mov edx, displayBuffer
	call WriteString
	pop edx
ENDM

; Read string of specified length and store result to the specified memory location
mGetString MACRO stringBuffer, stringLength
	pushad
	mov ecx, 32
	mov edx, stringBuffer
	call readString
	mov esi, stringLength
	mov [esi], eax
	popad
ENDM

;messages to be printed to the screen
.data
intro			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
introName		BYTE	"Written by: Yesha Jhala", 0
instruct1		BYTE	"Please provide 10 signed decimal integers.", 0
instruct2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruct3		BYTE	"After you have finished inputting the raw numbers I will display a list ", 0
instruct4		BYTE	"of the integers, their sum, and their average value.", 0
prompt			BYTE	" Please enter a signed number: ", 0
results			BYTE	"You entered the following numbers: ", 0
avgPrompt		BYTE	"The rounded average is: ", 0
sumPrompt		BYTE	"The sum of these numbers is: ", 0
inputError		BYTE	"ERROR: You did not enter a signed number or your number was too big.", 0
goodbye			BYTE	"Thanks for Playing! ", 0
extraCredit		BYTE	"**EC 1: Display the line numbers and keep a running total of user numbers.", 0
comma			BYTE	", ", 0
runningPrompt	BYTE	" Running Total: ", 0

arrayData		SDWORD	10 DUP(?)
sum				SDWORD	?
average			SDWORD	?


.code
main PROC
	call introduction

	push offset arrayData
	push 10
	call enterArrayNums

	push offset arrayData
	push 10
	call showList

	push offset arrayData
	push 10
	call calculateSumAvg

	call goodbyeMsg

	exit

main ENDP

;------------------------------------------------------------------------
; Procedure: introduction
; Description: Introduce the program and author, and the instructions
; Receive: intro, introName, instruct1 - instruct4, and extracredit
;------------------------------------------------------------------------
introduction PROC
	mDisplayString offset intro
	call CrLf
	mDisplayString offset introName
	call CrLf
	mDisplayString offset instruct1
	call CrLf
	mDisplayString offset instruct2
	call CrLf
	mDisplayString offset instruct3
	call CrLf
	mDisplayString offset instruct4
	call CrLf
	mDisplayString offset extraCredit
	call CrLF
	ret
introduction ENDP

;------------------------------------------------------------------------
; Procedure: readVal
; Description: Receive the input and check to make sure there are no errors
; Receive: the multiple addresses
;------------------------------------------------------------------------
readVal PROC
	push ebp
	mov	ebp, esp
	pushad
	sub	esp, 36

	lea	edi, [ebp - 36]
	lea	esi, [ebp - 68]

	; ask user for the string and store it
	mDisplayString offset prompt
	mGetString esi, edi

	mov	ecx, [edi]
	mov	edx, esi
	add	esi, ecx
	dec	esi

	; if the first character is the minus sign then decrement ecx, otehrwise jump to positiveNumber
	mov	al, [edx]
	cmp	al, SIGN
	jne	positiveNumber
	dec	ecx

positiveNumber:
	mov	ebx, 1
	mov	edi, 0
	push edx
	std

stringLoop:
	mov		eax, 0
	lodsb

	; validate that it is a character from A-Z, otherwise jump to error
	push	eax
	call	validate
	jnz		errorAlpha

	; convert ASCII to decimal	sub	al, 48
	mul	ebx
	cmp	edx, 0
	jnz	errorAlpha
	add	edi, eax
	jo	errorAlpha
	jc	errorAlpha

	; find multiples of 10 to increment
	mov	eax, ebx
	mov	ebx, 10
	mul	ebx
	jc errorAlpha
	mov	ebx, eax

	loop stringLoop
	pop	edx

	; find twos complement if negative
	mov	al, [edx]
	cmp	al, SIGN
	jne	positiveNumber2

	mov	eax, -1
	sub	eax, edi
	add	eax, 1
	jmp	negative

positiveNumber2:
	mov	eax, edi

negative:
	mov	esi, [ebp + 8]
	mov	[esi], eax
	test eax, 0
	jmp	endReadVal

errorAlpha:
	pop	edx

errors:

	mDisplayString offset inputError
	call CrLF

	; Clear ZF if integer isn't valid
	or eax, 1

endReadVal:
	lahf
	add	esp, 36
	sahf
	popad
	pop	ebp
	ret	4
readVal ENDP

;------------------------------------------------------------------------
; Procedure: validate
; Description: Validate the integer given from user to make sure doesn't exceed 32 bits
; Receive: user input
;------------------------------------------------------------------------
validate PROC
	push ebp
	mov	ebp, esp
	push eax
	mov	eax, [ebp + 8]

	; ASCII 57 = decimal 9, compare to make sure it's not more than 10 integers
	cmp	eax, 57
	jg	notValid
	cmp	eax, 48
	jl notValid
	test eax, 0
	jmp	endValidate

notValid:
	or eax, 1

endValidate:
	pop	eax
	pop	ebp
	ret	4
validate ENDP

;------------------------------------------------------------------------
; Procedure: writeVal
; Description: convert the number to the address of the number
; Receive: a string
;------------------------------------------------------------------------
writeVal PROC
	push ebp
	mov	ebp, esp
	sub	esp, 32
	pushad

	; find the sign using the left bit of the integer
	mov	eax, [ebp + 8]
	mov	ebx, 10000000h
	mov	edx, 0
	div	ebx

	; check if negative value or positive value
	mov	ebx, 0Fh
	push eax
	push ebx
	cmp	eax, ebx
	jne	positiveStr

	mov	ebx, [ebp + 8]
	mov	eax, 0FFFFFFFFh
	sub	eax, ebx
	add	eax, 1
	jmp	negativeNum

positiveStr:
	; use integer value
	mov	eax, [ebp + 8]

negativeNum:
	; save the 2s complement
	push eax
	mov	ecx, 0
	mov	ebx, 10

findSize:
	mov	edx, 0
	div	ebx
	inc	ecx
	cmp	eax, 0
	jg	findSize

	lea	edi, [ebp - 4]
	mov	ebx, 10
	std
	mov	eax, 0
	stosb
	pop	eax

writeLoop:
	; divide by 10 to get the rightmost input
	mov edx, 0
	div ebx

	; store after converting to ASCII
	add	edx, 48
	push eax
	mov	al, dl
	stosb
	pop	eax
	cmp	eax, 0
	jg	writeLoop
	pop	ebx
	pop	eax

	;add a negative sign to the string if the number is negative
	cmp	eax, ebx
	jne	positiveNum2
	mov	al, SIGN
	stosb
	inc	ecx

positiveNum2:
	;get the address of the beginning and display it
	lea	edi, [ebp - 4]
	sub	edi, ecx
	mDisplayString edi

	popad
	add		esp, 32
	pop		ebp
	ret		4
writeVal ENDP

;------------------------------------------------------------------------
; Procedure: enterArrayNum
; Description: Fill the array with numbers given by user and display total after each input
; Receive: array
;------------------------------------------------------------------------
enterArrayNums PROC
	push ebp
	mov	ebp, esp
	push eax
	push edi
	push ecx

	; keep the running total and line count
	mov	edi, [ebp + 12]
	mov	ecx, 1
	mov	eax, 0

fillArrayLoop:
	cmp	ecx, [ebp + 8]
	jg	endFillLoop

getValLoop:
	push ecx
	call writeVal

	push edi
	call readVal
	jnz	getValLoop
	inc	ecx
	add	eax, [edi]
	add	edi, 4

	mDisplayString offset runningPrompt
	push eax
	call WriteVal
	call CrLf
	jmp	fillArrayLoop

endFillLoop:
	pop	ecx
	pop	edi
	pop	eax

	pop	ebp
	ret	8
enterArrayNums ENDP

;------------------------------------------------------------------------
; Procedure: showList
; Description: to show the list to the user
; Receive: array address
;------------------------------------------------------------------------
showList PROC
	push ebp
	mov	ebp, esp
	push ecx
	push edi
	mov	ecx, [ebp + 8]
	mov	edi, [ebp + 12]

	call CrLf
	mDisplayString offset results
	call CrLf

displayLoop:
	 push [edi]
	 call WriteVal

	 ;no comma if at the end of last element
	 cmp ecx, 1
	 je	noComma

	 mDisplayString offset comma

noComma:
	 add edi, 4
	 loop displayLoop

	pop	edi
	pop	ecx

	pop	ebp
	ret	8
showList ENDP

;------------------------------------------------------------------------
; Procedure: finalSumAvg
; Description: calculate the sum and the average of the array of numbers inputted
; Receive: addresses
; Returns: sum and average
;------------------------------------------------------------------------
calculateSumAvg PROC
	push ebp
	mov	ebp, esp
	pushad

	mov	ecx, [ebp + 8]
	mov	edi, [ebp + 12]
	mov	eax, 0

sumLoop:
	 mov ebx, [edi]
	 add eax, ebx
	 add edi, 4
	 loop sumLoop

	 call CrLf
	 call CrLf
	 mDisplayString offset sumPrompt

	push eax
	call WriteVal
	call CrLf

	;calculate the average
	mov	ebx, [ebp + 8]
	cdq
	idiv ebx

	mDisplayString offset avgPrompt

	push eax
	call WriteVal
	call CrLf
	popad
	pop	ebp
	ret	8
calculateSumAvg ENDP

; say goodbye
goodbyeMsg PROC
	call CrLf
	mDisplayString offset goodbye
	call CrLf
	ret
goodbyeMsg ENDP

END main
