# LAB
# Challenge 4.4 Sound Effects (+music)

.data
	snake:			.space 1024	# Array size 10 words basically
	snake_length:	.word 3		# snake length including head (makes life easier). starts at 2
	head_x:			.word 16	# x, y coords for head
	head_y:			.word 16
	vel_x:			.word 1
	vel_y:			.word 0

	black_color: 	.word 0x00000000
	border_color:	.word 0x000000FF
	snake_color:	.word 0x0000FF00
	snake_head_color:	.word 0x00FCBC3D
	apple_color:	.word 0x00FF0000
	text_color:		.word 0x00BBBBBB
	
	screen:			.word 0x10040000	# screen address
	input:			.word 0xFFFF0000
	input_data:		.word 0xFFFF0004
	
	bytes_per_row:	.word 128
	total_bytes:	.word 4096
	
	difficulty_ms:	.word 0

	game_over_str:	.asciz "game over\n"
	score_str:		.asciz "SCORE: "
	newline:		.asciz "\n"

# Music that plays during the game.
melody:
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  76,  17,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  40,  33,   0

	.byte 0xFE,  17,   0
	.byte  78,  17,   0

	.byte 0xFE,  17,   0
	.byte  79,  17,   0
	.byte  47,  33,   0

	.byte 0xFE,  17,   0
	.byte  78,  17,   0

	.byte 0xFE,  17,   0
	.byte  76,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  76,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  75,  33,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  72,  67,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  67,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  69,  17,   0
	.byte  60, 133,   0
	.byte  57, 133,   0
	.byte  52, 133,   0
	.byte  36,  33,   0

	.byte 0xFE,  17,   0
	.byte  71,  17,   0

	.byte 0xFE,  17,   0
	.byte  72,  17,   0
	.byte  45,  33,   0

	.byte 0xFE,  17,   0
	.byte  71,  17,   0

	.byte 0xFE,  17,   0
	.byte  69,  33,   0
	.byte  36,  33,   0

	.byte 0xFE,  33,   0
	.byte  64,  33,   0
	.byte  45,  33,   0

	.byte 0xFE,  33,   0
	.byte  60, 133,   0
	.byte  57, 133,   0
	.byte  52, 133,   0
	.byte  36,  33,   0

	.byte 0xFE,  33,   0
	.byte  45,  33,   0

	.byte 0xFE,  33,   0
	.byte  36,  33,   0

	.byte 0xFE,  33,   0
	.byte  64,  33,   0
	.byte  45,  33,   0

	.byte 0xFE,  33,   0
	.byte  65,  67,   0
	.byte  59, 133,   0
	.byte  53, 133,   0
	.byte  50, 133,   0
	.byte  38,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  64,  33,   0
	.byte  38,  33,   0

	.byte 0xFE,  33,   0
	.byte  63,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  64,  33,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  56, 133,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  76,  17,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  40,  33,   0

	.byte 0xFE,  17,   0
	.byte  78,  17,   0

	.byte 0xFE,  17,   0
	.byte  79,  17,   0
	.byte  47,  33,   0

	.byte 0xFE,  17,   0
	.byte  78,  17,   0

	.byte 0xFE,  17,   0
	.byte  76,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  76,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  75,  33,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  72,  67,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  67,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  69,  17,   0
	.byte  60, 133,   0
	.byte  57, 133,   0
	.byte  52, 133,   0
	.byte  40,  33,   0

	.byte 0xFE,  17,   0
	.byte  71,  17,   0

	.byte 0xFE,  17,   0
	.byte  72,  17,   0
	.byte  48,  33,   0

	.byte 0xFE,  17,   0
	.byte  71,  17,   0

	.byte 0xFE,  17,   0
	.byte  69,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  64,  33,   0
	.byte  48,  33,   0

	.byte 0xFE,  33,   0
	.byte  60, 133,   0
	.byte  57, 133,   0
	.byte  52, 133,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  48,  33,   0

	.byte 0xFE,  33,   0
	.byte  40,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  33,   0
	.byte  48,  33,   0

	.byte 0xFE,  33,   0
	.byte  75,  67,   0
	.byte  66, 133,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  35,  33,   0

	.byte 0xFE,  33,   0
	.byte  42,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  67,   0
	.byte  35,  33,   0

	.byte 0xFE,  33,   0
	.byte  42,  33,   0

	.byte 0xFE,  33,   0
	.byte  83,  33,   0
	.byte  69, 133,   0
	.byte  66, 133,   0
	.byte  63, 133,   0
	.byte  35,  33,   0

	.byte 0xFE,  33,   0
	.byte  81,  33,   0
	.byte  42,  33,   0

	.byte 0xFE,  33,   0
	.byte  79,  33,   0
	.byte  35,  33,   0

	.byte 0xFE,  33,   0
	.byte  78,  33,   0
	.byte  42,  33,   0

	.byte 0xFE,  33,   0
	.byte  79,  17,   0
	.byte  67, 133,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  43,  33,   0

	.byte 0xFE,  17,   0
	.byte  81,  17,   0

	.byte 0xFE,  17,   0
	.byte  83,  17,   0
	.byte  47,  33,   0

	.byte 0xFE,  17,   0
	.byte  81,  17,   0

	.byte 0xFE,  17,   0
	.byte  79,  33,   0
	.byte  43,  33,   0

	.byte 0xFE,  33,   0
	.byte  76,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  67, 133,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  43,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  43,  33,   0

	.byte 0xFE,  33,   0
	.byte  79,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  78,  33,   0
	.byte  66, 133,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  42,  33,   0

	.byte 0xFE,  33,   0
	.byte  75,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  75,  33,   0
	.byte  42,  33,   0

	.byte 0xFE,  33,   0
	.byte  75,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  76,  67,   0
	.byte  66, 133,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  42,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  75,  67,   0
	.byte  42,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  71,  17,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  36,  33,   0

	.byte 0xFE,  17,   0
	.byte  72,  17,   0

	.byte 0xFE,  17,   0
	.byte  74,  17,   0
	.byte  43,  33,   0

	.byte 0xFE,  17,   0
	.byte  72,  17,   0

	.byte 0xFE,  17,   0
	.byte  71,  33,   0
	.byte  36,  33,   0

	.byte 0xFE,  33,   0
	.byte  67,  33,   0
	.byte  43,  33,   0

	.byte 0xFE,  33,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  36,  33,   0

	.byte 0xFE,  33,   0
	.byte  43,  33,   0

	.byte 0xFE,  33,   0
	.byte  36,  33,   0

	.byte 0xFE,  33,   0
	.byte  67,  33,   0
	.byte  43,  33,   0

	.byte 0xFE,  33,   0
	.byte  67, 133,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  55, 133,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  71, 100,   0
	.byte  67, 133,   0
	.byte  63, 133,   0
	.byte  59, 133,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  47,  33,   0

	.byte 0xFE,  33,   0
	.byte  39,  33,   0

	.byte 0xFE,  33,   0
	.byte  76,  17,   0
	.byte  47,  33,   0

	.byte 0xFE,  17,   0
	.byte  78,  17,   0

	.byte 0xFE,  17,   0
	.byte  79,  17,   0
	.byte  67, 133,   0
	.byte  64, 133,   0
	.byte  59, 133,   0
	.byte  48, 133,   0

	.byte 0xFE,  17,   0
	.byte  78,  17,   0

	.byte 0xFE,  17,   0
	.byte  76,  17,   0

	.byte 0xFE,  17,   0
	.byte  78,  17,   0

	.byte 0xFE,  17,   0
	.byte  79,  17,   0

	.byte 0xFE,  33,   0
	.byte  72,  17,   0

	.byte 0xFE,  17,   0
	.byte  74,  17,   0

	.byte 0xFE,  17,   0
	.byte  76,  17,   0
	.byte  64, 133,   0
	.byte  60, 133,   0
	.byte  57, 133,   0
	.byte  45, 133,   0

	.byte 0xFE,  17,   0
	.byte  74,  17,   0

	.byte 0xFE,  17,   0
	.byte  72,  17,   0

	.byte 0xFE,  17,   0
	.byte  74,  17,   0

	.byte 0xFE,  17,   0
	.byte  76,  17,   0

	.byte 0xFE,  67,   0
	.byte  75,  67,   0
	.byte  63, 133,   0
	.byte  60, 133,   0
	.byte  56, 133,   0
	.byte  44, 133,   0

	.byte 0xFE,  67,   0
	.byte  72,  67,   0

	.byte 0xFE,  67,   0
	.byte  71,  67,   0
	.byte  43,  67,   0

	.byte 0xFE,  67,   0
	.byte  42,  66,   0

	.byte 0xFE,  66,   0
	.byte 0xFF,   0,   0

	melody_ptr: .word melody
	music_ticks_remaining: .word 0


