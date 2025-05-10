	asect 0x00
page_in_ctrl>
	rts
game_init:
	ldi r0, IO_DBG
	ldi r1, 0b00000001
	st r0, r1
	ldi r0, IO_CSR
	ldi r1, 0xff
	st r0, r1
	inc r0
	st r0, r1
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00001000
	st r0, r1
	ldi r0, 0b00111000
	jsr IO_SPI_send_predef
	ldi r0, IO_UniCS
	ldi r1, 0b10000011
	st r0, r1
	ldi r0, IO_Uni1
	ldi r1, 0b00010000
	st r0, r1
	ldi r0, IO_SPI_KBD_ctrl
	ldi r1, 0b00001100
	st r0, r1
	jsr IO_clrCCS
	ldi r0, IO_UniCS
	clr r1
	st r0, r1
	ldi r3, 2
	player_select:
		dec r3
		jsr IO_CCS_reset
		ldi r0, 0b00110000
		jsr IO_SPI_send_predef
		ldi r0, IO_BC_ctrl
		ldi r1, 0b00000100
		st r0, r1
		jsr IO_CCS_reset
		ldi r0, 0b00111000
		jsr IO_SPI_send_predef
		ldi r0, IO_BC_ctrl
		if
			tst r3
		is nz
			ldi r1, IO_CSC
			ld r1, r1
			clr r2  # load adress (player 1 CSC)
			st r2, r1
			ldi r1, IO_CSR
			ld r1, r1
			inc r2  # load adress (player 1 CSR)
			st r2, r1
			ldi r2, 0b01010000
			ldi r1, 0b01000000
		else
			ldi r2, 0b01100000
			ldi r1, 0b10000000
		fi
		st r0, r2	
		ldi r0, IO_Uni2
		st r0, r1
		inc r0
		ldi r1, 0b00001011
		st r0, r1
		ldi r0, IO_SPI_KBD_ctrl
		ldi r1, 0b00001101
		st r0, r1
		jsr IO_CCS_reset
		ldi r0, 0b00111000
		jsr IO_SPI_send_predef
		ldi r0, IO_Uni1
		ldi r1, 0b11101000
		st r0, r1
		dec r0
		clr r1
		st r0, r1
		ldi r0, IO_SPI_KBD_ctrl
		ldi r1, 0b00000100
		st r0, r1
		tst r3
		bnz player_select
	ldi r0, IO_DBG
	ldi r1, 0b00000010
	st r0, r1
	clr r0  # load adress (player 1 CSC)
	ld r0, r1
	ldi r0, IO_CSC
	ld r0, r2
	st r0, r1
	ldi r0, 0x02  # load adress (player 2 CSC)
	st r0, r2
	ldi r0, 0x01  # load adress (player 1 CSR)
	ld r0, r1
	ldi r0, IO_CSR
	ld r0, r2
	st r0, r1
	ldi r0, 0x03  # load adress (player 2 CSR)
	st r0, r2	
	ldi r0, IO_BC_ctrl
	ldi r1, 0b10000000
	st r0, r1
	ldi r0, IO_BC_ctrl
	clr r1
	st r0, r1
	ldi r0, 0x0a  # load adress (player 1 task SP)
	ldi r1, 0x05
	st r0, r1
	ldi r0, 0x10  # load adress 0x00 (player 2 task SP)
	st r0, r1
	br page_rts


	
IO_DBG: ext
IO_CSR: ext
IO_CSC: ext
IO_BC_ctrl: ext
IO_Uni1: ext
IO_Uni2: ext
IO_SPI_KBD_ctrl: ext
IO_UniCS: ext

IO_SPI_send_predef: ext
IO_clrCCS: ext
IO_CCS_reset: ext

page_rts: ext
end