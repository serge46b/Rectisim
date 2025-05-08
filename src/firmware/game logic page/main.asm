	asect 0x00
page_in_ctrl>
	rts
cycle_start:
	ldi r0, 0x04
	ldi r1, 0b00010000
	st r0, r1
game_cycle:
	if
		ldi r0, 0b00010000
		and r1, r0
	is nz
		clr r0
	else
		ldi r0, 0x02
	fi
	jsr GLIO_restore_player_pos
	ldi r0, IO_BC_ctrl
	ldi r1, 0b10000000
	st r0, r1
	ldi r0, 0b00110000
	jsr IO_SPI_send_predef
	ldi r0, 0x04
	ld r0, r0
	ldi r1, 0b00000001
	or r1, r0
	jsr GLIO_call_BC
	if
		tst r0
	is nz
		br page_rts
	fi
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00001000
	st r0, r1
	ldi r0, IO_CSR
	clr r1
	st r0, r1
	ldi r1, 0xff
	st r0, r1
	inc r0
	st r0, r1
	ldi r2, 0x04
	ld r2, r0
	ldi r1, 0b00001000
	or r1, r0
	jsr IO_SPI_send_predef	
	ldi r0, 0b00000011
	jsr GLIO_call_BC
	ld r2, r1
	ldi r0, 0b00110000
	xor r0, r1
	st r2, r1
	br game_cycle
	
# Calls for basic controller
# r0 - contains BC mode
# Uses r0, r1
# Stores return result in r0
GLIO_call_BC:
	ldi r1, 0b00000100
	or r0, r1
	ldi r0, IO_BC_ctrl
	st r0, r1
	ld r0, r0
	rts
# ----------------
# Reads both Uni registers
# Stores return result in r0 (Uni1) and r1 (Uni2)
GLIO_read_all_uni:
	ldi r0, IO_Uni2
	ld r0, r1
	inc r0
	ld r0, r0
	rts
# ----------------
# Restores player position
# r0 - where player position stored (player position takes 2 bytes, so r0 should point to the least byte)
# Uses r0, r1, r2
GLIO_restore_player_pos:
	ld r0, r1
	inc r0
	ld r0, r2
	ldi r0, IO_CSR
	st r0, r2
	inc r0
	st r0, r1
	rts

IO_BC_ctrl: ext
IO_Uni2: ext
IO_CSR: ext

IO_SPI_send_predef: ext

page_rts: ext
end