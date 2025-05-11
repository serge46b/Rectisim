	asect 0x00
page_in_ctrl>
	rts
cycle_start:
	ldi r0, 0x04  # load adress (player select)
	ldi r3, 0b00010000
	st r0, r3
game_cycle:
	jsr IO_clrCCS
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00001000
	st r0, r1
	jsr get_player_SP_addr
	ld r0, r0
	if
		tst r0
	is nz
		ldi r1, 0b00000001
		jsr GLIO_send_game_phase
		ldi r0, 0x01
		ldi r1, 0x04
		jsr page_call
		ldi r3, 0x04
		ld r3, r3
	fi
	ldi r1, 0b00000010
	jsr GLIO_send_game_phase
	ldi r0, 0x01
	ldi r1, 0x03
	jsr page_call
	
	jsr IO_clrCCS
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00001000
	st r0, r1
	ldi r1, 0b00001100
	jsr GLIO_send_game_phase
	ldi r0, IO_CSR
	ldi r1, 0xff
	st r0, r1
	inc r0
	st r0, r1
	ldi r2, 0x04  # load adress (player select)
	ld r2, r0
	ldi r1, 0b00001000
	or r1, r0
	jsr IO_SPI_send_predef
	ldi r0, 0b00000011
	jsr GLIO_call_BC
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00001000
	st r0, r1
	ld r0, r0
	if
		ldi r1, 0b00000010
		cmp r0, r1
	is eq
		br page_rts
	fi
	jsr get_player_SP_addr
	ld r0, r0
	if
		ldi r1, 0x0f
		cmp r0, r1
	is ne
		ldi r3, 0x04
		ld r3, r3
		ldi r1, 0b00000011
		jsr GLIO_send_game_phase
		ldi r0, 0x01
		ldi r1, 0x06
		jsr page_call
	fi
	ldi r2, 0x04  # load adress (player select)
	ld r2, r3
	ldi r0, 0b00110000
	xor r0, r3
	st r2, r3
	br game_cycle

# Sends game phase to people_controller
# r3 - stores player
# r1 - stores mode (example: 0b00000010)
# Uses r0, r1, r2
GLIO_send_game_phase:
	move r3, r0
	shr r0
	shr r0
	or r1, r0
	ldi r1, IO_Uni1
	st r1, r0
	ldi r2, IO_UniCS
	ldi r1, 0b10000010
	st r2, r1
	ldi r0, IO_SPI_KBD_ctrl
	ldi r1, 0b00001100
	st r0, r1
	clr r1
	st r2, r1
	rts

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

IO_BC_ctrl: ext
IO_Uni1: ext
IO_UniCS: ext
IO_CSR: ext
IO_SPI_KBD_ctrl: ext
IO_SPI_send_predef: ext
IO_clrCCS: ext

page_rts: ext
page_call: ext

get_player_SP_addr: ext
end