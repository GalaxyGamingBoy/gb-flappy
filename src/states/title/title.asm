INCLUDE "hardware.inc"
INCLUDE "src/utils/constants.inc"

SECTION "Title", ROM0
titleBackground:: INCBIN "src/gen/bgs/title.2bpp"
titleBackgroundEnd::

titleBackgroundTilemap:: INCBIN "src/gen/bgs/title.tilemap"
titleBackgroundTilemapEnd::

InitTitleState::
    ld bc, titleBackgroundEnd - titleBackground
    ld de, titleBackground
    ld hl, vramTilesGameplayBackground
    call MemCopy

    ld bc, titleBackgroundTilemapEnd - titleBackgroundTilemap
    ld de, titleBackgroundTilemap
    ld hl, _SCRN0
    call MemCopy

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG9800
    ld [rLCDC], a

LoopTitleState::
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

    jp LoopTitleState