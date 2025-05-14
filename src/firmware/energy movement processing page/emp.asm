	asect 0x00
page_in_ctrl>
	rts
emp:
	ldi r0, 0x04
	ld r0, r3
	jsr GLIO_restore_player_pos
	ldi r0, IO_BC_ctrl
	ldi r1, 0b10000000
	st r0, r1
move_cycle:
	ldi r0, 0b00110000
	jsr IO_SPI_send_predef
	ldi r0, 0b00000001
	or r3, r0
	jsr GLIO_call_BC
	if
		ldi r1, 0b00000001
		and r0, r1
	is nz
		ldi r0, IO_Uni1
		ld r0, r1
		push r1
		dec r0
		ld r0, r1
		push r1
		ldi r0, 0b00000001
		ldi r1, 0b01000000
		jsr IO_SPI_send_cmd
		ldi r0, IO_Uni1
		ld r0, r0
		if
			ldi r1, 0x03
			cmp r0, r1
		is eq
			ldi r0, IO_Uni1-1
			pop r1
			st r0, r1
			inc r0
			pop r1
			st r0, r1
		else
			tst r1
			pop r1
			pop r2
			shr r1
			shr r2
			ldi r0, 0b11100000
			and r0, r2
			push r2
			push r1
			ldi r0, 0b00001000
			or r0, r2
			ldi r0, IO_Uni1-1
			st r0, r1
			inc r0
			st r0, r2
			ldi r0, 0b00111110
			jsr IO_SPI_send_predef
			ldi r0, IO_SPI_KBD_ctrl
			ldi r1, 0b00000100
			st r0, r1
			ldi r0, IO_Uni1-1
			pop r1
			st r0, r1
			inc r0
			pop r1
			ldi r2, 0b00001000
			or r2, r1
			st r0, r1
		fi
		ldi r0, 0b00111110
		jsr IO_SPI_send_predef
		ldi r0, IO_SPI_KBD_ctrl
		ldi r1, 0b00000100
		st r0, r1
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

IO_Uni1: ext
IO_CSR: ext
IO_BC_ctrl: ext
IO_SPI_KBD_ctrl: ext

IO_SPI_send_predef: ext
IO_SPI_send_cmd: ext

page_rts: ext
end