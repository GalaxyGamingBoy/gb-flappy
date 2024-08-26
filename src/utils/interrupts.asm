INCLUDE "hardware.inc"

SECTION "Interrups", ROM0
; Disables Interrupts
; @r8 a - trashed
DisableInterrupts::
    xor a
    ldh [rSTAT], a
    di
    ret

; Enables Interrupts
; @r8 a - trashed
EnableStatInterrupts::
    ; Enable Interrupts
    ld a, IEF_STAT
    ldh [rIE], a

    ; Disable Interrupt Flag
    xor a
    ldh [rIF], a
    ei

    ; LY = LYC interrupt
    ld a, STATF_LYC
    ldh [rSTAT], a

    ; Reset LYC
    xor a
    ldh [rLYC], a
    ret

SECTION "Stat Interrupts", ROM0[$0048]
StatInterrupts:
    push af
    ; INTERRUPT CODE
    pop af
    reti