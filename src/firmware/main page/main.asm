	asect 0x00
page_in_ctrl>
	if
		ldsp r0
		tst r0
	is nz
		rts
	fi
main:
	addsp -9
	ldi r0, 0x01
	ldi r1, 0x01
	jsr page_call
	halt
page_call: ext
end