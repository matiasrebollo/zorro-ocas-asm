%include "io.inc"
extern printf

global main

section .data
    matrix:
        db      "     A   B   C   D   E   F   G    ", 10
        db      " #################################", 10
        db      " ##########+-----------+##########", 10
        db      "1##########| O | O | O |##########", 10
        db      " ##########|---+---+---|##########", 10
        db      "2##########| O | O | O |##########", 10
        db      " ##+-------+---+---+---+-------+##", 10
        db      "3##| O | O | O | O | O | O | O |##", 10
        db      " ##|---+---+---+---+---+---+---|##", 10
        db      "4##| O |   |   |   |   |   | O |##", 10
        db      " ##|---+---+---+---+---+---+---|##", 10
        db      "5##| O |   |   | X |   |   | O |##", 10
        db      " ##+-------+---+---+---+-------+##", 10
        db      "6##########|   |   |   |##########", 10
        db      " ##########|---+---+---|##########", 10
        db      "7##########|   |   |   |##########", 10
        db      " ##########+-----------+##########", 10
        db      " #################################", 10,0

    msg_bienvenida:
        db "¡Bienvenido al juego El Zorro y las Ocas!", 10 
        db "Reglas básicas:", 10 
        db "El objetivo del juego es que el Zorro (X) capture al menos 12 ocas (O).", 10 
        db "Las ocas se mueven hacia adelante o hacia los lados, una casilla a la vez.", 10 
        db "El Zorro puede moverse en cualquier dirección una casilla a la vez (salvo que coma a una oca).", 10 
        db "Para comer una oca, el Zorro debe saltar sobre ella a una casilla vacía (puede hacer saltos multiples).", 10
        db "Es un movimiento por turno (comienza el zorro, luego las ocas) y solamente puede moverse una pieza por vez.", 10 
        db "El juego termina cuando el Zorro captura 12 ocas o queda acorralado.", 10 
        db "¡Que empiece la partida!", 10, 0

    zorro_pos           dd 402
    zorro_nueva_pos     dd 402
    zorro_sig_pos       dd 402
    zorro_acorralado    db 0 ;0 si al zorro le quedan movimientos validos, 1 si no.

    oca_pos             dd 0
    oca_nueva_pos       dd 0
    ocas_comidas        dd 0

    mov_x               dd 4
    mov_y               dd 70
    
    turno                       db 0 ; 0 si es el turno de MOVER zorro. 
                                     ; 1 si es el turno de ELEGIR la oca. 
                                     ; 2 si es el turno de MOVER la oca.

    error                       db 0 ; 0 si no hay error
                                     ; 1 error_movimiento
                                     ; 2 error_pared
                                     ; 3 error ocupada
                                     ; 4 error no_puede_comer
                                     ; 5 error_oca
    
    msg_turno_zorro             db "Elegí en qué dirección mover al zorro.                  ", 0
    msg_turno_oca               db "Elegí la oca a mover. Ingresá columna y fila            ", 0
    msg_movimientos_oca         db "Elegí en qué dirección mover a la oca.                  ", 0

    opciones_movimiento_zorro:
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "| 7 | 8 | 9 |                       TURNO: ZORRO                     |",10
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "| 4 |   | 6 |      Salir      |      Guardar      |      Cargar      |",10
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "| 1 | 2 | 3 |%s|",10
        db "+---+---+---+-----------------+-------------------+------------------+",10,0

    opciones_seleccion_oca:     
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "|   |   |   |                       TURNO: OCAS                      |",10
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "|   |   |   |      Salir      |      Guardar      |      Cargar      |",10
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "|   |   |   |%s|",10
        db "+---+---+---+-----------------+-------------------+------------------+",10,0

    opciones_movimiento_oca:     
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "|   |   |   |                       TURNO: OCAS                      |",10
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "| 4 |   | 6 |      Salir      |      Guardar      |      Cargar      |",10
        db "+---+---+---+-----------------+-------------------+------------------+",10
        db "|   | 2 |   |%s|",10
        db "+---+---+---+-----------------+-------------------+------------------+",10,0

    msg_error_movimiento        db "Por favor, elegí un movimiento valido.                  ", 0
    msg_error_pared             db "No podés moverte a una pared.                           ", 0
    msg_ocupada                 db "No podés moverte a una casilla ocupada.                 ", 0
    msg_no_puede_comer          db "No hay espacio para comer a esa oca.                    ", 0
    msg_error_oca               db "Inválido. Ingrese columna y fila sin espacios. Ej: C1   ", 0
    msg_gana_zorro              db "Gana zorro.",10,0
    msg_gana_ocas               db "Gana ocas.",10,0

