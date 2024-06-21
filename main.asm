%include "io.inc"

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

    title:
        db      "           ______  ____       _                   _____",10
        db      "          /\__  _\/\  _`\   /' \                 /\  __`\ ", 10
        db      "          \/_/\ \/\ \ \L\ \/\_, \                \ \ \/\ \  _ __    __      __",10
        db      "             \ \ \ \ \ ,__/\/_/\ \      _______   \ \ \ \ \/\`'__\/'_ `\  /'__`\ ",10
        db      "              \ \ \ \ \ \/    \ \ \    /\______\   \ \ \_\ \ \ \//\ \L\ \/\ \L\.\_",10
        db      "               \ \_\ \ \_\     \ \_\   \/______/    \ \_____\ \_\\ \____ \ \__/.\_\ ",10
        db      "                \/_/  \/_/      \/_/                 \/_____/\/_/ \/___L\ \/__/\/_/",10
        db      "                                                                    /\____/",10
        db      "                                                                    \_/__/",10
        db      " ______  _   ______                                    _                ____",10
        db      "|  ____|| | |___  /                                   | |              / __ \ ",10
        db      "| |__   | |    / /   ___   _ __  _ __   ___    _   _  | |  __ _  ___  | |  | |  ___   __ _  ___ ",10
        db      "|  __|  | |   / /   / _ \ | '__|| '__| / _ \  | | | | | | / _` |/ __| | |  | | / __| / _` |/ __|",10
        db      "| |____ | |  / /__ | (_) || |   | |   | (_) | | |_| | | || (_| |\__ \ | |__| || (__ | (_| |\__ \ ",10
        db      "|______||_| /_____| \___/ |_|   |_|    \___/   \__, | |_| \__,_||___/  \____/  \___| \__,_||___/",10
        db      "                                                __/ |",10
        db      "                                               |___/",10
        db      "",10
        db      "                                     ESCRIBE START PARA EMPEZAR",10,0

    msg_bienvenida:
        db "¡Bienvenido al juego El Zorro y las Ocas!", 10 
        db "Reglas básicas:", 10 
        db "El objetivo del juego es que el Zorro (X) capture al menos 12 ocas (O).", 10 
        db "Las ocas se mueven hacia adelante o hacia los lados, una casilla a la vez.", 10 
        db "El Zorro puede moverse en cualquier dirección una casilla a la vez (salvo que coma a una oca).", 10 
        db "Para comer una oca, el Zorro debe saltar sobre ella a una casilla vacía (puede hacer saltos multiples).", 10
        db "Es un movimiento por turno (comienza el zorro, luego las ocas) y solamente puede moverse una pieza por vez.", 10 
        db "El juego termina cuando el Zorro captura 12 ocas o queda acorralado.", 10 
        db "¡Que empiece la partida!", 10, 
        db "A continuacion se muestra el tablero:", 10, 0 

    tablero db "#", "#", "#", "#", "#", "#", "#", "#", "#",10
            db "#", "#", "#", "O", "O", "O", "#", "#", "#",10
            db "#", "#", "#", "O", "O", "O", "#", "#", "#",10
            db "#", "O", "O", "O", "O", "O", "O", "O", "#",10
            db "#", "O", " ", " ", " ", " ", " ", "O", "#",10
            db "#", "O", " ", " ", "X", " ", " ", "O", "#",10
            db "#", "#", "#", " ", " ", " ", "#", "#", "#",10
            db "#", "#", "#", " ", " ", " ", "#", "#", "#",10
            db "#", "#", "#", "#", "#", "#", "#", "#", "#",10,0

    zorro_pos           dd 402
    zorro_nueva_pos     dd 402
    zorro_sig_pos       dd 402

    oca_pos             dd 0
    oca_nueva_pos       dd 0

    mov_x               dd 4
    mov_y               dd 70

    ; contador_ocas_comidas db 0
    
    
    msg_turno_zorro:
        db "Turno del zorro. Elija una posicion donde moverse:", 10, 0
    opciones_movimiento_zorro   db "1) DIAGONAL IZQUIERDA ABAJO",10
                                db "2) ABAJO",10
                                db "3) DIAGONAL DERECHA ABAJO",10
                                db "4) IZQUIERDA",10
                                db "6) DERECHA",10
                                db "7) DIAGONAL IZQUIERDA ARRIBA",10
                                db "8) ARRIBA",10
                                db "9) DIAGONAL DERECHA ARRIBA",10,0
    
    msg_movimientos_oca         db "Elija una posicion donde moverse:", 10, 0
    opciones_movimiento_oca:     
                                db "2) ABAJO",10
                                db "4) IZQUIERDA",10
                                db "6) DERECHA",10,0
    msg_error_movimiento    db "Por favor, elija un movimiento valido.",10,0
    msg_error_pared         db "No puedes moverte a una pared.",10,0
    msg_ocupada             db "No puedes moverte a una casilla ocupada",10,0
    msg_no_puede_comer      db "No hay espacio para comer a esa oca.",10,0
    msg_turno_oca           db "Escriba posicion de la oca a mover. Columna y fila.",10,0
    msg_error_oca           db "Ingrese una posición válida. Primero Columna y luego fila. Sin espacios. Ej: C1",10,0

