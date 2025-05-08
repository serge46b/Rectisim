#$arch=hv
	rsect page_call
# Reads jump adress from r0 and jump page from r1
page_call>
	clr r2
	push r2
	ldi r3, 0xf7
	ld r3, r2
	st r3, r1
	ldsp r3
	push r2
	jsr get_jump_adress
	st r3, r1
	push r0
	br page_in_ctrl
	rts
get_jump_adress:
	ldsp r1
	ld r1, r1
	ldi r2, 0x04
	add r2, r1
	rts
page_in_ctrl: ext
end