# Game over tune.
death_tune:
	.byte  83,  40, 48
	.byte  78,  40, 48
	.byte  79,  40, 48
	.byte  75,  40, 48
	.byte  76, 200, 48
	.byte 0xFF,   0, 0


.text
.globl main
main:
	lw s0, screen
	lw s1, snake_color
	lw s4, snake_head_color
	lw s2, head_x
	lw s3, head_y

	call start_screen

	call difficulty_select
	
	call clear_screen
	
	lw a0, screen
	lw a1, border_color
	call draw_border

	call draw_obstacles
	
# --- draw full starting snake ---
	la t5, snake        # array base
	li t6, 0            # i = 0
	li t4, 3

init_loop:
    bge t6, t4, init_done

    sub t0, zero, t6        # t0 = -i
    add a1, s2, t0          # x = head_x - i
    mv  a2, s3              # y = head_y

    call get_address
    add t1, s0, a0          # absolute pixel addr

    beqz t6, draw_head

    sw s1, 0(t1)            # body
    j store_seg

draw_head:
    sw s4, 0(t1)

store_seg:
    slli t2, t6, 2
    add t3, t5, t2
    sw t1, 0(t3)

    addi t6, t6, 1
    j init_loop

init_done:

	call spawn_apple

	call main_loop
	
	# End program	
	li a7, 10
	ecall

