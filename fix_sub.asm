%ifndef era
%include "io.inc"
%endif

section .data
global fix_sub_asm

%ifndef era
global main
%endif

section .text

;You can add stuff to main as well
%ifndef era
main:
    push 37
    push 536870912
    push 55
    push 0
    call fix_sub_asm
    add esp, 16
    ;result in edx:eax
    PRINT_DEC 4, eax
    NEWLINE
    PRINT_DEC 4, edx
    NEWLINE
    ret
%endif

;ASSIGNMENT START: fix_sub_asm

fix_sub_asm:

    push ebp            ; ebp sichern
    mov ebp, esp        ; sp auf bp
    push ebx            ; ebx sichern
    
    mov eax, [ebp + 8]  ; Nachkommastelle Zahl 1 nach eax
    mov edx, [ebp + 16] ; Nachkommastelle Zahl 2 nach edx
    sub eax, edx        ; Subtraktion Nachkommastellen

    mov edx, [ebp + 12] ; Vorkommastelle Zahl 1 nach edx
    mov ebx, [ebp + 20] ; Vorkommastelle Zahl 2 nach ebx
    sbb edx, ebx        ; Subtraktion Vorkommastellen unter Beachtung des Carry-/Borrow-Bits
    
    pop ebx             ; ebx wiederherstellen
    pop ebp             ; ebp wiederherstellen
    
    ret

;ASSIGNMENT END: fix_sub_asm
