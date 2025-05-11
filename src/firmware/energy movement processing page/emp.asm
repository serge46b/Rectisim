	asect 0x00
page_in_ctrl>
	rts
emp:
	ldi r0, 0x04
	ld r0, r3
move_cycle:
	jsr GLIO_restore_player_pos
	ldi r0, IO_BC_ctrl
	ldi r1, 0b10000000
	st r0, r1
	ldi r0, 0b00110000
	jsr IO_SPI_send_predef
	ldi r0, 0b00000001
	or r3, r0
	jsr GLIO_call_BC
	if
		ldi r1, 0b00000001
		and r0, r1
	is nz
		br move_cycle
	fi
	br page_rts

# ----------------
# Restores player position
# r3 - player
# Uses r0, r1, r2
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

IO_CSR: ext
IO_BC_ctrl: ext

IO_SPI_send_predef: ext

page_rts: ext
end