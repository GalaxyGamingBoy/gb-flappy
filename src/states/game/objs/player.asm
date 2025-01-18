INCLUDE "hardware.inc"
INCLUDE "src/utils/constants.inc"

SECTION "Gameplay Player Object Vars", WRAM0
wPipePlayerYCollision:: db
wPlayerX:: db
wPlayerY: dw

SECTION "Gameplay Player Object", ROM0
playerTiles: INCBIN "src/gen/sprs/bird.2bpp"
playerTilesEnd:

playerMetasprite: 
    db 0, 0, 0, 0
    db 0, 8, 2, 0
    db 128

InitGameplayPlayer::
    ld de, playerTiles
    ld hl, vramGameplayPlayerStart
    ld bc, playerTilesEnd - playerTiles
    call MemCopy

    ld a, 24
    ld [wPlayerX], a

    xor a
    ld [wPlayerY], a
    ld a, %0100
    ld [wPlayerY + 1], a

    ret

UpdateGameplayPlayer::
    xor a
    ld [wPipePlayerYCollision], a

UpdateGameplayPlayer_KeyHandler:
    ld a, [wCurKeys]
    and PADF_UP
    jp nz, UpdateGameplayPlayer_TryKeyUp

    jp UpdateGameplayPlayer_DrawMetasprite

UpdateGameplayPlayer_TryKeyUp:
    ld a, [wLastKeys]
    and PADF_UP
    jp nz, UpdateGameplayPlayer_DrawMetasprite

UpdateGameplayPlayer_KeyUp:
    ld a, [wPlayerY]
    sub PLAYER_JUMP_BOOST
    ld [wPlayerY], a

    ld a, [wPlayerY + 1]
    sbc 0
    ld [wPlayerY + 1], a

UpdateGameplayPlayer_DrawMetasprite:
    ; Add Gravity
    ld a, [wPlayerY]
    add GRAVITY
    ld [wPlayerY], a

    ld a, [wPlayerY + 1]
    adc 0
    ld [wPlayerY + 1], a

    ; Draw Metasprite
    ld a, [wPlayerX]
    ld b, a
    ld [wMetaspriteX], a

    ld a, [wPlayerY + 1]
    ld b, a
    ld a, [wPlayerY]
    ld c, a

    srl b
    rr c
    srl b
    rr c
    srl b
    rr c
    srl b
    rr c

    ld a, c
    ld [wMetaspriteY], a

    ld a, LOW(playerMetasprite)
    ld [wMetaspriteLoc], a
    ld a, HIGH(playerMetasprite)
    ld [wMetaspriteLoc+1], a

    push bc
    call DrawMetasprite
    pop bc

; b: X, c: Y
UpdateGameplayPlayer_GroundCollisionCheck:
    ld a, c
    cp 120
    jp nc, ToGameoverGameState

; b: X, c: Y, d: Pipe Y
UpdateGameplayPlayer_PipeCollisionCheck:
    ld a, [wPipeY]
    ld d, a

    ; Check if player is below pipe y
    ld a, c
    add 12 ; Tile Size 16, 12 with leeway
    cp d
    call nc, UpdateGameplayPlayer_PipeCollisionDetected

    ; Check if player is above pipe y
    ld a, c
    add PIPE_HEIGHT_DIFF - 16 - 4 ; Pipe metasprite y has an offset of 16! Also removing 4 for leeway
    cp d
    call c, UpdateGameplayPlayer_PipeCollisionDetected

    ret 

UpdateGameplayPlayer_PipeCollisionDetected:
    ld a, 1
    ld [wPipePlayerYCollision], a
    ret