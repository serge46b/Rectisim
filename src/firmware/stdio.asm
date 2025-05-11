	asect 0xf8
IO_BC_ctrl> ds 1
IO_DBG> ds 1
IO_Uni2> ds 1
IO_Uni1> ds 1
IO_SPI_KBD_ctrl> ds 1
IO_UniCS> ds 1
IO_CSR> ds 1
IO_CSC> ds 1
# ----------------
# Uses r0, r1
	rsect IO_clrCCS
IO_clrCCS>
	ldi r0, IO_CSR
	ldi r1, 0x00
	st r0, r1
	inc r0
	st r0, r1
	rts
# ----------------
# Uses r0, r1
	rsect IO_CCS_reset
IO_CCS_reset>
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00001000
	st r0, r1
	clr r1
	st r0, r1
	rts
# ----------------
# r0 - contains command (example: 0b00010000 - reset cell state)
# r1 - contains a mask of operation: 0b0x00000y:
# 	If x - MCU will receive 2 bits;
# 	if y - additional 2 bits will be sent, nothing received;
#	If x and y - additional 2 bits will be sent and 1 bit received.
# Uses r0, r1
# stores return value in r0
	rsect IO_SPI_send_cmd
IO_SPI_send_cmd>
	push r1
	push r0
	ldi r0, 0b00111000
	jsr IO_SPI_send_predef
	pop r0
	ldi r1, IO_Uni1
	st r1, r0
	pop r0
	ldi r1, 0b00001100
	or r0, r1
	ldi r0, IO_SPI_KBD_ctrl
	st r0, r1
	ldi r0, IO_Uni1
	ld r0, r0
	rts
# r0 - contains mask for predefined command (example: 0b00101000 - start of transanction)
# Uses r0, r1
IO_SPI_send_predef>
	ldi r1, 0b00000110
	or r0, r1
	ldi r0, IO_SPI_KBD_ctrl
	st r0, r1
	rts
end