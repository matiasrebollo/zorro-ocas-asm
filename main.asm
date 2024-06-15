%include "io.inc"

global main

section .data
    matrix:
        db      "     A   B   C   D   E   F   G   H   I",10
        db      "               ╔═══╦═══╦═══╗", 10
        db      "1              ║ O ║ O ║ O ║", 10
        db      "               ╠═══╬═══╬═══╣", 10
        db      "2              ║ O ║ O ║ O ║", 10
        db      "   ╔═══╦═══╦═══╬═══╬═══╬═══╬═══╦═══╦═══╗", 10
        db      "3  ║ O ║ O ║ O ║ O ║ O ║ O ║ O ║ O ║ O ║", 10
        db      "   ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣", 10
        db      "4  ║ O ║   ║   ║   ║ x ║   ║   ║   ║ O ║", 10
        db      "   ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣", 10
        db      "5  ║ O ║   ║   ║   ║   ║   ║   ║   ║ O ║", 10
        db      "   ╚═══╩═══╩═══╬═══╬═══╬═══╬═══╩═══╩═══╝", 10
        db      "6              ║   ║   ║   ║", 10
        db      "               ╠═══╬═══╬═══╣", 10
        db      "7              ║   ║   ║   ║", 10
        db      "               ╚═══╩═══╩═══╝", 10, 0

    title:
        db      "           ______  ____       _                   _____",10
        db      "          /\__  _\/\  _`\   /' \                 /\  __`\",10
        db      "          \/_/\ \/\ \ \L\ \/\_, \                \ \ \/\ \  _ __    __      __",10
        db      "             \ \ \ \ \ ,__/\/_/\ \      _______   \ \ \ \ \/\`'__\/'_ `\  /'__`\",10
        db      "              \ \ \ \ \ \/    \ \ \    /\______\   \ \ \_\ \ \ \//\ \L\ \/\ \L\.\_",10
        db      "               \ \_\ \ \_\     \ \_\   \/______/    \ \_____\ \_\\ \____ \ \__/.\_\",10
        db      "                \/_/  \/_/      \/_/                 \/_____/\/_/ \/___L\ \/__/\/_/",10
        db      "                                                                    /\____/",10
        db      "                                                                    \_/__/",10
        db      " ______  _   ______                                    _                ____",10
        db      "|  ____|| | |___  /                                   | |              / __ \",10
        db      "| |__   | |    / /   ___   _ __  _ __   ___    _   _  | |  __ _  ___  | |  | |  ___   __ _  ___ ",10
        db      "|  __|  | |   / /   / _ \ | '__|| '__| / _ \  | | | | | | / _` |/ __| | |  | | / __| / _` |/ __|",10
        db      "| |____ | |  / /__ | (_) || |   | |   | (_) | | |_| | | || (_| |\__ \ | |__| || (__ | (_| |\__ \",10
        db      "|______||_| /_____| \___/ |_|   |_|    \___/   \__, | |_| \__,_||___/  \____/  \___| \__,_||___/",10
        db      "                                                __/ |",10
        db      "                                               |___/",10
        db      10
        db      "                                     ESCRIBE START PARA EMPEZAR",10,0

    mensaje_bienvenida db "¡Bienvenido al juego El Zorro y las Ocas!", 10 
                       db "Reglas básicas:", 10 
                       db "El objetivo del juego es que el Zorro (X) capture al menos 12 ocas (O).", 10 
                       db "Las ocas se mueven hacia adelante o hacia los lados, una casilla a la vez.", 10 
                       db "El Zorro puede moverse en cualquier dirección una casilla a la vez (salvo que coma a una oca).", 10 
                       db "Para comer una oca, el Zorro debe saltar sobre ella a una casilla vacía (puede hacer saltos multiples).", 10
                       db "Es un movimiento por turno (comienza el zorro, luego las ocas) y solamente puede moverse una pieza por vez.", 10 
                       db "El juego termina cuando el Zorro captura 12 ocas o queda acorralado.", 10 
                       db "¡Que empiece la partida!", 10, 
                       db "A continuacion se muestra el tablero:", 10, 0 

    tablero db "#", "#", "O", "O", "O", "#", "#",10
            db "#", "#", "O", "O", "O", "#", "#",10
            db "O", "O", "O", "O", "O", "O", "O",10
            db "O", " ", " ", " ", " ", " ", "O",10
            db "O", " ", " ", "X", " ", " ", "O",10
            db "#", "#", " ", " ", " ", "#", "#",10
            db "#", "#", " ", " ", " ", "#", "#",10,0

    zorro_x db 4
    zorro_y db 5
    
    
    mensaje_turno_zorro db "Turno del zorro. Elija una posicion donde moverse:", 10, 0
    opciones_movimiento db "1) IZQUIERDA",10
                        db "2) DIAGONAL IZQUIERDA ARRIBA",10
                        db "3) ARRIBA",10
                        db "4) DIAGONAL DERECHA ARRIBA",10
                        db "5) DERECHA",10
                        db "6) DIAGONAL DERECHA ABAJO",10
                        db "7) ABAJO",10
                        db "8) DIAGONAL IZQUIERDA ABAJO",10,0
    mensaje_error_movimiento db "Por favor, elija un movimiento valido."

