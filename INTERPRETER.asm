;**************************************************************
;*                                                            *
;*  Copyright (C) 2024 PyDOS8                                 *
;*                                                            *
;*  This program is free software: you can redistribute it    *
;*  and/or modify it under the terms of the GNU General       *
;*  Public License as published by the Free Software          *
;*  Foundation, either version 3 of the License, or           *
;*  0.0 any later version.                                    *
;*                                                            *
;*  This program is distributed in the hope that it will be   *
;*  useful, but WITHOUT ANY WARRANTY; without even the        *
;*  implied warranty of MERCHANTABILITY or FITNESS FOR A      *
;*  PARTICULAR PURPOSE.  See the GNU General Public License   *
;*  for more details.                                         *
;*                                                            *
;*  You should have received a copy of the GNU General        *
;*  Public License along with this program.  If not, see      *
;*  <http://www.gnu.org/licenses/>.                           *
;*                                                            *
;**************************************************************   

section .text
    global _start
    global _exit   
    global _SyntaxError
    global _Execute
    global _Add

section .data
    msg: db "BASIC > "
    msgLength: equ $ - msg
    UserInput: db dup (0)    ; INPUT
    INSTRUCTIONS: DB "PRINT", DB "EXIT", DB "ADD"
    SyntaxError: db "Syntax Error!"
    SyntaxErrorLength: equ $ - SyntaxError
    PRINTBuf: db dup (0) ;    Input for the PRINT command
    PRINT: db "Enter something to output > "
    PRINTLength: equ $ - PRINT
    AddFunctionNumber1Input: db "Enter a number > "
    AddFunctionNumber1InputLength: equ $ - AddFunctionNumber1Input
    AddFunctionNumber2Input: db "Enter another number > "
    AddFunctionNumber2InputLength: equ $ - AddFunctionNumberInput
_start:
    ; Include needed libraries
    EXTERN _printf
    EXTERN _scanf

    ; Output `msg` variable
    MOV ECX, msg
    MOV EDX, msgLength
    CALL _printf

    ;;;;;;;;;;;;;;;
    ;    PARSER   ;
    ;;;;;;;;;;;;;;;

    ; Get user input
    MOV ESI, [ECX]
    MOV ECX, UserInput
    MOV EDX, 12
    CALL _scanf

    ; Check if user input is valid syntax
    CMP [ECX], INSTRUCTIONS
    JE _Execute
    JNE _SyntaxError

_SyntaxError:
    EXTERN _printf
    MOV ECX, SyntaxError
    MOV EDX, SyntaxErrorLength
    CALL _printf

;;;;;;;;;;;;;;;;;;;;;
;    INTERPRETER    ;
;;;;;;;;;;;;;;;;;;;;;

_Execute:
    ; EXITING
    CMP [ECX], "EXIT"
    JE _EXIT

    ; PRINTING
    CMP [ECX], "PRINT"
    JE _PRINT

    ; Adding
    CMP [ECX], "ADD"
    JE _Add

_Add:
    ; Include needed libraries
    EXTERN _printf
    EXTERN _scanf

    ; Output `AddFunctionNum1Input`
    MOV ECX, AddFunctionNum1Input
    MOV EDX, AddFunctionNum1InputLength
    CALL _printf

    ; Output `AddFunctionNum2Input`
    MOV ECX, AddFunctionNum2Input
    MOV EDX, AddFunctionNum2Length
    CALL _printf

_PRINT:
    ; Import needed libraries
    EXTERN _scanf
    EXTERN _printf

    ; Output `PRINT` variable value
    MOV ECX, PRINT
    MOV EDX, PRINTLength
    CALL _printf

    ; Get input
    MOV ECX, PRINTBuf
    MOV EDX, 12
    CALL _scanf

    ; Output input
    MOV ESI, [ECX]
    MOV ECX, ESI
    MOV EDX, 12
    CALL _printf

_exit:
    MOV EAX, 1
    XOR EBX, EBX
    INT 0x80
