section .bss
    v1: resd 6
    v2: resd 6
    o: resd 6
section .data
global fix_vec_cross_asm
extern fix_mul_asm
extern fix_sub_asm

section .text

fix_vec_cross_asm:
    
    push ebp ; ebp sichern
    mov ebp, esp ; sp auf bp

    ; Register sichern
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Adressen auslesen
    mov esi, [ebp + 8] ; Adresse v1 in esi
    mov edi, [ebp + 12] ; Adresse v2 in edi
    
    
    ;;;;;;;;;; 1: a2b3-a3b2 ;;;;;;;;;; 
    ; Stack für fix_mul_asm a2 * b3 vorbereiten
    mov eax, [esi + 12]
    push eax
    mov eax, [esi + 8]
    push eax
    mov eax, [edi + 20]
    push eax
    mov eax, [edi + 16]
    push eax
    
    ; a2 * b3
    call fix_mul_asm
    add esp, 16
    
    ; Werte für Subtraktion sichern
    mov ebx, eax
    mov ecx, edx
    
    ; Stack für fix_mul_asm a3 * b2 vorbereiten
    mov eax, [esi + 20]
    push eax
    mov eax, [esi + 16]
    push eax
    mov eax, [edi + 12]
    push eax
    mov eax, [edi + 8]
    push eax
    
    ; a3 * b2
    call fix_mul_asm
    add esp, 16
    
    ; Stack für fix_sub_asm a2 * b3 - a3 * b2 vorbereiten
    push edx
    push eax
    push ecx
    push ebx
    
    ; a2 * b3 - a3 * b2
    call fix_sub_asm
    add esp, 16
    
    ; Wert a2b3-a3b2 sichern
    mov ebx, [ebp + 16] ; Adresse o in ebx
    mov [ebx], eax
    mov [ebx + 4], edx
    
    
    ;;;;;;;;;; 2: a3b1-a1b3 ;;;;;;;;;; 
    ; Stack für fix_mul_asm a3 * b1 vorbereiten
    mov eax, [esi + 20]
    push eax
    mov eax, [esi + 16]
    push eax
    mov eax, [edi + 4]
    push eax
    mov eax, [edi]
    push eax
    
    ; a3 * b1
    call fix_mul_asm
    add esp, 16
    
    ; Werte für Subtraktion sichern
    mov ebx, eax
    mov ecx, edx
    
    ; Stack für fix_mul_asm a1 * b3 vorbereiten
    mov eax, [esi + 4]
    push eax
    mov eax, [esi]
    push eax
    mov eax, [edi + 20]
    push eax
    mov eax, [edi + 16]
    push eax
    
    ; a1 * b3
    call fix_mul_asm
    add esp, 16
    
    ; Stack für fix_sub_asm a3 * b1 - a1 * b3 vorbereiten
    push edx
    push eax
    push ecx
    push ebx
    
    ; a3 * b1 - a1 * b3
    call fix_sub_asm
    add esp, 16
    
    ; Wert a3b1-a1b3 sichern
    mov ebx, [ebp + 16] ; Adresse o in ebx
    mov [ebx + 8], eax
    mov [ebx + 12], edx
    
    ;;;;;;;;;; 3: a1b2-a2b1 ;;;;;;;;;;
    ; Stack für fix_mul_asm a1 * b2 vorbereiten
    mov eax, [esi + 4]
    push eax
    mov eax, [esi]
    push eax
    mov eax, [edi + 12]
    push eax
    mov eax, [edi + 8]
    push eax
    
    ; a1 * b2
    call fix_mul_asm
    add esp, 16
    
    ; Werte für Subtraktion sichern
    mov ebx, eax
    mov ecx, edx
    
    ; Stack für fix_mul_asm a2 * b1 vorbereiten
    mov eax, [esi + 12]
    push eax
    mov eax, [esi + 8]
    push eax
    mov eax, [edi + 4]
    push eax
    mov eax, [edi]
    push eax
    
    ; a2 * b1
    call fix_mul_asm
    add esp, 16
    
    ; Stack für fix_sub_asm a1 * b2 - a2 * b1 vorbereiten
    push edx
    push eax
    push ecx
    push ebx
    
    ; a1 * b2 - a2 * b1
    call fix_sub_asm
    add esp, 16
    
    ; Wert a1b2-a2b1 sichern
    mov ebx, [ebp + 16] ; Adresse o in ebx
    mov [ebx + 16], eax
    mov [ebx + 20], edx
    
    ; aufräumen
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    pop ebp

    ret
