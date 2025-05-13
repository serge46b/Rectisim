	asect 0x00
page_in_ctrl>
	rts
task_assigning:
	ldi r2, IO_Uni1
	ldi r1, 0b00010100
	st r2, r1
	ldi r0, IO_UniCS
	ldi r1, 0b10000001
	st r0, r1
	ldi r0, IO_SPI_KBD_ctrl
	ldi r1, 0b01010100
	st r0, r1
	ldi r0, IO_UniCS
	clr r1
	st r0, r1
	ld r2, r2
	if
		ldi r1, 0b00010000
		cmp r2, r1
	is eq
		ldi r0, IO_DBG
		ldi r1, 0b10100101
		st r0, r1
		halt
	fi
	ldi r3, 0x04  # load adress (player select)
	ld r3, r3
	ldi r1, 0xfd  # increment = -3
	jsr inc_player_SP
	jsr get_stack_adress
	st r0, r2
	clr r1
	inc r0
	st r0, r1
	inc r0
	st r0, r1
	place_loop:
		jsr GLIO_restore_player_pos
		ldi r0, IO_BC_ctrl
		ldi r1, 0b10000000
		st r0, r1
		jsr get_player_SP_addr
		ld r0, r0
		jsr get_stack_adress
		push r0
		ldi r1, 0b00001000
		or r3, r1
		push r1
		push r3
		ldi r0, 0x01
		ldi r1, 0x05
		jsr page_call
		pop r3
		ldi r0, IO_BC_ctrl
		pop r1
		st r0, r1
		bnz cancel_task
		ldi r0, IO_SPI_KBD_ctrl
		ldi r1, 0b01000110
		or r3, r1
		st r0, r1
		if
			ldi r0, IO_Uni1
			ld r0, r0
			tst r0
		is nz
			br place_loop
		fi
		jsr IO_KBD_get
		ldi r0, IO_Uni1
		ld r0, r2
		if
			ldi r1, 0b00011111
			cmp r2, r1
		is ne
			if
				ldi r1, 0b00010100
				cmp r2, r1
			is ne
				br place_loop
			fi
			cancel_task:
				pop r0
				ldi r1, 0x03  # increment = 3
				jsr inc_player_SP
				jsr IO_clrCCS
				jsr send_accept_reject
				br page_rts
		fi
		pop r0
	ldi r2, IO_SPI_KBD_ctrl
	ldi r1, 0b00000011
	st r2, r1
	inc r0
	ldi r1, IO_CSR
	ld r1, r2
	st r0, r2
	inc r0
	inc r1
	ld r1, r2
	st r0, r2
	jsr IO_clrCCS
	ldi r0, 0x01
	jsr send_accept_reject
	br page_rts

# r0 - is accepted (0b00000001 - accepted, rejected otherwise)
# Uses r0, r1
send_accept_reject:
	ldi r1, 0b00010010
	or r0, r1
	ldi r0, IO_Uni1
	st r0, r1
	ldi r0, IO_UniCS
	ldi r1, 0b10000001
	st r0, r1
	ldi r0, IO_SPI_KBD_ctrl
	ldi r1, 0b00001100
	st r0, r1
	rts
	


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
IO_DBG: ext
IO_UniCS: ext
IO_Uni1: ext
IO_SPI_KBD_ctrl: ext
IO_BC_ctrl: ext

IO_KBD_get: ext
IO_clrCCS: ext

inc_player_SP: ext
get_player_SP_addr: ext
get_stack_adress: ext

page_call: ext
page_rts: ext
end