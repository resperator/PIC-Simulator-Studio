MOVLW 0
TRIS 6
BCF 6,0


loop:


BSF 6,0
call pause
BCF 6,0
call pause
BSF 6,0
call pause
BCF 6,0
call pause
BSF 6,0
call pause
BCF 6,0
call pause


BSF 6,0
call pause
call pause
call pause
BCF 6,0
call pause
BSF 6,0
call pause
call pause
call pause
BCF 6,0
call pause
BSF 6,0
call pause
call pause
call pause
call pause
BCF 6,0
call pause


BSF 6,0
call pause
BCF 6,0
call pause
BSF 6,0
call pause
BCF 6,0
call pause
BSF 6,0
call pause
BCF 6,0


call pause
call pause
call pause
call pause
call pause
call pause
call pause

goto loop


;delay = 500'000 machine cycles
Pause:   movlw       85
            movwf       10h
            movlw       138
            movwf       11h
            movlw       3
            movwf       12h
wr:       decfsz      10h, F
            goto        wr
            decfsz      11h, F
            goto        wr
            decfsz      12h, F
            goto        wr
            nop
            nop
RETLW 0