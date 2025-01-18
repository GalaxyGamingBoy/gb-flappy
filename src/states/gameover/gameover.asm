INCLUDE "hardware.inc"
INCLUDE "src/utils/constants.inc"

SECTION "Gameover", ROM0
gameoverBackground:: INCBIN "src/gen/bgs/gameover.2bpp"
gameoverBackgroundEnd::

gameoverBackgroundTilemap:: INCBIN "src/gen/bgs/gameover.tilemap"
gameoverBackgroundTilemapEnd::

InitGameoverState::
    ld bc, gameoverBackgroundEnd - gameoverBackground
    ld de, gameoverBackground
    ld hl, vramTilesGameplayBackground
    call MemCopy

    ld bc, gameoverBackgroundTilemapEnd - gameoverBackgroundTilemap
    ld de, gameoverBackgroundTilemap
    ld hl, _SCRN0
    call MemCopy

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG9800
    ld [rLCDC], a

LoopGameoverState::
    ld a, [wCurKeys]
    ld [wLastKeys], a

    call Input

    ld a, [wCurKeys]
    ld b, a
    ld a, [wLastKeys]
    and a, b

    ld a, GAME_STATE
    ld [wGameState], a
    jp nz, NextGameState

    jp LoopGameoverState