spawn_apple:
    addi sp, sp, -12
    sw   ra, 0(sp) 
spawn_try:

#	random syscall for x y
    li a7, 42
	li a0, 2
    li a1, 28
    ecall
    mv t0, a0

    li a7, 42
	li a0, 2
    li a1, 28
    ecall
    mv t1, a0

    mv a1, t0
    mv a2, t1
    call get_address

    add t2, s0, a0

#	check square paintable
    lw t3, 0(t2)
    lw t4, black_color
    bne t3, t4, spawn_try

#	paint apple
    lw t4, apple_color
    sw t4, 0(t2)

    lw ra, 0(sp)
    addi sp, sp, 12
    ret

difficulty_select:
	li a0, 100 # 100 ms delay
	li a7, 32
	ecall

    la t0, input	# check keypress
	lw t0, 4(t0)
	lw t0, 0(t0)

	la t2, difficulty_ms

	li t1, 49 # '1' ascii
	li t3, 200
	sw t3, 0(t2)
	beq t0, t1, difficulty_end
	li t1, 50 # '2' ascii
	li t3, 100
	sw t3, 0(t2)
	beq t0, t1, difficulty_end
	li t1, 51 # '3' ascii
	li t3, 50
	sw t3, 0(t2)
	beq t0, t1, difficulty_end

	j difficulty_select

difficulty_end:

	ret

main_loop:
	call play_music_tick
	lw a0, difficulty_ms
	li a7, 32
	ecall


    call input_checked
    call update_snake

    j main_loop

update_snake:
    addi sp, sp, -16
    sw ra, 0(sp)

	# Paint old head
	la t0, snake
	lw t1, 0(t0)          # Get current head address
	lw t2, snake_color
	sw t2, 0(t1)          # Paint it green

    # get array offset for tail
	lw t1, snake_length
	addi t1, t1, -1
	slli t1, t1, 2
	add t1, t0, t1

	# save tail end adress
	mv s5, t1

	# update head pos
	lw t0, head_x
	lw t1, head_y
	lw t2, vel_x
	lw t3, vel_y
	add t0, t0, t2
	add t1, t1, t3

	mv s2, t0 
	mv s3, t1 
	
# calculate next head screen address
	mv a1, t0
	mv a2, t1
	call get_address

	lw t2, screen
	add t2, t2, a0        # t2 = next head pixel address

# load pixel color at next position
	lw t3, 0(t2)

# --- collision checks using COLOR ---

	lw t4, apple_color
	beq t3, t4, grow_snake     # ate apple

	lw t4, border_color
	beq t3, t4, game_over     # hit wall or obstacle (both use border_color)

	lw t4, snake_color
	beq t3, t4, game_over     # hit body

	lw t4, snake_head_color
	beq t3, t4, game_over     # hit itself

	# paint tail end black
	lw t2, 0(s5)
	lw t0, black_color
	sw t0, 0(t2)

	#shift snake array
	call shift_snake_array
	j dont_grow

grow_snake:
	call play_eat_sfx       # Challenge D: non-blocking eat sound effect

	lw t0, snake_length
	la t1, snake_length
	addi t0, t0, 1
	sw t0, 0(t1)
	addi t0, t0, -3         # score = snake_length - 3
	
	# print "SCORE: "
	la a0, score_str
	li a7, 4
	ecall
	# print score number
	mv a0, t0
	li a7, 1
	ecall
	# print newline
	la a0, newline
	li a7, 4
	ecall

	# increase difficulty every 5 apples eaten
	# t0 contains score — check t0 % 5
	li a0, 5
	rem a0, t0, a0
	bnez a0, skip_increase_diff

	#else
	lw t0, difficulty_ms
	la t1, difficulty_ms
	addi t0, t0, -25        # new_difficulty = old - 25ms
	li a0, 49

	# don't go below 49ms
	bge a0, t0, skip_increase_diff
	sw t0, 0(t1)

