section .bss
    v1: resd 6
    v2: resd 6
section .data
global fix_vec_dot_asm
extern fix_mul_asm
extern fix_add_asm

section .text

fix_vec_dot_asm:

    push ebp ; ebp sichern
    mov ebp, esp ; sp auf bp

    ; Register sichern
    push ebx
    push ecx
    push esi
    push edi
    
    ; Adressen auslesen
    mov esi, [ebp + 8] ; Adresse v1 in esi
    mov edi, [ebp + 12] ; Adresse v2 in edi

    ; Stack für fix_mul_asm a1 * b1 vorbereiten
    mov eax, [esi + 4]
    push eax
    mov eax, [esi]
    push eax
    mov eax, [edi + 4]
    push eax
    mov eax, [edi]
    push eax
    
    ; a1 * b1
    call fix_mul_asm
    add esp, 16
    
    ; Werte für Addition sichern
    mov ebx, eax
    mov ecx, edx
    
    ; Stack für fix_mul_asm a2 * b2 vorbereiten
    mov eax, [esi + 12]
    push eax
    mov eax, [esi + 8]
    push eax
    mov eax, [edi + 12]
    push eax
    mov eax, [edi + 8]
    push eax
    
    ; a2 * b2
    call fix_mul_asm
    add esp, 16
    
    ; Stack für fix_add_asm a1 * b1 + a2 * b2 vorbereiten
    push ecx
    push ebx
    push edx
    push eax
    
    ; a1 * b1 + a2 * b2
    call fix_add_asm
    add esp, 16
    
    ; Werte für Addition sichern
    mov ebx, eax
    mov ecx, edx
    
    ; Stack für fix_mul_asm a3 * b3 vorbereiten
    mov eax, [esi + 20]
    push eax
    mov eax, [esi + 16]
    push eax
    mov eax, [edi + 20]
    push eax
    mov eax, [edi + 16]
    push eax
    
    ; a3 * b3
    call fix_mul_asm
    add esp, 16
    
    ; Stack für fix_add_asm (a1 * b1 + a2 * b2) + a3 * b3 vorbereiten
    push ecx
    push ebx
    push edx
    push eax
    
    ; (a1 * b1 + a2 * b2) + a3 * b3
    call fix_add_asm
    add esp, 16
    
    ; aufräumen
    pop edi
    pop esi
    pop ecx
    pop ebx
    
    pop ebp
    
    ret
