INCLUDE "hardware.inc"

SECTION "Background", ROM0

; Clears the background tilemap
; @r8 a   - trashed
; @r16 bc - trashed
; @r16 hl - trashed
ClearBackground::
    xor a
    ld [rLCDC], a

    ld bc, $400
    ld hl, _SCRN0

ClearBackground_Loop:
    xor a
    ld [hli], a

    dec bc
    ld a, b
    or a, c
    jp nz, ClearBackground_Loop

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ld [rLCDC], a
    
    ret