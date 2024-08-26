INCLUDE "hardware.inc"

SECTION "Sprites Vars", WRAM0
wLastOAMAddr:: db

SECTION "Sprites", ROM0

; Clears all of the sprite
; @r8 a   - trashed
; @r8 b   - trashed | OAM Length
; @r16 hl - trashed | Shadow OAM location
ClearAllSprites::
    ld b, OAM_COUNT * 4
    ld hl, wShadowOAM
    xor a

ClearAllSprites_Loop:
    ld [hli], a

    dec b
    jp nz, ClearAllSprites_Loop

    ld a, HIGH(wShadowOAM)
    jp hOAMDMA

; Clears the remaining sprites
; @r8 a   - trashed
; @r16 hl - OAM Address
ClearRemainingSprites::
ClearRemainingSprites_Loop:
    ld a, [wLastOAMAddr]
    ld l, a
    ld h, HIGH(wShadowOAM)

    ld a, l
    cp 160
    ret nc

    xor a
    ld [hli], a
    ld [hld], a

    ld a, l
    add 4
    ld l, a

    call NextOAMSprite
    jp ClearAllSprites_Loop

; Resets the OAM address
; @r8 a - trashed
ResetOAMSpriteAddr::
    ld a, LOW(wShadowOAM)
    ld [wLastOAMAddr], a
    ret

; Proceeds to the next OAM sprite
; @r8 a - trashed
NextOAMSprite::
    ld a, [wLastOAMAddr]
    add 4
    ld [wLastOAMAddr], a
    ret