section .bss
    input           resb 10

section .text

    main:
        mov rdi, msg_bienvenida ;printeamos bienvenida al juego
        mPuts

    game_loop:
        call imprimir

        cmp dword[ocas_comidas], 12 ; si ya comimos 12 ocas gana el zorro
        jge gana_zorro

        cmp byte[turno],0
        je turno_zorro

        cmp byte[turno],1
        je turno_oca

        cmp byte[turno],2
        je turno_mover_oca

        jmp game_loop

    gana_zorro:
        mov rdi, msg_gana_zorro ; se imprime que gano el zorro
        mPuts
        ret

    gana_ocas:
        mov rdi, msg_gana_ocas
        mPuts
        ret

    check_zorro:
        ; checkear si el zorro tiene movimientos 

        ;izquierda
        mov eax, [zorro_pos]
        sub eax, [mov_x]
        mov [zorro_nueva_pos], eax
        sub eax, [mov_x]
        mov [zorro_sig_pos], eax
        sub rsp, 8
        call validar_movimiento
        add rsp, 8
        cmp byte[zorro_acorralado], 0
        je game_loop
        
        
        ;izquierda arriba
        mov eax, [zorro_pos]
        sub eax, [mov_y] ; mueve fila hacia arriba
        sub eax, [mov_x]
        mov [zorro_nueva_pos], eax
        sub eax, [mov_y] 
        sub eax, [mov_x]
        mov [zorro_sig_pos], eax
        sub rsp, 8
        call validar_movimiento
        add rsp, 8
        cmp byte[zorro_acorralado], 0
        je game_loop
        
        
        ;arriba
        mov eax, [zorro_pos]
        sub eax, [mov_y]
        mov [zorro_nueva_pos], eax
        sub eax, [mov_y]
        mov [zorro_sig_pos], eax
        sub rsp, 8
        call validar_movimiento
        add rsp, 8
        cmp byte[zorro_acorralado], 0
        je game_loop
        

        ;arriba derecha
        mov eax, [zorro_pos]
        add eax, [mov_x]
        sub eax, [mov_y]
        mov [zorro_nueva_pos], eax
        add eax, [mov_x]
        sub eax, [mov_y]
        mov [zorro_sig_pos], eax
        sub rsp, 8
        call validar_movimiento
        add rsp, 8
        cmp byte[zorro_acorralado], 0
        je game_loop
        

        ;derecha
        mov eax, [zorro_pos]
        add eax, [mov_x]
        mov [zorro_nueva_pos], eax
        add eax, [mov_x]
        mov [zorro_sig_pos], eax
        sub rsp, 8
        call validar_movimiento
        add rsp, 8
        cmp byte[zorro_acorralado], 0
        je game_loop
        

        ;derecha abajo
        mov eax, [zorro_pos]
        add eax, [mov_x]
        add eax, [mov_y]
        mov [zorro_nueva_pos], eax
        add eax, [mov_x]
        add eax, [mov_y]
        mov [zorro_sig_pos], eax
        sub rsp, 8
        call validar_movimiento
        add rsp, 8
        cmp byte[zorro_acorralado], 0
        je game_loop
        

        ;abajo
        mov eax, [zorro_pos]
        add eax, [mov_y]
        mov [zorro_nueva_pos], eax
        add eax, [mov_y]
        mov [zorro_sig_pos], eax
        sub rsp, 8
        call validar_movimiento
        add rsp, 8
        cmp byte[zorro_acorralado], 0
        je game_loop
        

        ;abajo izquierda
        mov eax, [zorro_pos]
        sub eax, [mov_x]
        add eax, [mov_y]
        mov [zorro_nueva_pos], eax
        sub eax, [mov_x]
        add eax, [mov_y]
        mov [zorro_sig_pos], eax
        sub rsp, 8
        call validar_movimiento
        add rsp, 8
        cmp byte[zorro_acorralado], 0
        je game_loop
        
        jmp gana_ocas









    validar_movimiento:
        lea rdi, [matrix]
        add edi, [zorro_nueva_pos]
        mov al, byte[rdi]
        
        cmp al, ' '
        je validar_movimiento_true
        cmp al, '#'
        je validar_movimiento_false
        
        lea rdi, [matrix]
        add edi, [zorro_sig_pos]
        mov al, byte[rdi]
        cmp al, '#'
        je validar_movimiento_false
        cmp al, 'O'
        je validar_movimiento_false

        validar_movimiento_true:
            ret
        validar_movimiento_false:
            mov byte[zorro_acorralado],1
            ret




    imprimir: ;imprime el tablero
        mov rdi, matrix
        mPuts

        cmp byte[turno],0
        je imprimir_zorro
        cmp byte[turno],1
        je imprimir_oca_sel
        cmp byte[turno],2
        je imprimir_oca_mov

        imprimir_zorro:
            mov rdi, opciones_movimiento_zorro
            call seleccionar_mensaje
            call printf
            jmp fin_imprimir

        imprimir_oca_sel:
            mov rdi, opciones_seleccion_oca
            call seleccionar_mensaje
            call printf
            jmp fin_imprimir

        imprimir_oca_mov:
            mov rdi, opciones_movimiento_oca
            call seleccionar_mensaje
            call printf
            jmp fin_imprimir

        fin_imprimir:
        mov rdi, input
        mGets

        mov byte[error], 0

        ret


        seleccionar_mensaje:
            cmp byte[error],1
            je mensaje_movimiento
            cmp byte[error],2
            je mensaje_pared
            cmp byte[error],3
            je mensaje_ocupada
            cmp byte[error],4
            je mensaje_comer
            cmp byte[error],5
            je mensaje_oca_invalida
            cmp byte[turno],0
            je mensaje_zorro
            cmp byte[turno],1
            je mensaje_oca_sel
            cmp byte[turno],2
            je mensaje_oca_mov

            mensaje_movimiento:
                mov rsi, msg_error_movimiento
                ret
            mensaje_pared:
                mov rsi, msg_error_pared
                ret
            mensaje_ocupada:
                mov rsi, msg_ocupada
                ret
            mensaje_comer:
                mov rsi, msg_no_puede_comer
                ret
            mensaje_oca_invalida:
                mov rsi, msg_error_oca
                ret
            mensaje_zorro:
                mov rsi, msg_turno_zorro
                ret
            mensaje_oca_sel:
                mov rsi, msg_turno_oca
                ret
            mensaje_oca_mov:
                mov rsi, msg_movimientos_oca
                ret



    turno_zorro: ;turno del zorro

        ; leer la opcion de movimiento
        mov al, byte[input + 1]
        cmp al, 0 ; verifica que se haya mandado UN numero
        jne movimiento_invalido_zorro
        mov al, byte[input]
        ;determinar movimiento y saltar a la rutina adecuada
        cmp al, '1'
        je mover_zorro_izquierda_abajo
        cmp al, '2'
        je mover_zorro_abajo
        cmp al, '3'
        je mover_zorro_derecha_abajo
        cmp al, '4'
        je mover_zorro_izquierda
        cmp al, '6'
        je mover_zorro_derecha
        cmp al, '7'
        je mover_zorro_izquierda_arriba
        cmp al, '8'
        je mover_zorro_arriba
        cmp al, '9'
        je mover_zorro_derecha_arriba

        movimiento_invalido_zorro: ;si llegamos aca es porque el usuario no ingreso un movimiento valido
            mov byte[error], 1
            jmp game_loop

        mover_zorro_izquierda:
            mov eax, [zorro_pos]
            sub eax, [mov_x]
            mov [zorro_nueva_pos], eax ;movemos a izquierda
            sub eax, [mov_x]
            mov [zorro_sig_pos], eax ; nos guardamos la siguiente posicion
            jmp mover_zorro
            
        mover_zorro_izquierda_arriba:
            mov eax, [zorro_pos]
            sub eax, [mov_y] ; mueve fila hacia arriba
            sub eax, [mov_x]
            mov [zorro_nueva_pos], eax ;movemos izquierda arriba
            sub eax, [mov_y] 
            sub eax, [mov_x]
            mov [zorro_sig_pos], eax ; nos guardamos la siguiente posicion
            jmp mover_zorro
            
        mover_zorro_arriba:
            mov eax, [zorro_pos]
            sub eax, [mov_y]
            mov [zorro_nueva_pos], eax; movemos arriba
            sub eax, [mov_y]
            mov [zorro_sig_pos], eax ; nos guardamos la siguiente posicion
            jmp mover_zorro
            
        mover_zorro_derecha_arriba:
            mov eax, [zorro_pos]
            add eax, [mov_x]
            sub eax, [mov_y]
            mov [zorro_nueva_pos], eax ; movemos derecha arriba
            add eax, [mov_x]
            sub eax, [mov_y]
            mov [zorro_sig_pos], eax; nos guardamos la siguiente posicion
            jmp mover_zorro
            
        mover_zorro_derecha:
            mov eax, [zorro_pos]
            add eax, [mov_x]
            mov [zorro_nueva_pos], eax ; movemos derecha
            add eax, [mov_x]
            mov [zorro_sig_pos], eax ; nos guardamos la siguiente posicion
            jmp mover_zorro
            
        mover_zorro_derecha_abajo:
            mov eax, [zorro_pos]
            add eax, [mov_x]
            add eax, [mov_y]
            mov [zorro_nueva_pos], eax ; movemos derecha abajo
            add eax, [mov_x]
            add eax, [mov_y]
            mov [zorro_sig_pos], eax ; nos guardamos la siguiente posicion
            jmp mover_zorro
            
        mover_zorro_abajo:
            mov eax, [zorro_pos]
            add eax, [mov_y]
            mov [zorro_nueva_pos], eax ; movemos abajo
            add eax, [mov_y]
            mov [zorro_sig_pos], eax ; nos guardamos la siguiente posicion
            jmp mover_zorro
            
        mover_zorro_izquierda_abajo:
            mov eax, [zorro_pos]
            sub eax, [mov_x]
            add eax, [mov_y]
            mov [zorro_nueva_pos], eax ; movemos izquierda abajo
            sub eax, [mov_x]
            add eax, [mov_y]
            mov [zorro_sig_pos], eax ; nos guardamos la siguiente posicion
            jmp mover_zorro

        mover_zorro:
            lea rdi, [matrix]; nos paramos en la matriz
            add edi, [zorro_nueva_pos]; avanzamos
            mov al, byte[rdi]; nos guardamos lo que hay en esa posicion
            
            cmp al, '#'
            je error_pared_zorro ; si hay pared no se puede mover
            cmp al, 'O'
            je comer_oca ; si hay oca es un caso a ver

            mov byte[rdi], 'X' ;si no hay nada, movemos el zorro
            lea rdi, [matrix]
            add edi, [zorro_pos]
            mov byte[rdi], ' ' ; eliminamos nuestra antigua posicion
            mov ebx, [zorro_nueva_pos]
            mov [zorro_pos], ebx ;actualizamos la posicion del zorro

            jmp fin_turno_zorro

        error_pared_zorro:
            mov byte[error],2
            mov ebx, [zorro_pos]
            mov [zorro_nueva_pos], ebx; deshacemos el movimiento y vuelve a ser turno del zorro
            jmp game_loop
        
        comer_oca:
            lea rdi, [matrix]
            add edi, [zorro_sig_pos] ; vemos que hay atras de la oca
            mov al, byte[rdi]
            cmp al, '#'
            je no_puede_comer ; si hay pared no se puede comer
            cmp al, 'O'
            je no_puede_comer ; si hay oca no se puede comer

            mov byte[rdi], 'X' ;movemos al zorro
            lea rdi, [matrix]
            add edi, [zorro_nueva_pos]
            mov byte[rdi], ' ' ; eliminamos la oca
            lea rdi, [matrix]
            add edi, [zorro_pos]
            mov byte[rdi], ' ' ; eliminamos nuestra antigua posicion

            mov ebx, [zorro_sig_pos]
            mov [zorro_nueva_pos], ebx
            mov [zorro_pos], ebx ;actualizamos posicion del zorro

            inc dword[ocas_comidas] ; aumentamos en 1 las ocas comidas
            cmp dword[ocas_comidas],12 ; si ya son 12 termina el turno del zorro
            je  fin_turno_zorro

            jmp game_loop ;si no vuelve a ser turno del zorro

        no_puede_comer:
            mov byte[error], 4
            mov ebx, [zorro_pos]
            mov [zorro_nueva_pos], ebx
            mov [zorro_nueva_pos], ebx
            jmp game_loop

        fin_turno_zorro:
            mov byte[turno], 1
            jmp game_loop

    turno_oca:
        mov al, byte[input + 2]
        cmp al, 0 
        jne pos_invalida

        input_columna:
        mov al, byte[input] ;cargo columna
        mov ebx, 110
        cmp al, 'A'
        je input_fila
        cmp al, 'a'
        je input_fila
        mov ebx, 114
        cmp al, 'B'
        je input_fila
        cmp al, 'b'
        je input_fila
        mov ebx, 118
        cmp al, 'C'
        je input_fila
        cmp al, 'c'
        je input_fila
        mov ebx, 122
        cmp al, 'D'
        je input_fila
        cmp al, 'd'
        je input_fila
        mov ebx, 126
        cmp al, 'E'
        je input_fila
        cmp al, 'e'
        je input_fila
        mov ebx, 130
        cmp al, 'F'
        je input_fila
        cmp al, 'f'
        je input_fila
        mov ebx, 134
        cmp al, 'G'
        je input_fila
        cmp al, 'g'
        je input_fila

        jmp pos_invalida ; si no se selecciono ninguna de las anteriores es invalido

        input_fila:
        mov al, byte[input + 1] ;cargo fila
        cmp al, '1'
        je pos_valida
        add ebx, [mov_y]
        cmp al, '2'
        je pos_valida
        add ebx, [mov_y]
        cmp al, '3'
        je pos_valida
        add ebx, [mov_y]
        cmp al, '4'
        je pos_valida
        add ebx, [mov_y]
        cmp al, '5'
        je pos_valida
        add ebx, [mov_y]
        cmp al, '6'
        je pos_valida
        add ebx, [mov_y]
        cmp al, '7'
        je pos_valida

        pos_invalida: ; no se selecciono algo valido y vuelve a ser turno de la oca
        mov byte[error], 5
        jmp game_loop

        pos_valida:
        mov [oca_pos], ebx

        lea rdi, [matrix]
        add edi, [oca_pos]
        mov al, byte[rdi]
        cmp al, 'O'
        jne pos_invalida

        mov byte[turno], 2
        jmp game_loop

    turno_mover_oca:    
        mov al, byte[input + 1]
        cmp al, 0 
        jne mov_invalido_oca
        mov al, byte[input]
        cmp al, '2'
        je mover_oca_abajo
        cmp al, '4'
        je mover_oca_izquierda
        cmp al, '6'
        je mover_oca_derecha

        mov_invalido_oca: ; si se llega aca el movimiento escrito es invalido
        mov byte[error], 1
        jmp game_loop

        mover_oca_abajo:
            mov eax, [oca_pos]
            add eax, [mov_y]
            mov [oca_nueva_pos], eax ; nos guardamos la nueva posicion de la oca 
            jmp mover_oca

        mover_oca_izquierda:
            mov eax, [oca_pos]
            sub eax, [mov_x]
            mov [oca_nueva_pos], eax ; nos guardamos la nueva posicion de la oca
            jmp mover_oca
        
        mover_oca_derecha:
            mov eax, [oca_pos]
            add eax, [mov_x]
            mov [oca_nueva_pos], eax ; nos guardamos la nueva posicion de la oca
            jmp mover_oca

        mover_oca:
            lea rdi, [matrix]
            add edi, [oca_nueva_pos]
            mov al, byte[rdi] ; nos fijamos que hay en esa nueva posicion

            cmp al, '#' ; si hay una pared no se puede
            je error_pared_oca
            cmp al, 'O' ; si hay otra oca esta ocupada
            je casilla_ocupada
            cmp al, 'X' ; si esta el zorro esta ocupada
            je casilla_ocupada

            lea rdi, [matrix]
            add edi, [oca_pos]
            mov byte[rdi], ' ' ; borramos la posicion antigua de la oca
            lea rdi, [matrix]
            add edi, [oca_nueva_pos]
            mov byte[rdi], 'O' ; colocamos la oca en su nueva posicion

            jmp fin_turno_mover_oca

        error_pared_oca:
            mov byte[error], 2
            mov byte[turno], 1
            jmp game_loop
        casilla_ocupada:
            mov byte[error], 3
            mov byte[turno], 1
            jmp game_loop

        fin_turno_mover_oca:
        mov byte[turno], 0
        jmp game_loop






;   TODO
;   poder cerrar el juego en cualquier momento, en cada gets habría que checkar si input es igual a quit
;   después de elegir la oca debería poder volver atrás y elegir otra