skip_increase_diff:
	call spawn_apple
	call shift_snake_array

dont_grow:
	
	# store new head coordinates
	mv t0, s2
	mv t1, s3
	la t2, head_x
	la t3, head_y
	sw t0, 0(t2)
	sw t1, 0(t3)

    # new head address calculation
    mv a1, t0				# a1 = new head_x
    mv a2, t1				# a2 = new head_y
    call get_address		# returns offset in a0

    lw t3, screen			# screen base
    add t4, t3, a0			# absolute screen address

    lw t5, snake_head_color		# paint new head
    sw t5, 0(t4)

    li a0, 0
    mv a1, t4
    call store_address_snake
    
	lw ra, 0(sp)
	addi sp, sp, 16

	ret

shift_snake_array:
    lw t0, snake_length
    addi t0, t0, -1			# start at length-1
    blez t0, ssa_done		# if length <= 1, exit

    la t1, snake			# base address

ssa_loop:
    slli t2, t0, 2			# offset = i * 4
    add t3, t1, t2			# &snake[i]

    addi t4, t3, -4			# &snake[i-1]
    lw t5, 0(t4)			# load snake[i-1]
    sw t5, 0(t3)			# store into snake[i]

    addi t0, t0, -1
    bgtz t0, ssa_loop			# loop while > 0

ssa_done:
    ret

input_checked:

    la t0, input	# check keypress
	lw t0, 4(t0)
	lw t0, 0(t0)

	la a0, vel_x
	la a1, vel_y
	lw t1, 0(a0)
	lw t2, 0(a1)

	addi t3, t0, -119	# 'w' ascii val
	beqz t3, dir_w
	addi t3, t0, -97	# 'a' ascii val
	beqz t3, dir_a
	addi t3, t0, -115	# 's' ascii val
	beqz t3, dir_s
	addi t3, t0, -100	# 'd' ascii val
	beqz t3, dir_d
	addi t3, t0, -112	# 'p' ascii val
	beqz t3, paused
	# in the case no change is made
	sw t1, 0(a0)
	sw t2, 0(a1)
	ret

paused:
    la t0, input
    lw t1, 4(t0)     # load pointer to key data
    sw zero, 0(t1)   # clear the key register

pause_loop:
    la t0, input	# check keypress
	lw t0, 4(t0)
	lw t0, 0(t0)

	addi t3, t0, -112	# 'p' ascii val
	beqz t3, unpause
	j pause_loop

unpause:
    la t0, input
    lw t1, 4(t0)     # load pointer to key data
    sw zero, 0(t1)   # clear the key register
    j main_loop

# a0 -> vel_x
# a1 -> vel_y
dir_w:                     # UP (0, -1)
    lw t1, 0(a1)
    li t2, 1
    beq t1, t2, dir_ret    # if moving down, ignore

    sw zero, 0(a0)
    li t0, -1
    sw t0, 0(a1)
    ret

dir_s:                     # DOWN (0, +1)
    lw t1, 0(a1)
    li t2, -1
    beq t1, t2, dir_ret    # if moving up, ignore

    sw zero, 0(a0)
    li t0, 1
    sw t0, 0(a1)
    ret

dir_a:                     # LEFT (-1, 0)
    lw t1, 0(a0)
    li t2, 1
    beq t1, t2, dir_ret    # if moving right, ignore

    li t0, -1
    sw t0, 0(a0)
    sw zero, 0(a1)
    ret

dir_d:                     # RIGHT (1, 0)
    lw t1, 0(a0)
    li t2, -1
    beq t1, t2, dir_ret    # if moving left, ignore

    li t0, 1
    sw t0, 0(a0)
    sw zero, 0(a1)
    ret

dir_ret:
    ret

main_loop_end:
	ret

# a0 -> screen base address
# a1 -> border color
draw_border:
    li t0, 0				# iterator
    lw t1, total_bytes		# total bytes
    lw t2, bytes_per_row	# bytes per row

db_loop:
    bge t0, t1, db_end

    rem t3, t0, t2			# left edge
    beqz t3, db_draw

    addi t4, t0, 4			# right edge
    rem t3, t4, t2
    beqz t3, db_draw

    blt t0, t2, db_draw		# top row
    sub t5, t1, t2
    bge t0, t5, db_draw		# bottom row

    j db_next

db_draw:
    add t6, a0, t0
    sw a1, 0(t6)

db_next:
    addi t0, t0, 4
    j db_loop

db_end:
    ret

