TITLE Project1 Elementary Arithmetic (Proj1_jhalay.asm)

; Author: Yesha Jhala
; Description: The user will be prompted to enter three number (A,B,C) in descending order.
; The program will then calculate and display the sum and differences

INCLUDE Irvine32.inc

.data
intro           BYTE "Elementary Arithmetic by Yesha Jhala", 0
help            BYTE "Enter 3 numbers A > B > C, and I'll show you the sums and differences.", 0
firstNum        BYTE "First number: ", 0
secNum          BYTE "Second number: ", 0
thirdNum        BYTE "Third number: ", 0
num_A           SDWORD ?
num_B           SDWORD ?
num_C           SDWORD ?
add_AB          SDWORD ?
add_AC          SDWORD ?
add_BC          SDWORD ?
add_ABC         SDWORD ?
sub_AB          SDWORD ?
sub_AC          SDWORD ?
sub_BC          SDWORD ?
sub_CBA         SDWORD ?
add_print       BYTE " + ", 0
sub_print       BYTE " - ", 0
equal_print     BYTE " = ", 0
bye             BYTE "Thanks for using Elementary Arithmetic! Goodbye!", 0

.code
main PROC

  ; Introducing the program and author
  Introduction:
    mov     edx, OFFSET intro
    call    WriteString
    call    CrLf
    call    CrLf

  ; introduce the instructions for the program and ask for the first number
  First_Number:
    mov     edx, OFFSET help
    call    WriteString
    call    CrLf
    mov     edx, OFFSET firstNum
    call    WriteString
    call    ReadInt
    mov     num_A, eax

  ; ask for the second number, read the number given and move it to num_B
  Second_Number:
    mov     edx, OFFSET secNum
    call    WriteString
    call    ReadInt
    mov     num_B, eax

  ;  ask for the third number, read the number given and move it to num_C
  Third_Number:
    mov     edx, OFFSET thirdNum
    call    WriteString
    call    ReadInt
    mov     num_C, eax
    call    CrLf

  ; will add A + B with num_A replacing A and num_B replacing B
  A_add_B:
    mov     eax, num_A
    call    WriteDec
    mov     edx, OFFSET add_print
    call    WriteString
    mov     eax, num_B
    call    WriteDec
    mov     edx, OFFSET equal_print
    call    WriteString
    mov     eax, num_A
    add     eax, num_B
    mov     add_AB, eax
    call    WriteDec
    call    CrLf

    ; will add A + C with num_A replacing A and num_C replacing C
  A_add_C:
    mov     eax, num_A
    call    WriteDec
    mov     edx, OFFSET add_print
    call    WriteString
    mov     eax, num_C
    call    WriteDec
    mov     edx, OFFSET equal_print
    call    WriteString
    mov     eax, num_A
    add     eax, num_C
    mov     add_AC, eax
    call    WriteDec
    call    CrLf

    ; will add B + C with num_B replacing B and num_C replacing C
  B_add_C:
    mov     eax, num_B
    call    WriteDec
    mov     edx, OFFSET add_print
    call    WriteString
    mov     eax, num_C
    call    WriteDec
    mov     edx, OFFSET equal_print
    call    WriteString
    mov     eax, num_B
    add     eax, num_C
    mov     add_BC, eax
    call    WriteDec
    call    CrLf

    ; will add A + B with num_A replacing A, num_B replacing B and num_C replacing C
  A_add_B_add_C:
    mov     eax, num_A
    call    WriteDec
    mov     edx, OFFSET add_print
    call    WriteString
    mov     eax, num_B
    call    WriteDec
    mov     edx, OFFSET add_print
    call    WriteString
    mov     eax, num_C
    mov     WriteDec
    mov     edx, OFFSET equal_print
    call    WriteString
    mov     eax, num_A
    add     eax, num_B
    add     eax, num_C
    mov     add_ABC, eax
    call    WriteDec
    call    CrLf
    call    CrLf

    ; will subtract A - B with num_A replacing A and num_B replacing B
  A_sub_B:
    mov     eax, num_A
    call    WriteDec
    mov     edx, OFFSET sub_print
    call    WriteString
    mov     eax, num_B
    call    WriteDec
    mov     edx, OFFSET equal_print
    call    WriteString
    mov     eax, num_A
    sub     eax, num_B
    mov     sub_AB, eax
    call    WriteDec
    call    CrLf

    ; will subtract A - C with num_A replacing A and num_C replacing C
  A_sub_C:
    mov     eax, num_A
    call    WriteDec
    mov     edx, OFFSET sub_print
    call    WriteString
    mov     eax, num_C
    call    WriteDec
    mov     edx, OFFSET equal_print
    call    WriteString
    mov     eax, num_A
    sub     eax, num_C
    mov     sub_AC, eax
    call    WriteDec
    call    CrLf

    ; will subtract B - C with num_B replacing B and num_C replacing C
  B_sub_C:
    mov     eax, num_B
    call    WriteDec
    mov     edx, OFFSET sub_print
    call    WriteString
    mov     eax, num_C
    call    WriteDec
    mov     edx, OFFSET equal_print
    call    WriteString
    mov     eax, num_B
    sub     eax, num_C
    mov     sub_BC, eax
    call    WriteDec
    call    CrLf

  Goodbye:
    call    CrLf
    mov     edx, OFFSET bye
    call    WriteString
    call    CrLf


            exit
main ENDP

END main
