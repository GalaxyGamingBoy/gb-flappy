SECTION "Memory Utils", ROM0

; Copies memory from source to destination
; @r8 a  - trashed
; @r8 de - source, trashed
; @r8 hl - destination, trashed
; @r8 bc - size, trashed
MemCopy::
    ld a, [de]
    ld [hli], a

    inc de
    dec bc

    ld a, b
    or a, c
    jp nz, MemCopy

    ret