# a1 -> head_x coord
# a2 -> head_y coord
# ret -> offset
get_address:
	slli a0, a2, 5	# head_y x 32
	add a0, a0, a1	# add head_x
	slli a0, a0, 2	# multiply by 4
	
	ret
	
# a0 -> array index
# a1 -> memory address / argument to store
# ret -> NONE
store_address_snake:
	la a2, snake	# load snake array
	slli a0, a0, 2	# multiply array index by 4 to get offset since we are working with words, 4 bytes each
	add	a2, a2, a0	# add offset to address
	sw a1, 0(a2)	# store address inside index of "array"
	
	ret

# a0 -> color of pixel to draw
# a1 -> address of screen bitmap
# a2 -> x coord
# a3 -> y coord
# ret -> NONE
draw_at:
	slli t0, a3, 5
	add t0, t0, a2
	slli t0, t0, 2
	
	add t1, a1, t0
	sw a0, 0(t1)
	ret

game_over:
	la a0, game_over_str
	li a7, 4
	ecall

	call play_death_tune    # Challenge D: blocking death tune

	call death_anim
	
	li a7, 10
	ecall

death_anim:
	lw t0, screen		# Screen base address.
	li t1, 0x00FF0000	# Red color.
	lw t2, total_bytes	# Total bytes to draw on.
	
	add t3, t0, t2		# Final screen address.
	mv t4, t0		# Holds current address in screen.
	
	j death_loop
	
death_loop:
	bge t4, t3, death_loop_end 	# Jump to the end if we've reached the final address. 
	
	sw t1, 0(t4)			# Set the pixel at the current address to red.
	addi t4, t4, 4			# Add 4 bytes to go to the next address on screen.
	
	j death_loop			# Go back to beginning of label.
	
death_loop_end:
	li a0, 3000	# Time to sleep.
	li a7, 32	# Sleep syscall.
	ecall
	
	ret

clear_screen:
	# loop to paint entire screen black
	lw t0, screen
	lw t1, black_color
	lw t2, total_bytes

	add t3, t0, t2
	mv t4, t0

clear_loop:
    bge t4, t3, clear_done
    sw t1, 0(t4)
    addi t4, t4, 4
    j clear_loop
    
clear_done:
	ret

draw_obstacles:
	
    addi sp, sp, -16
    sw ra, 0(sp)
    
	lw a0, border_color
	lw a1, screen

	li a2, 23
	li a3, 4
	call draw_at
	li a2, 24
	li a3, 4
	call draw_at
	li a2, 23
	li a3, 5
	call draw_at
	li a2, 24
	li a3, 5
	call draw_at
	li a2, 1
	li a3, 8
	call draw_at
	li a2, 2
	li a3, 8
	call draw_at
	li a2, 3
	li a3, 8
	call draw_at
	li a2, 4
	li a3, 8
	call draw_at
	li a2, 5
	li a3, 8
	call draw_at
	li a2, 6
	li a3, 8
	call draw_at
	li a2, 7
	li a3, 8
	call draw_at
	li a2, 8
	li a3, 8
	call draw_at
	li a2, 9
	li a3, 8
	call draw_at
	li a2, 10
	li a3, 8
	call draw_at
	li a2, 11
	li a3, 8
	call draw_at
	li a2, 12
	li a3, 8
	call draw_at
	li a2, 13
	li a3, 8
	call draw_at
	li a2, 14
	li a3, 8
	call draw_at
	li a2, 17
	li a3, 12
	call draw_at
	li a2, 18
	li a3, 12
	call draw_at
	li a2, 19
	li a3, 12
	call draw_at
	li a2, 20
	li a3, 12
	call draw_at
	li a2, 21
	li a3, 12
	call draw_at
	li a2, 22
	li a3, 12
	call draw_at
	li a2, 23
	li a3, 12
	call draw_at
	li a2, 24
	li a3, 12
	call draw_at
	li a2, 25
	li a3, 12
	call draw_at
	li a2, 26
	li a3, 12
	call draw_at
	li a2, 27
	li a3, 12
	call draw_at
	li a2, 28
	li a3, 12
	call draw_at
	li a2, 29
	li a3, 12
	call draw_at
	li a2, 30
	li a3, 12
	call draw_at
	li a2, 1
	li a3, 16
	call draw_at
	li a2, 2
	li a3, 16
	call draw_at
	li a2, 3
	li a3, 16
	call draw_at
	li a2, 4
	li a3, 16
	call draw_at
	li a2, 5
	li a3, 16
	call draw_at
	li a2, 6
	li a3, 16
	call draw_at
	li a2, 7
	li a3, 16
	call draw_at
	li a2, 8
	li a3, 16
	call draw_at
	li a2, 9
	li a3, 16
	call draw_at
	li a2, 10
	li a3, 16
	call draw_at
	li a2, 11
	li a3, 16
	call draw_at
	li a2, 12
	li a3, 16
	call draw_at
	li a2, 13
	li a3, 16
	call draw_at
	li a2, 14
	li a3, 16
	call draw_at
	li a2, 17
	li a3, 20
	call draw_at
	li a2, 18
	li a3, 20
	call draw_at
	li a2, 19
	li a3, 20
	call draw_at
	li a2, 20
	li a3, 20
	call draw_at
	li a2, 21
	li a3, 20
	call draw_at
	li a2, 22
	li a3, 20
	call draw_at
	li a2, 23
	li a3, 20
	call draw_at
	li a2, 24
	li a3, 20
	call draw_at
	li a2, 25
	li a3, 20
	call draw_at
	li a2, 26
	li a3, 20
	call draw_at
	li a2, 27
	li a3, 20
	call draw_at
	li a2, 28
	li a3, 20
	call draw_at
	li a2, 29
	li a3, 20
	call draw_at
	li a2, 30
	li a3, 20
	call draw_at
	li a2, 8
	li a3, 23
	call draw_at
	li a2, 9
	li a3, 23
	call draw_at
	li a2, 8
	li a3, 24
	call draw_at
	li a2, 9
	li a3, 24
	call draw_at
	li a2, 22
	li a3, 26
	call draw_at
	li a2, 23
	li a3, 26
	call draw_at
	li a2, 22
	li a3, 27
	call draw_at
	li a2, 23
	li a3, 27
	call draw_at
	
    lw ra, 0(sp)
    addi sp, sp, 16
	ret

