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
	ldi r0, 0b00101000
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
	ldi r3, 2
	player_select:
		dec r3
		jsr IO_CCS_reset
		ldi r0, 0b00100000
		jsr IO_SPI_send_predef
		ldi r0, IO_BC_ctrl
		ldi r1, 0b00000100
		st r0, r1
		jsr IO_CCS_reset
		ldi r0, 0b00101000
		jsr IO_SPI_send_predef
		st r0, r1
		ldi r0, IO_BC_ctrl
		if
			tst r3
		is nz
			ldi r1, IO_CSC
			ld r1, r1
			clr r2
			st r2, r1
			ldi r1, IO_CSR
			ld r1, r1
			inc r2
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
		ldi r0, 0b00001011
		ldi r1, 0b00000001
		jsr IO_SPI_send_cmd
		jsr IO_CCS_reset
		ldi r0, 0b00101000
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
IO_SPI_send_cmd: ext
IO_clrCCS: ext
IO_CCS_reset: ext

page_rts: ext
end