section .bss
    movimiento_zorro resb 10
    movimiento_oca   resb 10

section .text

    main:
        sub rsp, 8
        call imprimir_bienvenida
        add rsp, 8

    game_loop:

        sub rsp, 8
        call turno_zorro
        add rsp, 8

        sub rsp, 8
        call turno_oca
        add rsp, 8

        jmp game_loop

        ret

    imprimir_bienvenida: ;imprime el msg de bienvenida
        mov rdi, msg_bienvenida
        mPuts
        ret

    imprimir_tablero: ;imprime el tablero
        mov rdi, matrix
        mPuts
        ret

    turno_zorro: ;turno del zorro

        sub rsp,8
        call imprimir_tablero
        add rsp,8

        mov rdi, msg_turno_zorro ; muestra el msg del turno del zorro
        mPuts
        
        mov rdi, opciones_movimiento_zorro ; muestra sus opciones de movimiento
        mPuts
        
        mov rdi, movimiento_zorro ; lee lo que ingresa el usuario
        mGets

        ; leer la opcion de movimiento
        mov al, byte[movimiento_zorro + 1]
        cmp al, 0 ; verifica que se haya mandado UN numero
        jne movimiento_invalido_zorro
        mov al, byte[movimiento_zorro]
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

        movimiento_invalido_zorro:
            mov rdi, msg_error_movimiento
            mPuts
            jmp turno_zorro

        mover_zorro_izquierda:
            mov eax, [zorro_nueva_pos]
            sub eax, [mov_x]
            mov [zorro_nueva_pos], eax
            sub eax, [mov_x]
            mov [zorro_sig_pos], eax
            jmp mover_zorro
            
        mover_zorro_izquierda_arriba:
            mov eax, [zorro_nueva_pos]
            sub eax, [mov_y] ; mueve fila hacia arriba
            sub eax, [mov_x]
            mov [zorro_nueva_pos], eax
            sub eax, [mov_y] 
            sub eax, [mov_x]
            mov [zorro_sig_pos], eax
            jmp mover_zorro
            
        mover_zorro_arriba:
            mov eax, [zorro_nueva_pos]
            sub eax, [mov_y]
            mov [zorro_nueva_pos], eax
            sub eax, [mov_y]
            mov [zorro_sig_pos], eax
            jmp mover_zorro
            
        mover_zorro_derecha_arriba:
            mov eax, [zorro_nueva_pos]
            add eax, [mov_x]
            sub eax, [mov_y]
            mov [zorro_nueva_pos], eax
            add eax, [mov_x]
            sub eax, [mov_y]
            mov [zorro_sig_pos], eax
            jmp mover_zorro
            
        mover_zorro_derecha:
            mov eax, [zorro_nueva_pos]
            add eax, [mov_x]
            mov [zorro_nueva_pos], eax
            add eax, [mov_x]
            mov [zorro_sig_pos], eax
            jmp mover_zorro
            
        mover_zorro_derecha_abajo:
            mov eax, [zorro_nueva_pos]
            add eax, [mov_x]
            add eax, [mov_y]
            mov [zorro_nueva_pos], eax
            add eax, [mov_x]
            add eax, [mov_y]
            mov [zorro_sig_pos], eax
            jmp mover_zorro
            
        mover_zorro_abajo:
            mov eax, [zorro_nueva_pos]
            add eax, [mov_y]
            mov [zorro_nueva_pos], eax
            add eax, [mov_y]
            mov [zorro_sig_pos], eax
            jmp mover_zorro
            
        mover_zorro_izquierda_abajo:
            mov eax, [zorro_nueva_pos]
            sub eax, [mov_x]
            add eax, [mov_y]
            mov [zorro_nueva_pos], eax
            sub eax, [mov_x]
            add eax, [mov_y]
            mov [zorro_sig_pos], eax
            jmp mover_zorro

        mover_zorro:
            lea rdi, [matrix]
            add edi, [zorro_nueva_pos]
            mov al, byte[rdi]
            
            cmp al, '#'
            je error_pared_zorro
            cmp al, 'O'
            je comer_oca

            mov byte[rdi], 'X'
            lea rdi, [matrix]
            add edi, [zorro_pos]
            mov byte[rdi], ' '
            mov ebx, [zorro_nueva_pos]
            mov [zorro_pos], ebx
            ret

        error_pared_zorro:
            mov rdi, msg_error_pared
            mPuts
            mov ebx, [zorro_pos]
            mov [zorro_nueva_pos], ebx
            jmp turno_zorro
        
        comer_oca:
            lea rdi, [matrix]
            add edi, [zorro_sig_pos]
            mov al, byte[rdi]
            cmp al, '#'
            je no_puede_comer
            cmp al, 'O'
            je no_puede_comer

            mov byte[rdi], 'X'
            lea rdi, [matrix]
            add edi, [zorro_nueva_pos]
            mov byte[rdi], ' '
            lea rdi, [matrix]
            add edi, [zorro_pos]
            mov byte[rdi], ' '

            mov ebx, [zorro_sig_pos]
            mov [zorro_nueva_pos], ebx
            mov [zorro_pos], ebx

            jmp turno_zorro

        no_puede_comer:
            mov rdi, msg_no_puede_comer
            mPuts
            mov ebx, [zorro_pos]
            mov [zorro_nueva_pos], ebx
            mov [zorro_nueva_pos], ebx
            jmp turno_zorro

    turno_oca:
        sub rsp,8
        call imprimir_tablero
        add rsp,8

        mov rdi, msg_turno_oca
        mPuts

        mov rdi, movimiento_oca
        mGets

        mov al, byte[movimiento_oca + 2]
        cmp al, 0 
        jne pos_invalida

        input_columna:
        mov al, byte[movimiento_oca] ;cargo columna
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

        jmp pos_invalida

        input_fila:
        mov al, byte[movimiento_oca + 1] ;cargo fila
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

        pos_invalida:
        mov rdi, msg_error_oca
        mPuts
        jmp turno_oca

        pos_valida:
        mov [oca_pos], ebx

        lea rdi, [matrix]
        add edi, [oca_pos]
        mov al, byte[rdi]
        cmp al, '#'
        je pos_invalida

        turno_mover_oca:    
        sub rsp,8
        call imprimir_tablero
        add rsp,8

        mov rdi, msg_movimientos_oca
        mPuts
        mov rdi, opciones_movimiento_oca
        mPuts
        mov rdi, movimiento_oca
        mGets

        mov al, byte[movimiento_oca + 1]
        cmp al, 0 
        jne mov_invalido_oca
        mov al, byte[movimiento_oca]
        cmp al, '2'
        je mover_oca_abajo
        cmp al, '4'
        je mover_oca_izquierda
        cmp al, '6'
        je mover_oca_derecha

        mov_invalido_oca:
        mov rdi, msg_error_movimiento
        mPuts
        jmp turno_mover_oca

        mover_oca_abajo:
            mov eax, [oca_pos]
            add eax, [mov_y]
            mov [oca_nueva_pos], eax
            jmp mover_oca

        mover_oca_izquierda:
            mov eax, [oca_pos]
            sub eax, [mov_x]
            mov [oca_nueva_pos], eax
            jmp mover_oca
        
        mover_oca_derecha:
            mov eax, [oca_pos]
            add eax, [mov_x]
            mov [oca_nueva_pos], eax
            jmp mover_oca

        mover_oca:
            lea rdi, [matrix]
            add edi, [oca_nueva_pos]
            mov al, byte[rdi]

            cmp al, '#'
            je error_pared_oca
            cmp al, 'O'
            je casilla_ocupada
            cmp al, 'X'
            je casilla_ocupada

            lea rdi, [matrix]
            add edi, [oca_pos]
            mov byte[rdi], ' '
            lea rdi, [matrix]
            add edi, [oca_nueva_pos]
            mov byte[rdi], 'O'

            ret

        error_pared_oca:
            mov rdi, msg_error_pared
            mPuts
            jmp turno_mover_oca
        casilla_ocupada:
            mov rdi, msg_ocupada
            mPuts
            jmp turno_mover_oca


        ret
;   TODO
;   poder cerrar el juego en cualquier momento, en cada gets habría que checkar si input es igual a quit
;   después de elegir la oca debería poder volver atrás y elegir otra