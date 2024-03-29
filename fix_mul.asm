section .data
global fix_mul_asm
extern fix_add_asm

section .text

;[ebp + 12][ebp + 08] * [ebp + 20][ebp + 16]
;-------------------------------------------
;                       [--edx1--][--eax1--]
;          [--edx2--]   [--eax2--]
;          [--edx3--]   [--eax3--]
;[--edx4--][--eax4--]
;-------------------------------------------
;[--------][--edx---]   [--eax---][--ebx---]

fix_mul_asm:
    push ebp
    mov ebp, esp
    
    push ebx
    push ecx
    push esi
    
    ; prüfen, ob Zahlen negativ
    mov esi, 0 ; esi speichert Anzahl negativer Zahlen
    
    ; Zahl 1 überprüfen
    mov edx, [ebp + 12]
    mov eax, [ebp + 8]
    
    test edx, edx ; edx negativ?
    jns skip_1 ; falls nein, ueberspringe Umwandlung
    
    inc esi ; Anzahl negativer Zahlen: 1
    not edx ; edx invertieren
    not eax ; eax invertieren
    
    add eax, 1 ; eax + 1
    adc edx, 0 ; ggf. Carry-bit zu edx addieren
    
    mov [ebp + 12], edx ; edx zurückschreiben
    mov [ebp + 8], eax ; eax zurückschreiben
        
    skip_1:
        ; Zahl 2 überprüfen
        mov edx, [ebp + 20]
        mov eax, [ebp + 16]
    
        test edx, edx ; edx negativ?
        jns skip_2 ; falls nein, ueberspringe Umwandlung
    
        inc esi ; Anzahl negativer Zahlen: 2
        not edx ; edx invertieren
        not eax ; eax invertieren
    
        add eax, 1 ; eax + 1
        adc edx, 0 ; ggf. Carry-bit zu edx addieren
    
        mov [ebp + 20], edx ; edx zurückschreiben
        mov [ebp + 16], eax ; eax zurückschreiben
        
    skip_2:        
        ; [ebp + 08] * [ebp + 16]
        mov eax, [ebp + 8]
        mov ecx, [ebp + 16]
        mul ecx ; edx:eax = [ebp + 08] * [ebp + 16]
    
        mov ebx, eax ; eax1 sichern
    
        push dword 0 ; 0 auf Stack
        push edx ; edx1 auf Stack
    
        ; [ebp + 08] * [ebp + 20]
        mov eax, [ebp + 8]
        mov ecx, [ebp + 20]
        mul ecx ; edx:eax = [ebp + 08] * [ebp + 20]
    
        push edx ; edx2 auf Stack
        push eax ; eax2 auf Stack
    
        call fix_add_asm
        add esp, 16
    
        push edx ; 0 + edx2 auf Stack
        push eax ; edx1 + eax2 auf Stack
    
        ; [ebp + 12] * [ebp + 16]
        mov eax, [ebp + 12]
        mov ecx, [ebp + 16]
        mul ecx ; edx:eax = [ebp + 12] * [ebp + 16]

        push edx ; edx3 auf Stack
        push eax ; eax3 auf Stack
    
        call fix_add_asm
        add esp, 16
    
        push edx ; edx2 + edx3 auf Stack
        push eax ; edx1 + eax2 + eax3 auf Stack
    
        ; [ebp + 12] * [ebp + 20]
        mov eax, [ebp + 12]
        mov ecx, [ebp + 20]
        mul ecx ; edc:eax = [ebp + 12] * [ebp + 20]
    
        push eax ; eax4 auf Stack
        push dword 0
    
        call fix_add_asm
        add esp, 16
       
        ; Ergebnisraum um 6 bit nach links shiften
        
        ; 1: obere 6 bit aus eax in die unteren 6 bit in edx kopieren
        shl edx, 6 ; edx um 6 nach links shiften
        mov ecx, eax ; eax in Hilfsregister ecx kopieren
        shr ecx, 26 ; nur die obersten 6 bit behalten
        or edx, ecx ; untere 6 bit aus Hilfsregister ecx in Zielregister edx übertragen
        
        ; 2: obere 6 bit aus ebx in die unteren 6 bit in eax kopieren
        shl eax, 6 ; eax um 6 nach links shiften
        shr ebx, 26 ; nur die obersten 6 bit behalten
        or eax, ebx ; untere 6 bit aus Hilfsregister ecx in Zielregister eax übertragen
    
    
        ; falls eine der beiden Zahlen negativ war, Ergebnis invertieren
        cmp esi, 1
        jne skip_umwandlung
        
        not edx
        not eax
        
        add eax, 1
        adc edx, 0
        
        skip_umwandlung:
            ; aufräumen
            pop esi      
            pop ecx
            pop ebx
    
            pop ebp
    
            ret
