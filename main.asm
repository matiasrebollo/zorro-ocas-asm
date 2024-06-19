%include "io.inc"

global main

section .data
    matrix:
        db      "     A   B   C   D   E   F   G   ",10
        db      "           ╔═══╦═══╦═══╗", 10
        db      "1          ║ O ║ O ║ O ║", 10
        db      "           ╠═══╬═══╬═══╣", 10
        db      "2          ║ O ║ O ║ O ║", 10
        db      "   ╔═══╦═══╬═══╬═══╬═══╬═══╦═══╗", 10
        db      "3  ║ O ║ O ║ O ║ O ║ O ║ O ║ O ║", 10
        db      "   ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╣", 10
        db      "4  ║ O ║   ║   ║ x ║   ║   ║ O ║", 10
        db      "   ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╣", 10
        db      "5  ║ O ║   ║   ║   ║   ║   ║ O ║", 10
        db      "   ╚═══╩═══╬═══╬═══╬═══╬═══╩═══╝", 10
        db      "6          ║   ║   ║   ║", 10
        db      "           ╠═══╬═══╬═══╣", 10
        db      "7          ║   ║   ║   ║", 10
        db      "           ╚═══╩═══╩═══╝", 10, 0

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

    mensaje_bienvenida:
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

    zorro_posicion dd 54
    zorro_nueva_posicion dd 54
    mov_x               db -1, 0, 1, -1, 0, 1, -1, 0, 1
    mov_y               db 1, 1, 1, 0, 0, 0, -1, -1, -1

    ; contador_ocas_comidas db 0
    
    
    mensaje_turno_zorro:
        db "Turno del zorro. Elija una posicion donde moverse:", 10, 0
    opciones_movimiento db "1) DIAGONAL IZQUIERDA ABAJO",10
                        db "2) ABAJO",10
                        db "3) DIAGONAL DERECHA ABAJO",10
                        db "4) IZQUIERDA",10
                        db "6) DERECHA",10
                        db "7) DIAGONAL IZQUIERDA ARRIBA",10
                        db "8) ARRIBA",10
                        db "9) DIAGONAL DERECHA ARRIBA",10,0

    mensaje_error_movimiento db "Por favor, elija un movimiento valido.."
    mensaje_error_pared db "No puedes moverte a una pared."

section .bss
    movimiento_zorro resb 10

section .text

    main:
        sub rsp, 8
        call imprimir_bienvenida
        add rsp, 8

    game_loop:

        sub rsp,8
        call imprimir_tablero
        add rsp,8

        sub rsp, 8
        call turno_zorro
        add rsp, 8

        jmp game_loop

        ret

    imprimir_bienvenida: ;imprime el mensaje de bienvenida
        mov rdi, mensaje_bienvenida
        mPuts
        ret

    imprimir_tablero: ;imprime el tablero
        mov rdi, tablero
        mPuts
        ret

    turno_zorro: ;turno del zorro
        mov rdi, mensaje_turno_zorro ; muestra el mensaje del turno del zorro
        mPuts
        
        mov rdi, opciones_movimiento ; muestra sus opciones de movimiento
        mPuts
        
        mov rdi, movimiento_zorro ; lee lo que ingresa el usuario
        mGets

        ; leer la opcion de movimiento
        mov al, byte[movimiento_zorro + 1]
        cmp al, 0 ; verifica que se haya mandado UN numero
        jne movimiento_invalido
        mov al, byte[movimiento_zorro + 1]
        sub al, '0'
        ;determinar movimiento y saltar a la rutina adecuada
        cmp al, 1
        je mover_izquierda_abajo
        cmp al, 2
        je mover_abajo
        cmp al, 3
        je mover_derecha_abajo
        cmp al, 4
        je mover_izquierda
        cmp al, 6
        je mover_derecha
        cmp al, 7
        je mover_izquierda_arriba
        cmp al, 8
        je mover_arriba
        cmp al, 9
        je mover_derecha_arriba

        mover_izquierda:
            mov eax, [zorro_nueva_posicion]
            sub eax, 1
            mov [zorro_nueva_posicion], eax
            jmp mover
            
        mover_izquierda_arriba:
            mov eax, [zorro_nueva_posicion]
            sub eax, 10 ; mueve fila hacia arriba
            sub eax, 1
            mov [zorro_nueva_posicion], eax
            jmp mover
            
        mover_arriba:
            mov al, [zorro_nueva_posicion]
            sub al, 10
            mov [zorro_nueva_posicion], al
            jmp mover
            
        mover_derecha_arriba:
            mov eax, [zorro_nueva_posicion]
            add eax, 1
            sub eax, 10
            mov [zorro_nueva_posicion], eax
            jmp mover
            
        mover_derecha:
            mov eax, [zorro_nueva_posicion]
            add eax, 1
            mov [zorro_nueva_posicion], eax
            jmp mover
            
        mover_derecha_abajo:
            mov eax, [zorro_nueva_posicion]
            add eax, 1
            add eax, 10
            mov [zorro_nueva_posicion], eax
            jmp mover
            
        mover_abajo:
            mov eax, [zorro_nueva_posicion]
            add eax, 10
            mov [zorro_nueva_posicion], eax
            jmp mover
            
        mover_izquierda_abajo:
            mov eax, [zorro_nueva_posicion]
            sub eax, 1
            add eax, 10
            mov [zorro_nueva_posicion], eax
            jmp mover

        mover:
            lea rdi, [tablero]
            add edi, [zorro_nueva_posicion]
            mov al, byte[rdi]
            
            cmp al, "#"
            je mensaje_pared
            cmp al, "O"
            je comer_oca ; queda implementar acá como comer una oca, y la restriccion de que si atras hay otra oca o una pared, no se pueda comer

            mov byte[rdi], "X"
            lea rdi, [tablero]
            add edi, [zorro_posicion]
            mov byte[rdi], " "
            mov ebx, [zorro_nueva_posicion]
            mov [zorro_posicion], ebx
            ret

        mensaje_pared:
            mov rdi, mensaje_error_pared
            sub rsp,8
            call puts
            add rsp,8
            mov ebx, [zorro_posicion]
            mov [zorro_nueva_posicion], ebx
            jmp game_loop

    ;come_oca:
        ; Lógica para "comer" la oca: saltar sobre la oca
        ; Aquí debes implementar la lógica específica para comer una oca
        ; Por ejemplo, mover al zorro a la nueva posición y actualizar el tablero

        ; Actualizar el tablero: limpiar la posición de la oca
        ;lea rdi, [tablero]
        ;add rdi, [zorro_new_pos]
        ;mov byte [rdi], ' '    ; Limpiar la posición de la oca

        ; Colocar al zorro en la nueva posición
        ;mov rdi, [zorro_new_pos]
        ;lea rdi, [tablero]
        ;add rdi, rdi
        ;mov byte [rdi], 'X'    ; Colocar al zorro en la nueva posición

        ; Actualizar la posición del zorro
        ;mov [zorro_pos], rdi

        ; Incrementar el contador de ocas comidas (si llevas uno)
        ;inc [contador_ocas_comidas]

        ;ret
