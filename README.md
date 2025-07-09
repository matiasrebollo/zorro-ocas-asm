# Organización del Computador - TP1

Integrantes:
- Mateo Cabrera Rodriguez
- Matias Gabriel Rebollo
- Tomas Garcia Alimena

# El Zorro y las Ocas

## Descripción

Este es un juego de estrategia clásico llamado "El Zorro y las Ocas", implementado en lenguaje ensamblador para la arquitectura x86-64. El juego se desarrolla en un tablero de 33 hendiduras, dispuestas en forma de cruz. Un jugador controla el zorro, y el otro controla 17 ocas. El objetivo del zorro es capturar al menos 12 ocas, mientras que el objetivo de las ocas es acorralar al zorro para que no pueda moverse.

## Reglas del Juego

1. El zorro y las ocas se colocan en posiciones iniciales específicas en el tablero.
2. El zorro inicia la partida y puede moverse en cualquier dirección (adelante, atrás, a los lados y en diagonal) una casilla a la vez, salvo cuando captura una oca.
3. Para capturar una oca, el zorro debe saltar sobre ella a una casilla vacía. Los saltos múltiples están permitidos.
4. Las ocas solo pueden moverse hacia adelante y hacia los lados, una casilla a la vez, y no pueden saltar sobre el zorro.
5. El zorro gana si captura al menos 12 ocas.
6. Las ocas ganan si logran acorralar al zorro, impidiéndole moverse.

## Organización del Proyecto


### Archivos

1. `main.asm`
3. `io.inc`

## Compilación y Ejecución

Para compilar y ejecutar el proyecto, seguir los siguientes pasos:

```bash
nasm main.asm -f elf64
gcc main.o -no-pie -o main.out
./main.out```
