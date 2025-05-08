#$arch=hv
	rsect page_rts
# Use with br ONLY
page_rts>
	pop r1
	ldi r0, 0xf7
	st r0, r1
	br page_in_ctrl
page_in_ctrl: ext
end