start_screen:

    addi sp, sp, -16
    sw ra, 0(sp)
    
	li a0, 0x00FF40DD #pink
	lw a1, screen

	li a2, 9
	li a3, 8
	call draw_at
	li a2, 11
	li a3, 8
	call draw_at
	li a2, 12
	li a3, 8
	call draw_at
	li a2, 13
	li a3, 8
	call draw_at
	li a2, 15
	li a3, 8
	call draw_at
	li a2, 16
	li a3, 8
	call draw_at
	li a2, 17
	li a3, 8
	call draw_at
	li a2, 19
	li a3, 8
	call draw_at
	li a2, 20
	li a3, 8
	call draw_at
	li a2, 21
	li a3, 8
	call draw_at
	li a2, 9
	li a3, 9
	call draw_at
	li a2, 12
	li a3, 9
	call draw_at
	li a2, 15
	li a3, 9
	call draw_at
	li a2, 19
	li a3, 9
	call draw_at
	li a2, 23
	li a3, 9
	call draw_at
	li a2, 9
	li a3, 10
	call draw_at
	li a2, 12
	li a3, 10
	call draw_at
	li a2, 15
	li a3, 10
	call draw_at
	li a2, 16
	li a3, 10
	call draw_at
	li a2, 19
	li a3, 10
	call draw_at
	li a2, 20
	li a3, 10
	call draw_at
	li a2, 7
	li a3, 11
	call draw_at
	li a2, 8
	li a3, 11
	call draw_at
	li a2, 9
	li a3, 11
	call draw_at
	li a2, 12
	li a3, 11
	call draw_at
	li a2, 15
	li a3, 11
	call draw_at
	li a2, 19
	li a3, 11
	call draw_at
	li a2, 7
	li a3, 12
	call draw_at
	li a2, 9
	li a3, 12
	call draw_at
	li a2, 12
	li a3, 12
	call draw_at
	li a2, 15
	li a3, 12
	call draw_at
	li a2, 19
	li a3, 12
	call draw_at
	li a2, 23
	li a3, 12
	call draw_at
	li a2, 7
	li a3, 13
	call draw_at
	li a2, 8
	li a3, 13
	call draw_at
	li a2, 9
	li a3, 13
	call draw_at
	li a2, 11
	li a3, 13
	call draw_at
	li a2, 12
	li a3, 13
	call draw_at
	li a2, 13
	li a3, 13
	call draw_at
	li a2, 15
	li a3, 13
	call draw_at
	li a2, 19
	li a3, 13
	call draw_at
	li a2, 4
	li a3, 16
	call draw_at
	li a2, 5
	li a3, 16
	call draw_at
	li a2, 6
	li a3, 16
	call draw_at
	li a2, 7
	li a3, 16
	call draw_at
	li a2, 8
	li a3, 16
	call draw_at
	li a2, 9
	li a3, 16
	call draw_at
	li a2, 10
	li a3, 16
	call draw_at
	li a2, 13
	li a3, 16
	call draw_at
	li a2, 14
	li a3, 16
	call draw_at
	li a2, 15
	li a3, 16
	call draw_at
	li a2, 16
	li a3, 16
	call draw_at
	li a2, 17
	li a3, 16
	call draw_at
	li a2, 18
	li a3, 16
	call draw_at
	li a2, 19
	li a3, 16
	call draw_at
	li a2, 22
	li a3, 16
	call draw_at
	li a2, 23
	li a3, 16
	call draw_at
	li a2, 24
	li a3, 16
	call draw_at
	li a2, 25
	li a3, 16
	call draw_at
	li a2, 26
	li a3, 16
	call draw_at
	li a2, 27
	li a3, 16
	call draw_at
	li a2, 28
	li a3, 16
	call draw_at
	li a2, 4
	li a3, 17
	call draw_at
	li a2, 10
	li a3, 17
	call draw_at
	li a2, 13
	li a3, 17
	call draw_at
	li a2, 19
	li a3, 17
	call draw_at
	li a2, 22
	li a3, 17
	call draw_at
	li a2, 28
	li a3, 17
	call draw_at
	li a2, 4
	li a3, 18
	call draw_at
	li a2, 7
	li a3, 18
	call draw_at
	li a2, 10
	li a3, 18
	call draw_at
	li a2, 13
	li a3, 18
	call draw_at
	li a2, 15
	li a3, 18
	call draw_at
	li a2, 16
	li a3, 18
	call draw_at
	li a2, 17
	li a3, 18
	call draw_at
	li a2, 19
	li a3, 18
	call draw_at
	li a2, 22
	li a3, 18
	call draw_at
	li a2, 24
	li a3, 18
	call draw_at
	li a2, 25
	li a3, 18
	call draw_at
	li a2, 26
	li a3, 18
	call draw_at
	li a2, 28
	li a3, 18
	call draw_at
	li a2, 4
	li a3, 19
	call draw_at
	li a2, 6
	li a3, 19
	call draw_at
	li a2, 7
	li a3, 19
	call draw_at
	li a2, 10
	li a3, 19
	call draw_at
	li a2, 13
	li a3, 19
	call draw_at
	li a2, 17
	li a3, 19
	call draw_at
	li a2, 19
	li a3, 19
	call draw_at
	li a2, 22
	li a3, 19
	call draw_at
	li a2, 26
	li a3, 19
	call draw_at
	li a2, 28
	li a3, 19
	call draw_at
	li a2, 4
	li a3, 20
	call draw_at
	li a2, 7
	li a3, 20
	call draw_at
	li a2, 10
	li a3, 20
	call draw_at
	li a2, 13
	li a3, 20
	call draw_at
	li a2, 16
	li a3, 20
	call draw_at
	li a2, 19
	li a3, 20
	call draw_at
	li a2, 22
	li a3, 20
	call draw_at
	li a2, 26
	li a3, 20
	call draw_at
	li a2, 28
	li a3, 20
	call draw_at
	li a2, 4
	li a3, 21
	call draw_at
	li a2, 7
	li a3, 21
	call draw_at
	li a2, 10
	li a3, 21
	call draw_at
	li a2, 13
	li a3, 21
	call draw_at
	li a2, 15
	li a3, 21
	call draw_at
	li a2, 19
	li a3, 21
	call draw_at
	li a2, 22
	li a3, 21
	call draw_at
	li a2, 25
	li a3, 21
	call draw_at
	li a2, 28
	li a3, 21
	call draw_at
	li a2, 4
	li a3, 22
	call draw_at
	li a2, 7
	li a3, 22
	call draw_at
	li a2, 10
	li a3, 22
	call draw_at
	li a2, 13
	li a3, 22
	call draw_at
	li a2, 15
	li a3, 22
	call draw_at
	li a2, 19
	li a3, 22
	call draw_at
	li a2, 22
	li a3, 22
	call draw_at
	li a2, 26
	li a3, 22
	call draw_at
	li a2, 28
	li a3, 22
	call draw_at
	li a2, 4
	li a3, 23
	call draw_at
	li a2, 6
	li a3, 23
	call draw_at
	li a2, 7
	li a3, 23
	call draw_at
	li a2, 8
	li a3, 23
	call draw_at
	li a2, 10
	li a3, 23
	call draw_at
	li a2, 13
	li a3, 23
	call draw_at
	li a2, 15
	li a3, 23
	call draw_at
	li a2, 16
	li a3, 23
	call draw_at
	li a2, 17
	li a3, 23
	call draw_at
	li a2, 19
	li a3, 23
	call draw_at
	li a2, 22
	li a3, 23
	call draw_at
	li a2, 24
	li a3, 23
	call draw_at
	li a2, 25
	li a3, 23
	call draw_at
	li a2, 26
	li a3, 23
	call draw_at
	li a2, 28
	li a3, 23
	call draw_at
	li a2, 4
	li a3, 24
	call draw_at
	li a2, 10
	li a3, 24
	call draw_at
	li a2, 13
	li a3, 24
	call draw_at
	li a2, 19
	li a3, 24
	call draw_at
	li a2, 22
	li a3, 24
	call draw_at
	li a2, 28
	li a3, 24
	call draw_at
	li a2, 4
	li a3, 25
	call draw_at
	li a2, 5
	li a3, 25
	call draw_at
	li a2, 6
	li a3, 25
	call draw_at
	li a2, 7
	li a3, 25
	call draw_at
	li a2, 8
	li a3, 25
	call draw_at
	li a2, 9
	li a3, 25
	call draw_at
	li a2, 10
	li a3, 25
	call draw_at
	li a2, 13
	li a3, 25
	call draw_at
	li a2, 14
	li a3, 25
	call draw_at
	li a2, 15
	li a3, 25
	call draw_at
	li a2, 16
	li a3, 25
	call draw_at
	li a2, 17
	li a3, 25
	call draw_at
	li a2, 18
	li a3, 25
	call draw_at
	li a2, 19
	li a3, 25
	call draw_at
	li a2, 22
	li a3, 25
	call draw_at
	li a2, 23
	li a3, 25
	call draw_at
	li a2, 24
	li a3, 25
	call draw_at
	li a2, 25
	li a3, 25
	call draw_at
	li a2, 26
	li a3, 25
	call draw_at
	li a2, 27
	li a3, 25
	call draw_at
	li a2, 28
	li a3, 25
	call draw_at
	
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

