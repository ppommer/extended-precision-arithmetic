section .data
global fix_sub_asm

section .text

fix_sub_asm:

    push ebp ; ebp sichern
    mov ebp, esp ; sp auf bp
    push ebx ; ebx sichern
    
    mov eax, [ebp + 8] ; Nachkommastelle Zahl 1 nach eax
    mov edx, [ebp + 16] ; Nachkommastelle Zahl 2 nach edx
    sub eax, edx ; Subtraktion Nachkommastellen

    mov edx, [ebp + 12] ; Vorkommastelle Zahl 1 nach edx
    mov ebx, [ebp + 20] ; Vorkommastelle Zahl 2 nach ebx
    sbb edx, ebx ; Subtraktion Vorkommastellen unter Beachtung des Carry-/Borrow-Bits
    
    pop ebx ; ebx wiederherstellen
    pop ebp ; ebp wiederherstellen
    
    ret
