INCLUDE "hardware.inc"
INCLUDE "src/utils/constants.inc"

SECTION "Flappy Vars", WRAM0
wGameState:: db

SECTION "Header", ROM0[$100]
    jp EntryPoint
    ds $150 - @, 0

; The entrypoint
; @r8 a - trashed
EntryPoint:
    xor a
    ld [rNR52], a ; Disable Sound

    call WaitForOneVBlank
    call InitSprObjLib

    xor a
    ld [rLCDC], a ; Disable Screen

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_WINON
    ld [rLCDC], a ; Enable Screen

    ; Set Colors
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP0], a

; Changes the game states
; @r8 a - trashed
NextGameState::
    call WaitForOneVBlank
    call ClearBackground

    xor a
    ld [rLCDC], a
    ld [rSCX], a
    ld [rSCY], a
    ld [rWX], a
    ld [rWY], a

    call DisableInterrupts
    call ClearAllSprites

    ; Switch State
    ld a, [wGameState]
    
    cp GAME_STATE
    jp z, InitGameState

    jp InitTitleState

Loop:
    jp Loop