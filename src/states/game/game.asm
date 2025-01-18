INCLUDE "hardware.inc"
INCLUDE "src/utils/constants.inc"

SECTION "Game Vars", WRAM0

SECTION "Game", ROM0
gameplayBackground: INCBIN "src/gen/bgs/gameplay.2bpp"
gameplayBackgroundEnd:

gameplayBackgroundTilemap: INCBIN "src/gen/bgs/gameplay.tilemap"
gameplayBackgroundTilemapEnd:

InitGameState::
    ld bc, gameplayBackgroundEnd - gameplayBackground
    ld de, gameplayBackground
    ld hl, vramTilesGameplayBackground
    call MemCopy

    ld bc, gameplayBackgroundTilemapEnd - gameplayBackgroundTilemap
    ld de, gameplayBackgroundTilemap
    ld hl, _SCRN0
    call MemCopy

    call InitGameplayPlayer
    call InitGameplayPipe

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG9800 | LCDCF_OBJON | LCDCF_OBJ16
    ld [rLCDC], a

LoopGameState:
    ld a, [wCurKeys]
    ld [wLastKeys], a
    call Input

    call ResetShadowOAM
    call ResetOAMSpriteAddr

    call UpdateGameplayPlayer
    call UpdateGameplayPipe

    ld a, [wPipePlayerXCollision]
    ld b, a
    ld a, [wPipePlayerYCollision]

    and b
    jp nz, ToGameoverGameState

    call WaitForOneVBlank
    ld a, HIGH(wShadowOAM)
    call hOAMDMA
    call WaitForOneVBlank

    jp LoopGameState

ToGameoverGameState::
    ld a, 0
    ld [wGameState], a
    jp NextGameState