play_music_tick:
	# We check how much else we have to wait.
	la   t0, music_ticks_remaining
	lw   t1, 0(t0)
	beqz t1, pmt_read_entry
	
	lw   t2, difficulty_ms
	sub  t1, t1, t2
	
	blez t1, pmt_gate_expired
	sw   t1, 0(t0)
	ret
	
pmt_gate_expired:
	sw   zero, 0(t0)
	ret

pmt_read_entry:
	la   t0, melody_ptr
	lw   t1, 0(t0)			# Current entry address.
	lbu  t2, 0(t1)			# Pitch byte (or 0xFF / 0xFE for control).

	# If we reached the end, we go back to the very beginning of the track.
	li   t3, 0xFF
	bne  t2, t3, pmt_check_gate
	la   t4, melody
	sw   t4, 0(t0)
	ret

pmt_check_gate:
	# If we find a stop marker (0xFE), we wait for the duration.
	li   t3, 0xFE
	bne  t2, t3, pmt_play_note
	lbu  t3, 1(t1)
	
	# We convert the tick units to milliseconds.
	slli t5, t3, 3
	slli t4, t3, 1
	add  t3, t5, t4
	addi t1, t1, 3
	sw   t1, 0(t0)
	la   t0, music_ticks_remaining
	sw   t3, 0(t0)
	ret

