section .data
global fix_add_asm

section .text

fix_add_asm:

    push ebp ; ebp sichern
    mov ebp, esp ; sp auf bp
    
    push ebx ; ebx sichern
    
    mov eax, [ebp + 8] ; Nachkomma + 6-bit-Vorkomma Zahl 1 nach eax
    mov edx, [ebp + 16] ; Nachkomma + 6-bit-Vorkomma Zahl 2 nach edx
    add eax, edx ; Addition Nachkomma + 6-bit-Vorkomma

    mov edx, [ebp + 12] ; Vorkomma Zahl 1 nach edx
    mov ebx, [ebp + 20] ; Vorkomma Zahl 2 nach ebx
    adc edx, ebx ; Addition Vorkomma unter Beachtung des Carry-Bits
    
    pop ebx ; ebx wiederherstellen
    pop ebp ; ebp wiederherstellen
    
    ret
