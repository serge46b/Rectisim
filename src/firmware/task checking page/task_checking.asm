	asect 0x00
page_in_ctrl>
	rts
task_checking:
	ldi r3, 0x04
	ld r3, r3
	jsr get_player_SP_addr
	ld r0, r0
	add r3, r0
	push r0
	move r0, r3
	check_loop:
		if
			ldi r0, 0x1f
			cmp r0, r3
		is eq, or
			ldi r0, 0x2f
			cmp r0, r3
		is eq
		then
			br loop_end
		fi
		move r3, r0
		inc r0
		ld r0, r1
		ldi r2, IO_CSR
		st r2, r1
		inc r0
		inc r2
		ld r0, r0
		st r2, r0
		ldi r0, IO_BC_ctrl
		ldi r1, 0x04  # loads adress (player select)
		ld r1, r1
		ldi r2, 0b00001000
		or r2, r1
		st r0, r1
		ld r0, r0
		if
			ldi r1, 0b00000010
			and r0, r1
		is nz
			ldi r0, 0b00001000
			jsr IO_SPI_send_predef
			ld r3, r0
			ldi r1, IO_Uni1
			st r1, r0
			ldi r1, IO_UniCS
			ldi r0, 0b10000001
			st r1, r0
			ldi r0, IO_SPI_KBD_ctrl
			ldi r1, 0b00001100
			st r0, r1
			move r3, r0
			pop r1
			push r1
			ldi r2, 0x04
			if
				cmp r1, r0
			is ne
				while
					dec r2
				stays nz
					push r2
					ld r0, r2
					st r1, r2
					clr r2
					st r0, r2
					inc r0
					inc r1
					pop r2
				wend
			else
				while
					dec r2
				stays nz
					clr r0
					st r1, r0
					inc r1
				wend
			fi
			push r3
			ldi r3, 0x04
			ld r3, r3
			ldi r1, 0x03
			jsr inc_player_SP
			pop r3
		fi
		inc r3
		inc r3
		inc r3
	br check_loop
loop_end:
	pop r0
	jsr IO_clrCCS
upgrade_loop:
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00001000
	st r0, r1
	ldi r1, IO_UniCS
	ldi r0, 0b10000001
	st r1, r0
	ldi r0, 0b01000000
	jsr IO_SPI_send_predef

	ldi r2, IO_Uni1
	ld r2, r0
	tst r0
	bz page_rts
	
	ldi r0, 0x01
	ldi r1, 0x07
	jsr page_call
	br upgrade_loop


IO_UniCS: ext
IO_Uni1: ext
IO_CSR: ext
IO_BC_ctrl: ext
IO_SPI_KBD_ctrl: ext

IO_SPI_send_predef: ext
IO_clrCCS: ext

get_player_SP_addr: ext
inc_player_SP: ext

page_rts: ext
page_call: ext
end