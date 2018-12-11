;Предварительные настройки
Movlw 0000b
tris 6
movlw 11011111b 
option 
nop
;Тут тело цикла
lblLoop:
bsf 6,0
bcf 6,1
bcf 6,2
btfss 6,3
goto lblloop2
bcf 6,0
bsf 6,1
bcf 6,2
btfss 6,3
goto lblloop2
bcf 6,0
bcf 6,1
bsf 6,2
btfss 6,3
goto lblloop2
goto lblloop
lblloop2:
btfss  6,3
goto lblloop2
goto lblloop
