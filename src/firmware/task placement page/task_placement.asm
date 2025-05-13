	asect 0x00
page_in_ctrl>
	rts
task_placement:
	ldi r3, 0x04  # load adress (player select)
	ld r3, r3
	ldi r0, IO_Uni1
	ldi r1, 0x03
	st r0, r1
	ldi r0, IO_BC_ctrl
	ldi r1, 0b00000110
	or r3, r1
	st r0, r1
	ld r0, r0
	if
		ldi r1, 0b00000101
		and r0, r1
	is nz
		br page_rts
	fi
	place_loop:
		ldi r3, 0x04  # load adress (player select)
		ld r3, r3
		clr r0
		jsr IO_KBD_get
		ldi r0, IO_Uni1
		ld r0, r2
		if
			ldi r1, 0b00010100
			cmp r2, r1
		is eq
			br task_placement
		fi
		if
			ldi r0, 0b11101100
			and r2, r0
		is nz
			br place_loop
		fi
		if
			ldi r0, 0b00000011
			and r0, r2
			move r2, r1
			ldi r0, 0b00000010
			cmp r2, r0
		is eq, or
			dec r0
			cmp r2, r0
		is eq
		then
			jsr prepare_horizontal_cnt
			ldi r0, IO_CSC
			ld r0, r0
			move r0, r3
			while
				tst r1
			stays nz
				dec r1
				if
					if
						dec r2
					is z
						shla r3
					else
						tst r0
						shr r3
					fi
				is cs
					br place_loop
				fi
				inc r2
				or r3, r0
			wend
			ldi r2, IO_CSC
			st r2, r0
			clr r2
			br place_adj
		else
			move r1, r2
			jsr prepare_horizontal_cnt
			ldi r0, IO_CSR
			ld r0, r0
			move r0, r3
			while
				tst r1
			stays nz
				dec r1
				if
					if
						dec r2
					is cc
						shla r3
					else
						tst r0
						shr r3
					fi
				is cs
					br place_loop
				fi
				inc r2
				or r3, r0
			wend
			ldi r2, IO_CSR
			st r2, r0
			ldi r2, 0x01
		fi
	place_adj:
		ldi r3, 0x04
		ld r3, r3
		jsr prepare_vertical_cnt
		move r1, r3
		ldi r0, 0b00000001
		jsr IO_KBD_get
		ldi r0, IO_Uni1
		ld r0, r0
		tst r0
		shr r0
		shra r0
		shra r0
		shra r0
		shra r0
		move r3, r1
		if
			cmp r0, r1
		is hi
			br place_adj
		fi
		ldi r3, IO_CSR
		if
			tst r2
		is nz
			inc r3
		fi
		ld r3, r3
		while
			tst r0
		stays nz
			if
				shla r3
			is cs
				br place_loop
			fi
			dec r0
		wend
		move r3, r0
		while
			tst r1
		stays nz
			if
				shr r0
			is cs
				br place_loop
			fi
			or r0, r3
			dec r1
		wend
		ldi r0, IO_CSR
		if
			tst r2
		is nz
			inc r0
		fi
		st r0, r3
	br page_rts

prepare_horizontal_cnt:
	jsr prepare_stack
	ldi r1, 0b00001100
	and r0, r1
	shr r1
	shra r1
	rts

prepare_vertical_cnt:
	jsr prepare_stack
	ldi r1, 0b00000011
	and r0, r1
	rts

prepare_stack:
	jsr get_player_SP_addr
	ld r0, r0
	jsr get_stack_adress
	ld r0, r0
	rts


IO_CSC: ext
IO_CSR: ext
IO_BC_ctrl: ext
IO_Uni1: ext

IO_KBD_get: ext

get_player_SP_addr: ext
get_stack_adress: ext

page_rts: ext
end