pmt_play_note:
	# Normal note
	lbu  t3, 1(t1)       # t3 = duration units
	lbu  t4, 2(t1)       # t4 = instrument

	# Calculate duration into milliseconds.
	slli t5, t3, 3
	slli a1, t3, 1
	add  a1, a1, t5

	mv   a0, t2			# Pitch
	mv   a2, t4			# Instrument
	li   a3, 80			# Volume
	li   a7, 31
	ecall

	# Move to the next part of the song.
	addi t1, t1, 3
	sw   t1, 0(t0)
	j    pmt_read_entry

# Plays when we eat an apple.
play_eat_sfx:
	li   a0, 84
	li   a1, 100
	li   a2, 13
	li   a3, 110
	li   a7, 31
	ecall
	ret

play_death_tune:
	addi sp, sp, -16
	sw   ra, 12(sp)

	la   t0, death_tune

# Loop for playing the death tune.
pdt_loop:
	lbu  t1, 0(t0)

	# Check if we are at the end marker.
	li   t2, 0xFF
	beq  t1, t2, pdt_done

	# We load the duration units and instrument.
	lbu  t3, 1(t0)
	lbu  t4, 2(t0)

	# We convert the units to milliseconds.
	slli t5, t3, 3
	slli a1, t3, 1
	add  a1, a1, t5

	mv   a0, t1			# Pitch
	mv   a2, t4			# Instrument
	li   a3, 100			# Volume
	li   a7, 33
	ecall

	addi t0, t0, 3
	j    pdt_loop

pdt_done:
	lw   ra, 12(sp)
	addi sp, sp, 16
	ret