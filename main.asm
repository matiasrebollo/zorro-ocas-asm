%include "io.inc"
extern printf
extern fopen
extern fwrite
extern fread
extern fclose

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
        db      " #################################", 10,0 ; 37x18

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

    ;personalizacion por defecto
    simbolo_zorro               db 'X', 0
    simbolo_oca                 db 'O', 0

    ;mensajes para la personalizacion
    msg_personalizacion         db "Querés personalizar los simbolos del zorro y las ocas? (S/N):", 0
    msg_respuesta_invalida      db "Respuesta inválida. Por favor, ingresá S o N.", 10, 0
    msg_simbolo_invalido_zorro  db "Símbolo inválido. No puede ser '#' ni un espacio. Ingresá otro símbolo para el Zorro: ", 0
    msg_simbolo_invalido_oca    db "Símbolo inválido. No puede ser '#' ni un espacio ni el mismo símbolo que el Zorro. Ingresá otro símbolo para las Ocas: ", 0
    msg_simbolo_zorro           db "Ingresá el simbolo para el zorro:", 0
    msg_simbolo_oca             db "Ingresá el simbolo para las ocas:", 0
    personalizacion_si          db "s", 0
    personalizacion_no          db "n", 0

    
    save_nombre                 db "save.bin", 0
    modo_escritura              db "wb",0
    modo_lectura                db "rb",0
    fin_linea                   db 10,0

    zorro_pos                   dd 402
    zorro_nueva_pos             dd 402
    zorro_sig_pos               dd 402
    zorro_acorralado            db 0 ;0 si al zorro le quedan movimientos validos, 1 si no.

    oca_pos                     dd 0
    oca_nueva_pos               dd 0
    ocas_comidas                dd 0

    mov_x                       dd 4
    mov_y                       dd 70
    
    turno                       db 0 ; 0 si es el turno de MOVER zorro. 
                                     ; 1 si es el turno de ELEGIR la oca. 
                                     ; 2 si es el turno de MOVER la oca.

    error                       db 0 ; 0 si no hay error
                                     ; 1 error_movimiento, (movimiento invalido).
                                     ; 2 error_pared
                                     ; 3 error ocupada
                                     ; 4 error no_puede_comer
                                     ; 5 error_oca, (seleccion no valida).
    
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


    ;fin juego

    msg_gana_zorro              db "Gana zorro.",10,0
    msg_gana_ocas               db "Gana ocas.",10,0

    movimientos_zorro   times 9 dd 0 ;historial de movimientos del zorro [abajoizquierda, abajo, abajoderecha, izquierda, pasar_turno?, derecha, arribaizquierda, arriba, arribaderecha]
    
    stats_zorro:
        stats_zorro_1           db "El zorro se movió en diagonal abajo a la izquierda %d veces.",10,0
        stats_zorro_2           db "El zorro se movió hacia abajo %d veces.",10,0
        stats_zorro_3           db "El zorro se movió en diagonal abajo a la derecha %d veces.",10,0
        stats_zorro_4           db "El zorro se movió hacia la izquierda %d veces.",10,0
        stats_zorro_5           db "",0
        stats_zorro_6           db "El zorro se movió hacia la derecha %d veces.",10,0
        stats_zorro_7           db "El zorro se movió en diagonal arriba a la izquierda %d veces.",10,0
        stats_zorro_8           db "El zorro se movió hacia arriba %d veces.",10,0
        stats_zorro_9           db "El zorro se movió en diagonal arriba a la derecha %d veces.",10,0


    ;comandos
    comando_salir               db "salir",0
    comando_guardar             db "guardar",0
    comando_cargar              db "cargar",0

    str_len                     dd 0

section .bss
    respuesta_personalizacion   resb 2 ; para almacenar la respuesta de personalizacion (S/N)
    nuevo_simbolo_zorro         resb 2
    nuevo_simbolo_oca           resb 2
    orientacion                 resb 2

    input                       resb 10

    fileHandle                  resq 1

