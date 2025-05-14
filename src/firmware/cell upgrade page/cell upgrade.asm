	asect 0x00
page_in_ctrl>
	rts
cell_upgrade:
	ldi r0, IO_Uni1
	ldi r1, 0x03
	st r0, r1
	ldi r3, 0x04
	ld r3, r3
	jsr GLIO_restore_player_pos
	ldi r0, IO_BC_ctrl
	ldi r1, 0b10000000
	st r0, r1
	ldi r1, IO_UniCS
	clr r0
	st r1, r0
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00000101
	or r3, r1
	st r0, r1
	ld r0, r0
	
	ldi r1, 0b00000001
	and r0, r1
	bnz page_rts
	
	ldi r2, IO_Uni1
	ldi r0, 0b00000001
	jsr IO_KBD_get
	
	jsr IO_clrCCS
	ldi r3, IO_BC_ctrl
	ldi r1, 0b00001000
	st r3, r1
	ld r2, r3

	dec r2
	ld r2, r0
	push r0
	inc r2
	ld r2, r0
	push r0
	ldi r1, 0b00011000
	or r0, r1
	st r2, r1
	
	ldi r1, IO_UniCS
	ldi r0, 0b10000001
	st r1, r0
	
	ldi r1, IO_SPI_KBD_ctrl
	ldi r0, 0b01000100
	st r1, r0
	ld r2, r0
	tst r0
	bnz cell_upgrade
	
	ldi r1, IO_UniCS
	clr r0
	st r1, r0
	ldi r0, IO_BC_ctrl
	clr r1
	st r0, r1
	ldi r0, IO_SPI_KBD_ctrl
	ldi r1, 0b00111110
	st r0, r1
	pop r0
	ldi r1, 0b00001000
	or r1, r0
	st r2, r0
	pop r1
	dec r2
	st r2, r1
	ldi r0, IO_SPI_KBD_ctrl
	ldi r1, 0b00000100
	st r0, r1
	clr r0
	br page_rts


GLIO_restore_player_pos:
	if
		ldi r1, 0b00010000
		and r3, r1
	is nz
		clr r0  # load adress (player 1 CSC)
	else
		ldi r0, 0x02  # load adress (player 2 CSC)
	fi
	ld r0, r1
	inc r0
	ld r0, r2
	ldi r0, IO_CSR
	st r0, r2
	inc r0
	st r0, r1
	rts

IO_CSR: ext
IO_Uni1: ext
IO_UniCS: ext
IO_BC_ctrl: ext
IO_SPI_KBD_ctrl: ext

IO_KBD_get: ext
IO_clrCCS: ext

page_rts: ext	
end