section .bss
    movimiento_zorro resb 10

section .text

main:
    sub rsp, 8
    call imprimir_bienvenida
    add rsp, 8

    sub rsp,8
    call imprimir_tablero
    add rsp,8

    sub rsp, 8
    call turno_zorro
    add rsp, 8

    ret

    imprimir_bienvenida: ;rutina que imprime el mensaje de bienvenida
        mov rdi, mensaje_bienvenida
        sub rsp, 8
        call puts
        add rsp,8
        ret

    imprimir_tablero: ; rutina que imprime el tablero
        mov rdi, tablero
        sub rsp, 8
        call puts
        add rsp,8
        ret
    
    ; obviamente todo esto tiene que estar adentro de un "while" hasta que termine el juego
    turno_zorro: ; rutina que imprime el turno del zorro

        mov rdi, mensaje_turno_zorro ; muestra el mensaje del turno del zorro
        sub rsp, 8
        call puts
        add rsp, 8

        mov rdi, opciones_movimiento ; muestra sus opciones de movimiento
        sub rsp, 8
        call puts
        add rsp, 8

        mov rdi, movimiento_zorro ; lee lo que ingresa el usuario
        sub rsp,8
        call gets
        add rsp,8

        mov al, byte[movimiento_zorro + 1]
        cmp al, 0 ; verifica que se haya ingresado UN numero
        jne lectura_invalida
        mov al, byte[movimiento_zorro] ; chequeamos què movimiento ingreso el usuario, y saltamos a la rutina que realiza el movimiento
        cmp al, "1"
        je mover_izquierda
        cmp al, "2"
        je mover_izquierda_arriba
        cmp al, "3"
        je mover_arriba
        cmp al, "4"
        je mover_derecha_arriba
        cmp al, "5"
        je mover_derecha
        cmp al, "6"
        je mover_derecha_abajo
        cmp al, "7"
        je mover_abajo
        cmp al, "8"
        je mover_izquierda_abajo
        lectura_invalida:
            mov rdi, mensaje_error_movimiento
            sub rsp,8
            call puts
            add rsp,8
            jmp turno_zorro

        ; queda implementarlas, chequeando la posicion donde caeria el zorro (osea viendo que no caiga en una pared, ni que caiga en una oca habiendo una atras)
        ; cada vez que movemos el zorro hay que actualizar la matriz y actualizar zorro_x y zorro_y
        ; tambien aca tendria que estar la implementacion de cuando el zorro come una oca, pero primero hagamos el movimiento
        mover_izquierda:
            ret
        mover_izquierda_arriba:
            ret
        mover_arriba:
            ret
        mover_derecha_arriba:
            ret
        mover_derecha:
            ret
        mover_derecha_abajo:
            ret
        mover_abajo:
            ret
        mover_izquierda_abajo:
            ret    

        

        ret

