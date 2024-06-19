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

    tablero:
        db "##OOO##",10
        db "##OOO##",10
        db "OOOOOOO",10
        db "O     O",10
        db "O  X  O",10
        db "##   ##",10
        db "##   ##",10,0

    zorro_pos           dd 35
    zorro_new_pos       dd 35
    mov_x               db -1, 0, 1, -1, 0, 1, -1, 0, 1
    mov_y               db 1, 1, 1, 0, 0, 0, -1, -1, -1

    ; contador_ocas_comidas db 0
    
    
    mensaje_turno_zorro:
        db "Turno del zorro. Elija una posicion donde moverse:", 10, 0
    opciones_movimiento:
        db "1) Diagonal Izquierda Abajo",10
        db "2) Abajo",10
        db "3) Diagonal Derecha Abajo",10
        db "4) Izquierda",10
        db "5) Movimiento Invalido",10
        db "6) Derecha",10
        db "7) Diagonal Izquierda Arriba",10
        db "8) Arriba",10
        db "9) Diagonal Derecha Arriba",10,0

    mensaje_error_movimiento:
        db "Movimiento invalido! Intenta de nuevo...",10,0

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

        ; validar y aplicar el movimiento
        ;call validar_movimiento_zorro ; esta funcion y la de abajo deberian validarse dentro de la funcion 'mover'
        ;test eax,eax

        ;si es valido aplicar
        ;call aplicar_movimiento_zorro

        jmp fin_turno_zorro

    movimiento_invalido:
        mov rdi, mensaje_error_movimiento
        mPuts
        jmp turno_zorro

    fin_turno_zorro:
        ret

    validar_movimiento_zorro:
        ; calcula la nueva posición basada en el movimiento deseado
        ; asumimos que la posición actual del zorro está en zorro_pos
        mov eax, [zorro_pos]      ; la posición actual del zorro en la matriz lineal (0-48)
        movzx ecx, al             ; guardamos la opción de movimiento en ecx
        lea esi, [mov_x]          ; base de desplazamientos en x
        lea edi, [mov_y]          ; base de desplazamientos en y

        ; determinar la nueva posición usando los desplazamientos del numpad
        movsx ebx, byte [esi + ecx - 1]
        add eax, ebx
        movsx ebx, byte [edi + ecx - 1]
        add eax, ebx

        ; guardar la nueva posición calculada en zorro_new_pos
        mov [zorro_new_pos], eax

        ; Validar que la nueva posición está dentro de los límites del tablero
        mov esi, tablero      ; Cargar la dirección del tablero
        add esi, eax        ; Obtener la nueva posición en el tablero

        ; Verificar si la nueva posición es válida (no una casilla no válida "#")
        cmp byte [esi], '#' 
        je movimiento_invalido

        ; Si es un espacio vacío (' ') o el Zorro mismo ('X'), el movimiento es válido
        mov eax, 1
        ret



    aplicar_movimiento_zorro:

        ; Aquí se debería implementar el código para actualizar el tablero y mover el zorro
        ; Ejemplo: Actualizar la posición actual y la nueva posición en el tablero

        ; Borrar la posición actual del zorro
        mov eax, [zorro_pos]   ; La posición actual del zorro en la matriz lineal (0-48)
        mov esi, tablero
        add esi, eax
        mov byte [esi], ' '    ; Limpiar la posición antigua del zorro

        ; Colocar el zorro en la nueva posición
        mov eax, [zorro_new_pos]   ; La nueva posición del zorro en la matriz lineal
        mov esi, tablero
        add esi, eax
        mov byte [esi], 'X'    ; Colocar el zorro en la nueva posición

        ; Actualizar la posición del zorro
        mov [zorro_pos], eax

        ret


    mover_izquierda:
        mov eax, [zorro_new_pos]
        sub eax, 1 
        mov [zorro_new_pos], eax
        jmp mover
        ret
    mover_izquierda_arriba:
        mov eax, [zorro_new_pos]
        sub eax, 8 ; Mueve una fila hacia arriba
        sub eax, 1 ; Mueve una columna hacia la izquierda
        mov [zorro_new_pos], eax
        jmp mover
        ret

    mover_arriba:
        mov eax, [zorro_new_pos]
        sub eax, 8
        mov [zorro_new_pos], eax
        jmp mover
        ret

    mover_derecha_arriba:
        mov eax, [zorro_new_pos]
        add eax, 1
        sub eax, 8
        mov [zorro_new_pos], eax
        jmp mover
        ret

    mover_derecha:
        mov eax, [zorro_new_pos]
        add eax, 1
        mov [zorro_new_pos], eax
        jmp mover
        ret

    mover_derecha_abajo:
        mov eax, [zorro_new_pos]
        add eax, 8
        add eax, 1
        mov [zorro_new_pos], eax
        jmp mover
        ret

    mover_abajo:
        mov eax, [zorro_new_pos]
        add eax, 8
        mov [zorro_new_pos], eax
        jmp mover
        ret

    mover_izquierda_abajo:
        mov eax, [zorro_new_pos]
        sub eax, 1
        add eax, 8
        mov [zorro_new_pos], eax
        jmp mover
        ret    

    mover:

        lea rdi,[tablero]
        add rdi,[zorro_new_pos]
        cmp byte[rdi], 'O' 
        je come_oca ; ir a la rutina para comer la oca
        ; FALTA COMPARAR CON # PARA VER SI ES UNA PARED
        ; si no es una oca
        mov byte[rdi],'X'
        mov rdi,[zorro_new_pos]
        mov [zorro_pos],rdi
        ; falta poner el espacio donde estaba antes el zorro en blanco

        ret

    come_oca:
        ; Lógica para "comer" la oca: saltar sobre la oca
        ; Aquí debes implementar la lógica específica para comer una oca
        ; Por ejemplo, mover al zorro a la nueva posición y actualizar el tablero

        ; Actualizar el tablero: limpiar la posición de la oca
        lea rdi, [tablero]
        add rdi, [zorro_new_pos]
        mov byte [rdi], ' '    ; Limpiar la posición de la oca

        ; Colocar al zorro en la nueva posición
        mov rdi, [zorro_new_pos]
        lea rdi, [tablero]
        add rdi, rdi
        mov byte [rdi], 'X'    ; Colocar al zorro en la nueva posición

        ; Actualizar la posición del zorro
        mov [zorro_pos], rdi

        ; Incrementar el contador de ocas comidas (si llevas uno)
        ;inc [contador_ocas_comidas]

        ret
