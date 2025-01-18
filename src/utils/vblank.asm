INCLUDE "hardware.inc"

SECTION "VBlank Vars", WRAM0
wVBlankCount:: db

SECTION "VBlank", ROM0
; Waits for one vblank period
; @r8 a - trashed
WaitForOneVBlank::
    ld a, 1
    ld [wVBlankCount], a

; Waits for $wVBlankCount period(s)
; @r8 a - trashed
WaitForVBlank::
WaitForVBlank_Loop:
    ld a, [rLY]
    cp 144
    jp c, WaitForVBlank_Loop

    ld a, [wVBlankCount]
    dec a
    ld [wVBlankCount], a
    
    ret z

WaitForVBlank_Loop_DuringVBlank:
    ld a, [rLY]
    cp 144
    jp nc, WaitForVBlank_Loop_DuringVBlank
    jp WaitForVBlank_Loop