section .text

    main:
        mov rdi, msg_bienvenida ; imprime bienvenida al juego
        mPuts

        verificar_personalizacion:
            mov rdi, msg_personalizacion ; pregunta si se desea personalizar
            mPuts
            mov rdi, input ; lee la respuesta
            mGets

            mov al, byte[input + 1]
            cmp al, 0
            jne verificar_personalizacion_invalida
            
            mov rsi, personalizacion_si
            mov rdi, input
            sub rcx, rcx
            mov ecx, 1

            call lowercase_cmp

            je personalizar_simbolos ; si S, personaliza simbolos

            mov rsi, personalizacion_no
            mov rdi, input
            sub rcx, rcx
            mov ecx, 1

            call lowercase_cmp

            je game_loop ; si N, comienza el juego

            verificar_personalizacion_invalida:

            mov rdi, msg_respuesta_invalida
            mPuts
            jmp verificar_personalizacion


    game_loop:
        mov rdi, matrix
        mPuts

        sub rsp, 8
        call check_zorro
        add rsp, 8

        cmp dword[ocas_comidas], 12 ; si ya comimos 12 ocas gana el zorro
        jge gana_zorro

        cmp byte[zorro_acorralado], 1 ; verifica si el zorro esta acorralado
        je gana_ocas

        sub rsp, 8
        call imprimir ; dependiendo a quien le toque, imprime opciones de juego
        add rsp, 8
        jmp comandos_input ; verifica si se uso algun comando (save, load, exit)

        continuar_turno:

        cmp byte[turno],0
        je turno_zorro

        cmp byte[turno],1
        je turno_oca

        cmp byte[turno],2
        je turno_mover_oca

        jmp game_loop

    
    personalizar_simbolos:
        
        leer_simbolo_zorro:
            mov rdi, msg_simbolo_zorro ; pide simbolo
            mPuts
            mov rdi, input ; lee simbolo
            mGets

            mov al, byte[input + 1] ; compara para chequear su validez
            cmp al, 0
            jne simbolo_zorro_invalido ; si ingreso mas de un caracter
            mov al, byte[input]
            cmp al, '#'
            je simbolo_zorro_invalido
            cmp al, ' '
            jle simbolo_zorro_invalido
            cmp al, 127
            jge simbolo_zorro_invalido
            jmp validar_simbolo_zorro ;cambia el simbolo

        simbolo_zorro_invalido:
            mov rdi, msg_simbolo_invalido_zorro
            mPuts
            jmp leer_simbolo_zorro

        validar_simbolo_zorro:
            mov byte[simbolo_zorro], al ; actualiza simbolo del zorro

        
        leer_simbolo_oca:
            mov rdi, msg_simbolo_oca
            mPuts
            mov rdi, input
            mGets

            mov al, byte [input + 1] ; compara para chequear su validez
            cmp al, 0
            jne simbolo_oca_invalido ; si ingreso mas de un caracter
            mov al, byte[input]
            cmp al, '#'
            je simbolo_oca_invalido
            cmp al, ' '
            jle simbolo_oca_invalido
            cmp al, byte [simbolo_zorro]
            je simbolo_oca_invalido
            cmp al, 127
            jge simbolo_oca_invalido
            jmp validar_simbolo_oca ; cambia el simbolo

        simbolo_oca_invalido:
            mov rdi, msg_simbolo_invalido_oca
            mPuts
            jmp leer_simbolo_oca

        validar_simbolo_oca:
            mov byte [simbolo_oca], al ; actualiza simbolo oca

        jmp actualizar_simbolos_matriz


    actualizar_simbolos_matriz:
        lea r8, [matrix] ; apunta a la matriz
        mov rcx, 685 ; tamano de la matriz en caracteres
        
        recorrer_bucle:
            mov al, byte[r8] ; lee un caracter

            cmp al, 'X'
            jne revisar_ocas
            mov al, byte[simbolo_zorro]
            mov byte[r8], al
            jmp siguiente_caracter

        revisar_ocas:
            cmp al, 'O'
            jne siguiente_caracter
            mov al, byte[simbolo_oca]
            mov byte[r8], al

        siguiente_caracter:
            inc r8 ; siguiente caracter
            loop recorrer_bucle ; dec rcx y loopea hasta 0

        jmp game_loop

    
    gana_zorro:
        sub rsp, 8
        call imprimir_stats_zorro
        add rsp, 8
        mov rdi, msg_gana_zorro ; se imprime que gano el zorro
        mPuts
        ret

    gana_ocas:
        sub rsp, 8
        call imprimir_stats_zorro
        add rsp, 8
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
        je fin_check_zorro
        
        
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
        je fin_check_zorro
        
        
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
        je fin_check_zorro
        

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
        je fin_check_zorro
        

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
        je fin_check_zorro
        

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
        je fin_check_zorro
        

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
        je fin_check_zorro
        

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
        je fin_check_zorro
        
        mov byte[zorro_acorralado], 1

        fin_check_zorro:
        ret



    comandos_input:
        ; si input == salir: ret

        mov rsi, comando_salir
        mov rdi, input
        sub rcx, rcx
        mov ecx, 5

        call lowercase_cmp

        je ejecutar_salir

        ; si input == guardar: call guardar

        mov rsi, comando_guardar
        mov rdi, input
        sub rcx, rcx
        mov ecx, 7

        call lowercase_cmp

        je ejecutar_guardar

        ; si input == cargar: call cargar

        mov rsi, comando_cargar
        mov rdi, input
        sub rcx, rcx
        mov ecx, 6

        call lowercase_cmp

        je ejecutar_cargar

        jmp continuar_turno

        ejecutar_salir:
            ret
        ejecutar_guardar:
            sub rsp, 8
            call guardar
            add rsp, 8
            jmp game_loop
        ejecutar_cargar:
            sub rsp, 8
            call cargar
            add rsp, 8
            jmp game_loop




    validar_movimiento:
        mov byte[zorro_acorralado],0
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
        cmp al, byte[simbolo_oca]
        je validar_movimiento_false

        validar_movimiento_true:
            ret
        validar_movimiento_false:
            mov byte[zorro_acorralado],1
            ret




    imprimir: ;imprime las opciones de juego

        cmp byte[turno],0
        je imprimir_zorro
        cmp byte[turno],1
        je imprimir_oca_sel
        cmp byte[turno],2
        je imprimir_oca_mov

        imprimir_zorro:
            mov rdi, opciones_movimiento_zorro
            sub rsp, 8
            call seleccionar_mensaje
            call printf
            add rsp, 8
            jmp fin_imprimir

        imprimir_oca_sel:
            mov rdi, opciones_seleccion_oca
            sub rsp, 8
            call seleccionar_mensaje
            call printf
            add rsp, 8
            jmp fin_imprimir

        imprimir_oca_mov:
            mov rdi, opciones_movimiento_oca
            sub rsp, 8
            call seleccionar_mensaje
            call printf
            add rsp, 8
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
            cmp al, byte[simbolo_oca]
            je comer_oca ; si hay oca es un caso a ver

            mov al, byte[simbolo_zorro]
            mov byte[rdi], al ;si no hay nada, movemos el zorro
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
            cmp al, byte[simbolo_oca]
            je no_puede_comer ; si hay oca no se puede comer

            mov al, byte[simbolo_zorro]
            mov byte[rdi], al ;movemos al zorro
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

            movzx eax, byte[input]
            sub eax, '1'
            inc dword[movimientos_zorro + eax * 4]

            jmp game_loop ;si no vuelve a ser turno del zorro

        no_puede_comer:
            mov byte[error], 4
            mov ebx, [zorro_pos]
            mov [zorro_nueva_pos], ebx
            mov [zorro_nueva_pos], ebx
            jmp game_loop

        fin_turno_zorro:
            movzx eax, byte[input]
            sub eax, '1'
            inc dword[movimientos_zorro + eax * 4]
            mov byte[turno], 1
            jmp game_loop

    turno_oca:
        mov al, byte[input + 2]
        cmp al, 0 
        jne pos_invalida

        input_columna:
        mov al, byte[input] ;cargo columna
        mov ebx, 110
        cmp al, 'a'
        je input_fila
        mov ebx, 114
        cmp al, 'b'
        je input_fila
        mov ebx, 118
        cmp al, 'c'
        je input_fila
        mov ebx, 122
        cmp al, 'd'
        je input_fila
        mov ebx, 126
        cmp al, 'e'
        je input_fila
        mov ebx, 130
        cmp al, 'f'
        je input_fila
        mov ebx, 134
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
        cmp al, byte[simbolo_oca]
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
            cmp al, byte[simbolo_oca] ; si hay otra oca esta ocupada
            je casilla_ocupada
            cmp al, byte[simbolo_zorro] ; si esta el zorro esta ocupada
            je casilla_ocupada

            lea rdi, [matrix]
            add edi, [oca_pos]
            mov byte[rdi], ' ' ; borramos la posicion antigua de la oca
            lea rdi, [matrix]
            add edi, [oca_nueva_pos]
            mov al, byte[simbolo_oca]
            mov byte[rdi], al ; colocamos la oca en su nueva posicion

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


    guardar:
        mov rdi, save_nombre
        mov rsi, modo_escritura
        call fopen

        ;TODO handle error

        mov [fileHandle],rax

        ;guardar matrix
        mov rdi, matrix
        mov rsi, 35
        mov rdx, 18
        mov rcx, [fileHandle]
        call fwrite

        ;guardar turno
        mov rdi, turno
        mov rsi, 1
        mov rdx, 1
        mov rcx, [fileHandle]
        call fwrite

        ;guardar movimientos_zorro
        mov rdi, movimientos_zorro
        mov rsi, 4
        mov rdx, 9
        mov rcx, [fileHandle]
        call fwrite

        ;guardar ocas_comidas
        mov rdi, ocas_comidas
        mov rsi, 4
        mov rdx, 1
        mov rcx, [fileHandle]
        call fwrite

        ;guardar zorro_pos
        mov rdi, zorro_pos
        mov rsi, 4
        mov rdx, 1
        mov rcx, [fileHandle]
        call fwrite


        mov rdi, fin_linea
        mov rsi, 1
        mov rdx, 1
        mov rcx, [fileHandle]
        call fwrite

        mov rdi, [fileHandle]
        call fclose

    cargar:
        mov rdi, save_nombre
        mov rsi, modo_lectura
        call fopen

        ;TODO handle error

        mov [fileHandle],rax

        ;cargar matrix
        mov rdi, matrix
        mov rsi, 35
        mov rdx, 18
        mov rcx, [fileHandle]
        call fread

        ;cargar turno
        mov rdi, turno
        mov rsi, 1
        mov rdx, 1
        mov rcx, [fileHandle]
        call fread

        ;cargar movimientos_zorro
        mov rdi, movimientos_zorro
        mov rsi, 4
        mov rdx, 9
        mov rcx, [fileHandle]
        call fread

        ;cargar ocas_comidas
        mov rdi, ocas_comidas
        mov rsi, 4
        mov rdx, 1
        mov rcx, [fileHandle]
        call fread

        ;cargar zorro_pos
        mov rdi, zorro_pos
        mov rsi, 4
        mov rdx, 1
        mov rcx, [fileHandle]
        call fread


        mov rdi, [fileHandle]
        call fclose


    imprimir_stats_zorro:
        mov rdi, stats_zorro_1
        mov esi, dword[movimientos_zorro]
        sub rsp, 8
        call printf
        add rsp, 8
        mov rdi, stats_zorro_2
        mov esi, dword[movimientos_zorro + 1 * 4]
        sub rsp, 8
        call printf
        add rsp, 8
        mov rdi, stats_zorro_3
        mov esi, dword[movimientos_zorro + 2 * 4]
        sub rsp, 8
        call printf
        add rsp, 8
        mov rdi, stats_zorro_4
        mov esi, dword[movimientos_zorro + 3 * 4]
        sub rsp, 8
        call printf
        add rsp, 8
        mov rdi, stats_zorro_6
        mov esi, dword[movimientos_zorro + 4 * 4]
        sub rsp, 8
        call printf
        add rsp, 8
        mov rdi, stats_zorro_7
        mov esi, dword[movimientos_zorro + 6 * 4]
        sub rsp, 8
        call printf
        add rsp, 8
        mov rdi, stats_zorro_8
        mov esi, dword[movimientos_zorro + 7 * 4]
        sub rsp, 8
        call printf
        add rsp, 8
        mov rdi, stats_zorro_9
        mov esi, dword[movimientos_zorro + 8 * 4]
        sub rsp, 8
        call printf
        add rsp, 8
        ret

;funciones auxiliares

lowercase_cmp:
    ; compara dos strings guardados en rsi y rdi. Ignora la capitalización del segundo asumiendo que el primero está en minusculas.
    ; largo n almacenado en ecx.
    mov dword[str_len], ecx
    sub rsp, 8
    call lowercase
    add rsp, 8
    mov ecx, dword[str_len]
    repe cmpsb
    ret

lowercase:
    ; convierte a minusculas el string almacenado en rdi, de largo n almacenado en ecx.
    lowercase_start:
    mov al, [rdi+rcx]
    cmp al, 90
    jg lowercase_continue
    cmp al, 65
    jl lowercase_continue
    add al, 32
    mov [rdi+rcx], al
    lowercase_continue:
    dec ecx
    cmp ecx, 0
    jge lowercase_start
    ret



;   TODO
;   poder cerrar el juego en cualquier momento, en cada gets habría que checkar si input es igual a quit
;   después de elegir la oca debería poder volver atrás y elegir otra
;   si no hay save y cargás se rompe.
