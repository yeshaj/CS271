; (insert constant definitions here)

lowerLimit = 1
upperLimit = 200

.data
welcome             BYTE      "Prime Numbers Programmed by Yesha Jhala",0
programExit         BYTE      "Alright, that is it. Thanks for playing ",0
instructions        BYTE      "Enter the number between 1-200 of prime numbers you would like to see. ",0
error               BYTE      "No primes for you! Number out of range. Try again",0
space               BYTE      "   ",0
input               DWORD     ?
primeBool           BYTE      0
count               DWORD     ?
remainder           DWORD     ?
ecxHolder           DWORD     ?
eaxHolder           DWORD     ?


.code
main PROC
     call      introduction
     call      getUserData
     call      showPrimes
     call      farewell
	exit
main ENDP

;------------------------
; Introduce the program, the programmer, and print instructions
; Change edx register
;------------------------
introduction PROC
     mov       edx, OFFSET welcome
     call      WriteString
     call      CrLf
     ret
introduction ENDP

;------------------------
; Input number of primes to display
; Change edx into register
;------------------------
getUserData PROC
     mov       edx, OFFSET instructions
     call      WriteString
     call      ReadInt
     call      validate
     ret
getUserData ENDP

;------------------------
; validates that the user input is between 1 and 200 and is integer
; Change eax, edx into register
;------------------------
validate PROC
     .IF eax > upperLimit
     mov       edx, OFFSET error
     call      WriteString
     call      CrLf
     call      getUserData
     .ENDIF
     .IF eax < lowerLimit
     mov       edx, OFFSET error
     call      WriteString
     call      CrLf
     call      getUserData
     .ENDIF
     ret
validate ENDP

;------------------------
; print the primes and loop it around to constantly print
; Change eax, ebx, ecx, edx into register
;------------------------
showPrimes PROC
     mov       input, eax           ;Now that we are done validating, store the number we wanna get.
     mov       ecx, input           ;Set the beginning of the loop
     theLoop:
     .IF input == ecx
     mov       eax, 2                        ;Write the first prime number
     call      WriteDec
     mov       edx, OFFSET space
     call      WriteString
     dec       ecx                           ;remove 1 since we wrote the first prime number
     mov       eax, 1                        ;this is where we will start from
     .ENDIF
     Ploop:
     add       eax, 2
     mov       count, eax
     mov       ecxHolder, ecx
     call      isPrime
     cmp       primeBool, 1
     jne       Ploop
     call      WriteDec
     mov       edx, OFFSET space
     call      Writestring
     loop      theLoop
     call      CrLf
     ret
showPrimes ENDP

;------------------------
; determine if countprint is a prime number or not using boolean
; default for countprint will be false
; Change eax, ebx, edx into register
;------------------------
isPrime PROC
     mov       eaxHolder, eax
     mov       ecxHolder, ecx

     mov       ebx, eax
     cmp       ebx, 2
     je        PrimeNum
     cmp       ebx, 3
     je        PrimeNum

     mov       ecx, 2
     mov       edx, 0
     div       ecx
     mov       ecx, eax

     CheckLoop:
     mov       eax, ebx
     cmp       ecx, 1
     je        PrimeNum
     mov       edx, 0
     div       ecx
     cmp       edx, 0
     je        NotPrime
     loop      CheckLoop
     jmp       PrimeNum

     PrimeNum:
     mov       primeBool, 1
     mov       eax, eaxHolder
     mov       ecx, ecxHolder
     ret

     NotPrime:
     mov       primeBool, 0
     mov       eax, eaxHolder
     mov       ecx, ecxHolder
     ret
isPrime ENDP

;------------------------
; say goodbye
; Change edx into register
;------------------------
farewell PROC
     mov       edx, OFFSET programExit
     call      WriteString
     call      CrLf
     ret
farewell ENDP

END main
