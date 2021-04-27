TITLE Program3   (Proj3_jhalay.asm)

; Author: Yesha Jhala
; Description: This program will have the user enter numbers between
; [-200, -100] or [-50, -1] (inclusive) until a positive number is entered
; The program will then calculute the total sum, max valid number, min valid
; number, and their rounded average.

INCLUDE Irvine32.inc

VAL01= -200
VAL02= -50
VAL03= -100
VAL04= -1

.data

; introductionduction, ask the user's name and get the user's name, then say hello
introduction    BYTE    "Welcome to the Integer Accumulator by Yesha Jhala", 0
name            BYTE    "What is your name? ", 0
username        BYTE    256 DUP(0)
hello           BYTE    "Hello there, ", 0
farewell		    BYTE    "We have to stop meeting like this. Farewell, ", 0

instruct1       BYTE    "Please enter numbers between [-200, -100] or [-50, -1].", 0
instruct2       BYTE    "Enter a non-negative number when you are finished to see results.", 0

many_num	      BYTE	  "The number of valid numbers you entered: ", 0
maximum_num	    BYTE	  "The maximum valid number is ", 0
minimum_num	    BYTE	  "The minimum valid number is ", 0
sum_num	        BYTE	  "The sum of your valid numbers is ", 0
avg_num	        BYTE	  "The rounded average is ", 0

prompt	        BYTE	  "Enter number: ", 0
prompt2	        BYTE	  "You got the number: ", 0
error	          BYTE    "Number Invalid!", 0
invalid	        BYTE    "No valid numbers entered", 0
userint	        SDWORD	?

count		        SDWORD	0
sum		          SDWORD	0
minimum			    SDWORD	0
maximum			    SDWORD	-201
avg			        SDWORD	0
remainder	      SDWORD	0
val			        SDWORD	0


.code
main PROC

; display the introduction of the title and author of the program
    mov      edx, OFFSET introduction
    call     WriteString
    call     CrLf
    call     CrLf

; ask for the user's name and store the name
    mov      edx, OFFSET name
    call     WriteString
    mov      edx, OFFSET username
    mov      ecx, 32
    call     ReadString

; greet the user and list the instructions
    mov      edx, OFFSET hello
    call     WriteString

    mov      edx, OFFSET username
    call     WriteString
    call     CrLf

    mov      edx, OFFSET instruct1
    call     WriteString
    call     CrLf

    mov     edx, OFFSET instruct2
    call    WriteString
    call    CrLf
    call    CrLf


again:
    mov     edx, OFFSET prompt
    call    WriteString
    call    ReadInt
    mov     userint, eax

; Check whether the number is between the ranges

    mov     eax, VAL01
    cmp     eax, userint
    jg      range
    mov     eax, userint
    cmp     eax, VAL03
    jg      range
    jmp     increment

; Check again if the numbers are between the other two ranges
range:
    mov		  eax, VAL02
	  cmp		  eax, userint
	  jg		  not_range
	  mov		  eax, userint
	  cmp		  eax, VAL04
	  jg		  not_range
	  jmp		  increment

; This will create an error because it is not between the range numbers
not_range:
    mov     eax, userint
    test    eax, eax
    jns     get_avg
    mov     edx, OFFSET error
    call    WriteString
    call    CrLf
    jmp     again

; count the sum
increment:
    inc     count
    mov     ebx, userint
    add     sum, ebx

; check the maximum
maximum_check:
    mov     edx, userint
    cmp     edx, maximum
    jle     minimum_check
    mov     ebx, userint
    mov     maximum, ebx

; check the minimum
minimum_check:
    mov     edx, userint
    cmp     edx, minimum
    jge     repeats
    mov     ebx, userint
    mov     minimum, ebx

repeats:
    jmp     again

; get the average from all the numbers put in by the user
get_avg:
    mov     ebx, 0
	  cmp		  ebx, count
	  je		  display
	  mov		  eax, sum
	  cdq

	  mov		  ebx, count
	  idiv	  ebx
	  mov		  avg, eax
	  mov		  remainder, edx
	  neg		  remainder
	  mov		  ebx, 2
	  imul	  ebx, remainder

	  mov		  val, ebx
	  cmp		  ebx, count
	  jle		  display
	  dec     avg

; display the entries submitted, the sum, max, minimum, average
display:
    mov     ebx, 0
	  cmp		  ebx, count
	  jne		  display2
	  call	  CrLf
	  mov		  edx, OFFSET invalid
	  call	  WriteString
	  jmp		  bye

display2:

  	call    CrLf
  	mov		  edx, OFFSET many_num
  	call	  WriteString
  	mov		  eax, count
  	call	  WriteDec

  	call	  CrLf
  	mov		  edx, OFFSET	maximum_num
  	call	  WriteString
  	mov		  eax, maximum
  	call	  WriteInt

  	call	  CrLf
  	mov		  edx, OFFSET	minimum_num
  	call	  WriteString
  	mov		  eax, minimum
  	call	  WriteInt

  	call	  CrLf
  	mov		  edx, OFFSET	sum_num
  	call	  WriteString
  	mov		  eax, sum
  	call	  WriteInt

  	call	  CrLf
  	mov		  edx, OFFSET	avg_num
  	call	  WriteString
  	mov		  eax, avg
  	call 	  WriteInt

; say farewell to the user and end the program
bye:
    call	  CrLf
  	mov		  edx, OFFSET	farewell
  	call	  WriteString

  	mov		  edx, OFFSET	username
  	call	  WriteString
  	call	  CrLf

    exit

main ENDP

END main
