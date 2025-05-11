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
	ldi r0, 0x01
	ldi r1, 0x05
	jsr page_call
	ldi r3, 0x04  # load adress (player select)
	ld r3, r3
	jsr get_player_SP_addr
	ld r0, r0
	jsr get_stack_adress
	if
		inc r0
		ld r0, r0
		tst r0
		ldi r0, IO_UniCS
		ldi r1, 0b10000001
		st r0, r1
	is z
		ldi r1, 0x03  # increment = 3
		jsr inc_player_SP
		ldi r2, IO_Uni1
		ldi r1, 0b00010010
		st r2, r1
		ldi r0, IO_SPI_KBD_ctrl
		ldi r1, 0b00001100
		st r0, r1
		br page_rts
	fi
	ldi r2, IO_Uni1
	ldi r1, 0b00010011
	st r2, r1
	ldi r0, IO_SPI_KBD_ctrl
	ldi r1, 0b00001100
	st r0, r1
	br page_rts
	
	

IO_DBG: ext
IO_UniCS: ext
IO_Uni1: ext
IO_SPI_KBD_ctrl: ext

inc_player_SP: ext
get_player_SP_addr: ext
get_stack_adress: ext

page_call: ext
page_rts: ext
end