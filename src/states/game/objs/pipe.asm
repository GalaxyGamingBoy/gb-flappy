INCLUDE "hardware.inc"
INCLUDE "src/utils/constants.inc"

SECTION "Gameplay Pipe Object Vars", WRAM0
wPipeX: dw
wPipeY:: db
wPipePlayerXCollision:: db

SECTION "Gameplay Pipe Object", ROM0
pipeTiles: INCBIN "src/gen/sprs/pipe.2bpp"
pipeTilesEnd:
pipeStraightTiles: INCBIN "src/gen/sprs/pipe_straight.2bpp"
pipeStraightTilesEnd:

pipeMetasprite:
    db 0 ,  0, 4 , 0
    db 0 ,  8, 6 , 0
    db 16, -8, 8 , 0
    db 0 ,  8, 10, 0
    db 16, -8, 8 , 0
    db 0 ,  8, 10, 0
    db 16, -8, 8 , 0
    db 0 ,  8, 10, 0
    db 16, -8, 8 , 0
    db 0 ,  8, 10, 0
    db 16, -8, 8 , 0
    db 0 ,  8, 10, 0
    db 128

pipeReverseMetasprite:
    db   0,  0, 4 , $40
    db   0,  8, 6 , $40
    db -16, -8, 8 , 0
    db   0,  8, 10, 0
    db -16, -8, 8 , 0
    db   0,  8, 10, 0
    db -16, -8, 8 , 0
    db   0,  8, 10, 0
    db -16, -8, 8 , 0
    db   0,  8, 10, 0
    db 128

; The pipe init loop
; @r16 de: trashed
; @r16 hl: trashed
; @r16 bc: trashed
; @r8 a: trashed
InitGameplayPipe::
    ld de, pipeTiles
    ld hl, vramGameplayPipeStart
    ld bc, pipeTilesEnd - pipeTiles
    call MemCopy

    ld de, pipeStraightTiles
    ld hl, vramGameplayPipeStraightStart
    ld bc, pipeStraightTilesEnd - pipeStraightTiles
    call MemCopy

InitGameplayPipe_RandomizeY:
    xor a
    ld [wPipeX], a

    ; ld a, 120
    call TryGenPipeY
    ld a, b
    ld [wPipeY], a

    ld a, %1010
    ld [wPipeX + 1], a

    ret

; The pipe update loop
; @r16 c: pipe y, trashed
; @r16 de: pipe x, trashed
; @r8 a: trashed
UpdateGameplayPipe::
    xor a
    ld [wPipePlayerXCollision], a

UpdateGameplayPipe_MovePipe:
    ld a, [wPipeX]
    sub PIPE_SPEED
    ld [wPipeX], a

    ld a, [wPipeX + 1]
    sbc 0
    ld [wPipeX + 1], a

; D: Y, E: X
UpdateGameplayPipe_DrawMetasprite:
    ld a, [wPipeX + 1]
    ld d, a
    ld a, [wPipeX]
    ld e, a

    srl b
    rr c
    srl b
    rr c
    srl b
    rr c
    srl b
    rr c

    srl d
    rr e
    srl d
    rr e
    srl d
    rr e
    srl d
    rr e

    ld a, [wPipeY]
    ld d, a
    ld [wMetaspriteY], a

    ld a, e
    ld [wMetaspriteX], a

    ld a, LOW(pipeMetasprite)
    ld [wMetaspriteLoc], a
    ld a, HIGH(pipeMetasprite)
    ld [wMetaspriteLoc + 1], a

    push de
    call DrawMetasprite
    pop de

    ld a, d
    sub PIPE_HEIGHT_DIFF
    ld [wMetaspriteY], a 

    ld a, e
    ld [wMetaspriteX], a

    ld a, LOW(pipeReverseMetasprite)
    ld [wMetaspriteLoc], a
    ld a, HIGH(pipeReverseMetasprite)
    ld [wMetaspriteLoc + 1], a

    push de
    call DrawMetasprite
    pop de

; D: Y, E: X
UpdateGameplayPipe_CheckPlayerCollision:
    ld a, [wPlayerX]
    add 16 - 4
    ld b, a

    ; Check for right side player collision to pipe
    ld a, e
    cp b
    call c, UpdateGameplayPipe_PlayerCollisionDetected

UpdateGameplayPipe_TryRandomizeY:
    ld a, e
    cp 220
    jp z, UpdateGameplayPipe_RandomizeY

    ret

UpdateGameplayPipe_RandomizeY:
    call TryGenPipeY
    ld a, b
    ld [wPipeY], a
    ret

UpdateGameplayPipe_PlayerCollisionDetected:
    ld a, 1
    ld [wPipePlayerXCollision], a
    ret

; Generates a random Pipe Y, where 72 < Y < 120
; @r8 b: Random Y
TryGenPipeY:
    call rand

    ld a, b
    cp 120
    jp nc, TryGenPipeY

    cp 72
    jp c, TryGenPipeY

    ret