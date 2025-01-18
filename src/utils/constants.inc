INCLUDE "hardware.inc"

DEF GAME_STATE EQU 1

DEF PIPE_HEIGHT_DIFF EQU 54
DEF PIPE_SPEED EQU 6

DEF PLAYER_JUMP_BOOST EQU 160
DEF GRAVITY EQU 6

RSRESET
DEF vramTilesGameplayStart      RB _VRAM + $1000
DEF vramTilesGameplayBackground RB 0

RSRESET
DEF vramGameplayStart             RB _VRAM
DEF vramGameplayPlayerStart       RB 4 * 16
DEF vramGameplayPipeStart         RB 4 * 16
DEF vramGameplayPipeStraightStart RB 4 * 16