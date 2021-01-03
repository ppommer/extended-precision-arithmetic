section .bss
    v1: resd 6
    v2: resd 6
    o: resd 6

section .data
global fix_vec_sub_asm

section .text

fix_vec_sub_asm:

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
        
        sub eax, edx ; Subtraktion Nachkommateil
        
        mov esi, [ebp + 16] ; Adresse o in esi
        mov [esi + ecx * 4], eax ; Ergebnis Nachkommateil o in Speicher
        
        inc ecx ; Counter erhöhen

        mov esi, [ebp + 8] ; Adresse v1 in esi
        mov edx, [esi + ecx * 4] ; Vorkommateil v1 nach edx
        mov esi, [ebp + 12] ; Adresse v2 in esi
        mov ebx, [esi + ecx * 4] ; Vorkommateil v2 nach ebx
        
        sbb edx, ebx ; Subtraktion Vorkommateil unter Beachtung des Carry-Bits
        
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
