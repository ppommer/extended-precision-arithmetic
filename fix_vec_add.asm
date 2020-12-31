%ifndef era
%include "io.inc"
%endif
section .bss
    v1: resd 6
    v2: resd 6
    o: resd 6

section .data
global fix_vec_add_asm

%ifndef era
global main
%endif

section .text

;You can add stuff to main as well
%ifndef era
main:
    mov ebp, esp; for correct debugging
    ;set v1: 1.0
    mov dword [v1], 0x64000000;67108864 ; Nach
    mov dword [v1+4], 0 ; Vor
    mov dword [v1+8], 0x64000000;67108864
    mov dword [v1+12], 0
    mov dword [v1+16], 0x64000000;67108864
    mov dword [v1+20], 0
    ;set v2: -1.0
    mov dword [v2], 0x14000000;4227858432 ; Nach
    mov dword [v2+4], 0;4294967295 ; Vor
    mov dword [v2+8], 0x14000000;4227858432
    mov dword [v2+12], 0;4294967295
    mov dword [v2+16], 0x14000000;4227858432
    mov dword [v2+20], 0;4294967295
    push dword o
    push dword v2
    push dword v1
    call fix_vec_add_asm
    add esp, 12
    cmp dword [o], 0x78000000;0
    jne fail
    cmp dword [o+4], 0
    jne fail
    cmp dword [o+8], 0x78000000;0
    jne fail
    cmp dword [o+12], 0
    jne fail
    cmp dword [o+16],0x78000000;0
    jne fail
    cmp dword [o+20], 0
    jne fail
    PRINT_STRING "Success"
    ret
    fail:
    PRINT_STRING "Test failed"
    ret
%endif

;ASSIGNMENT START: fix_vec_add

fix_vec_add_asm:

    push ebp ; ebp sichern
    mov ebp, esp ; sp auf bp

    push eax ; eax sichern
    push ebx ; ebx sichern
    push ecx ; ecx sichern
    push edx ; edx sichern
    
    push esi
    
    mov ecx, 0 ; Counter initialisieren
    
    loop:
        mov esi, [ebp + 8] ; Adresse v1 in esi
        mov eax, [esi + ecx * 4] ; Nachkommateil v1 nach eax
        mov esi, [ebp + 12] ; Adresse v2 in esi
        mov edx, [esi + ecx * 4] ; Nachkommateil v2 nach edx
        
        add eax, edx ; Addition Nachkommateil
        
        mov esi, [ebp + 16] ; Adresse o in esi
        mov [esi + ecx * 4], eax  ; Ergebnis Nachkommateil o in Speicher
        
        inc ecx                 ; Counter erhöhen

        mov esi, [ebp + 8] ; Adresse v1 in esi
        mov edx, [esi + ecx * 4] ; Vorkommateil v1 nach edx
        mov esi, [ebp + 12] ; Adresse v2 in esi
        mov ebx, [esi + ecx * 4] ; Vorkommateil v2 nach ebx
        
        adc edx, ebx ; Addition Vorkommateil unter Beachtung des Carry-Bits
        
        mov esi, [ebp + 16] ; Adresse o in esi
        mov [esi + ecx * 4], edx ; Ergebnis Vorkommateil o in Speicher
        
        cmp ecx, 5 ; Abbruchbedingung
        je end
        inc ecx ; Counter erhöhen
        jmp loop
        
    end:  
        ; aufräumen
        pop esi 
        pop edx
        pop ecx
        pop ebx
        pop eax
        pop ebp

    ret

;ASSIGNMENT END: fix_vec_add

