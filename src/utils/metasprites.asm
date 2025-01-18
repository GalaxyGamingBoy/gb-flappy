INCLUDE "src/utils/constants.inc"
INCLUDE "hardware.inc"

SECTION "Metasprites Utils Vars", WRAM0
wMetaspriteLoc:: dw 
wMetaspriteY:: db
wMetaspriteX:: db

SECTION "Metasprites Utils", ROM0
; Draws a metasprite
; @r8 a  - trashed
; @r8 hl - metasprite definition location, OAM location, trashed
; @r8 b  - sprite y position, trashed
; @r8 c  - sprite x position, trashed
; @r8 d  - sprite tile, trashed
; @r8 e  - sprite attributes, trashed
DrawMetasprite::
    ld a, [wMetaspriteLoc]
    ld l, a
    ld a, [wMetaspriteLoc + 1]
    ld h, a

    ; Load spr y into b
    ld a, [hli]
    ld b, a

    ; If y is 128, return
    cp 128
    ret z

    ; Increment metasprite y by b
    ld a, [wMetaspriteY]
    add b
    ld [wMetaspriteY], a

    ; Load spr x into c
    ld a, [hli]
    ld c, a

    ; Increment metasprite x by c
    ld a, [wMetaspriteX]
    add c
    ld [wMetaspriteX], a

    ; Load spr tile into d
    ld a, [hli]
    ld d, a

    ; Load spr attributes into 
    ld a, [hli]
    ld e, a

    ; Load OAM address
    ld a, [wLastOAMAddr]
    ld l, a
    ld h, HIGH(wShadowOAM)

    ; Write OAM data
    ld a, [wMetaspriteY]
    ld [hli], a
    ld a, [wMetaspriteX]
    ld [hli], a
    ld a, d
    ld [hli], a
    ld a, e
    ld [hl], a
    call NextOAMSprite

    ; Go to next metasprite
    ld a, [wMetaspriteLoc]
    add 4
    ld [wMetaspriteLoc], a

    ld a, [wMetaspriteLoc + 1]
    adc 0
    ld [wMetaspriteLoc + 1], a

    jp DrawMetasprite
