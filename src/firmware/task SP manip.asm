	rsect get_player_SP
# Get player SP adress
# r3 - player
# Uses r0
# stores result in r0
get_player_SP_addr>
	if
		ldi r0, 0b00010000
		and r3, r0
	is nz
		ldi r0, 0x1f  # load adress (player 1 task SP)
	else
		ldi r0, 0x2f  # load adress (player 2 task SP)
	fi
	rts

# Get player SP
# r1 - increment
# r3 - player
# Uses r0, r1
# stores result in r0
inc_player_SP>
	jsr get_player_SP_addr
	push r0
	ld r0, r0
	add r1, r0
	pop r1
	st r1, r0
	rts

# ----------------
# Get stack memory adress
# r0 - SP
# r3 - player
# Uses r0
# stores result in r0
#	rsect get_stack_adress
#get_stack_adress>
#	add r3, r0
#	rts
end