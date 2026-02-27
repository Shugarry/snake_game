.data
	snake:			.space 1024
	snake_b:		.space 1024
	snake_length_b:	.word 3
	snake_length:	.word 3		# snake length including head (makes life easier). starts at 2
	head_x:			.word 3	# x, y coords for head
	head_y:			.word 3
	vel_x:			.word 1
	vel_y:			.word 0
	head_x_b:			.word 27
	head_y_b:			.word 27
	vel_x_b:			.word -1
	vel_y_b:			.word 0

	black_color: 	.word 0x00000000
	border_color:	.word 0x000000FF
	snake_color:	.word 0x0000FF00 #pure green
	snake_color_b:	.word 0x00006000 #dark green
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

	p1_wins_str:    .asciz "PLAYER ONE WINS\n"
	p2_wins_str:    .asciz "PLAYER TWO WINS\n"
.text
.globl main
main:
	# OCTAVIO: musica de fondo, a ser posible
	
	lw s0, screen
	lw s1, snake_color
	lw s4, snake_head_color
	lw s2, head_x
	lw s3, head_y

	call mode_select_screen

	call mode_select

	call clear_screen
	
    la t0, input
    lw t1, 4(t0)     # load pointer to key data
    sw zero, 0(t1)   # clear the key register

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

mode_select:
	li a0, 100 # 100 ms delay
	li a7, 32
	ecall

    la t0, input	# check keypress
	lw t0, 4(t0)
	lw t0, 0(t0)

	li t1, 49 # '1' ascii
	beq t0, t1, chose_one_player
	li t1, 50 # '2' ascii
	beq t0, t1, chose_two_player

	j mode_select

chose_one_player:
	ret
chose_two_player:
	j two_player_mode

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
	beq t3, t4, game_over     # hit wall

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
	# OCTAVIO: sonido de haber comido manzana, un *ping* o algo del estilo
	lw t0, snake_length
	la t1, snake_length
	addi t0, t0, 1
	sw t0, 0(t1)
	addi t0, t0, -3 # score = snake_length - 3
	
	# print "SCORE: "
	la a0, score_str
	li a7, 4          # print string
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
	# t0 contains score (apples eaten) check by doing t0 % 5
	li a0, 5
	rem a0, t0, a0
	bnez a0, skip_increase_diff

	#else
	lw t0, difficulty_ms
	la t1, difficulty_ms
	addi t0, t0, -25	# t0 -> new_difficulty = old diff - 25ms
	li a0, 49

	#check less than 49
	bge a0, t0, skip_increase_diff
	sw t0, 0(t1)

skip_increase_diff:
	call spawn_apple
	call shift_snake_array

dont_grow:
# body_collision_done:
	
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
    call get_address	# returns offset in a0

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
	# OCTAVIO: sonido para game over
	la a0, game_over_str
	li a7, 4
	ecall
	
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
	li a0, 1000	# Time to sleep.
	li a7, 32	# Sleep syscall.
	ecall
	
	ret

clear_screen:
	# loop to paint entire screen black basically because they arent when the program starts
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
	
two_player_mode:
	call clear_screen
	
	lw a0, screen
	lw a1, border_color
	call draw_border

	# --- draw full starting snake A ---
	lw s2, head_x
	lw s3, head_y
	la t5, snake
	li t6, 0
	li t4, 3
init_loop_a_2p:
	bge t6, t4, init_done_a_2p
	sub t0, zero, t6        # t0 = -i
	add a1, s2, t0          # x = head_x - i
	mv  a2, s3              # y = head_y
	call get_address
	add t1, s0, a0          # absolute pixel addr
	beqz t6, draw_head_a_2p
	lw s1, snake_color
	sw s1, 0(t1)            # body
	j store_seg_a_2p
draw_head_a_2p:
	lw s4, snake_head_color
	sw s4, 0(t1)
store_seg_a_2p:
	slli t2, t6, 2
	add t3, t5, t2
	sw t1, 0(t3)
	addi t6, t6, 1
	j init_loop_a_2p
init_done_a_2p:

	# --- draw full starting snake B ---
	lw s2, head_x_b
	lw s3, head_y_b
	la t5, snake_b
	li t6, 0
	li t4, 3
init_loop_b_2p:
	bge t6, t4, init_done_b_2p
	add a1, s2, t6          # x = head_x_b + i (starts moving left, so tail is to the right)
	mv  a2, s3              # y = head_y_b
	call get_address
	add t1, s0, a0          # absolute pixel addr
	beqz t6, draw_head_b_2p
	lw s1, snake_color_b
	sw s1, 0(t1)            # body
	j store_seg_b_2p
draw_head_b_2p:
	lw s4, snake_head_color
	sw s4, 0(t1)            # Can share the same head color, or use snake_color_b
store_seg_b_2p:
	slli t2, t6, 2
	add t3, t5, t2
	sw t1, 0(t3)
	addi t6, t6, 1
	j init_loop_b_2p
init_done_b_2p:

	# Spawn the first apple
	call spawn_apple

two_player_loop:
	# Fixed delay for 2-player mode
	li a0, 100 
	li a7, 32
	ecall

	call input_checked_2p
	call update_snake_a_2p
	call update_snake_b_2p

	j two_player_loop


# input handling for 2 Players (WASD and IJKL)
input_checked_2p:
	la t0, input
	lw t0, 4(t0)
	lw t0, 0(t0)

	# Snake A (WASD)
	addi t3, t0, -119	# 'w'
	beqz t3, dir_w_a
	addi t3, t0, -97	# 'a'
	beqz t3, dir_a_a
	addi t3, t0, -115	# 's'
	beqz t3, dir_s_a
	addi t3, t0, -100	# 'd'
	beqz t3, dir_d_a

	# Snake B (IJKL)
	addi t3, t0, -105	# 'i'
	beqz t3, dir_i_b
	addi t3, t0, -106	# 'j'
	beqz t3, dir_j_b
	addi t3, t0, -107	# 'k'
	beqz t3, dir_k_b
	addi t3, t0, -108	# 'l'
	beqz t3, dir_l_b

	ret

dir_w_a:
	la a0, vel_x
	la a1, vel_y
	lw t1, 0(a1)
	li t2, 1
	beq t1, t2, dir_ret_2p
	sw zero, 0(a0)
	li t0, -1
	sw t0, 0(a1)
	ret
dir_s_a:
	la a0, vel_x
	la a1, vel_y
	lw t1, 0(a1)
	li t2, -1
	beq t1, t2, dir_ret_2p
	sw zero, 0(a0)
	li t0, 1
	sw t0, 0(a1)
	ret
dir_a_a:
	la a0, vel_x
	la a1, vel_y
	lw t1, 0(a0)
	li t2, 1
	beq t1, t2, dir_ret_2p
	li t0, -1
	sw t0, 0(a0)
	sw zero, 0(a1)
	ret
dir_d_a:
	la a0, vel_x
	la a1, vel_y
	lw t1, 0(a0)
	li t2, -1
	beq t1, t2, dir_ret_2p
	li t0, 1
	sw t0, 0(a0)
	sw zero, 0(a1)
	ret

dir_i_b:
	la a0, vel_x_b
	la a1, vel_y_b
	lw t1, 0(a1)
	li t2, 1
	beq t1, t2, dir_ret_2p
	sw zero, 0(a0)
	li t0, -1
	sw t0, 0(a1)
	ret
dir_k_b:
	la a0, vel_x_b
	la a1, vel_y_b
	lw t1, 0(a1)
	li t2, -1
	beq t1, t2, dir_ret_2p
	sw zero, 0(a0)
	li t0, 1
	sw t0, 0(a1)
	ret
dir_j_b:
	la a0, vel_x_b
	la a1, vel_y_b
	lw t1, 0(a0)
	li t2, 1
	beq t1, t2, dir_ret_2p
	li t0, -1
	sw t0, 0(a0)
	sw zero, 0(a1)
	ret
dir_l_b:
	la a0, vel_x_b
	la a1, vel_y_b
	lw t1, 0(a0)
	li t2, -1
	beq t1, t2, dir_ret_2p
	li t0, 1
	sw t0, 0(a0)
	sw zero, 0(a1)
	ret

dir_ret_2p:
	ret

# update snake A
update_snake_a_2p:
	addi sp, sp, -16
	sw ra, 0(sp)

	# Paint old head body color
	la t0, snake
	lw t1, 0(t0)
	lw t2, snake_color
	sw t2, 0(t1)

	# get array offset for tail
	lw t1, snake_length
	addi t1, t1, -1
	slli t1, t1, 2
	add t1, t0, t1
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
	add t2, t2, a0
	lw t3, 0(t2) # color at next position

	# collision checks
	lw t4, apple_color
	beq t3, t4, grow_snake_a_2p
	lw t4, border_color
	beq t3, t4, game_over_p1_wins
	lw t4, snake_color
	beq t3, t4, game_over_p1_wins
	lw t4, snake_color_b
	beq t3, t4, game_over_p1_wins
	lw t4, snake_head_color
	beq t3, t4, game_over_p1_wins

	# paint tail end black
	lw t2, 0(s5)
	lw t0, black_color
	sw t0, 0(t2)

	call shift_snake_array
	j dont_grow_a_2p

grow_snake_a_2p:
	lw t0, snake_length
	la t1, snake_length
	addi t0, t0, 1
	sw t0, 0(t1)
	
	call spawn_apple
	call shift_snake_array

dont_grow_a_2p:
	# store new head coordinates
	mv t0, s2
	mv t1, s3
	la t2, head_x
	la t3, head_y
	sw t0, 0(t2)
	sw t1, 0(t3)

	# paint new head
	mv a1, t0
	mv a2, t1
	call get_address
	lw t3, screen
	add t4, t3, a0
	lw t5, snake_head_color
	sw t5, 0(t4)

	# save to array
	li a0, 0
	mv a1, t4
	call store_address_snake
	
	lw ra, 0(sp)
	addi sp, sp, 16
	ret


# update snake B
update_snake_b_2p:
	addi sp, sp, -16
	sw ra, 0(sp)

	# Paint old head body color
	la t0, snake_b
	lw t1, 0(t0)
	lw t2, snake_color_b
	sw t2, 0(t1)

	# get array offset for tail
	lw t1, snake_length_b
	addi t1, t1, -1
	slli t1, t1, 2
	add t1, t0, t1
	mv s5, t1

	# update head pos
	lw t0, head_x_b
	lw t1, head_y_b
	lw t2, vel_x_b
	lw t3, vel_y_b
	add t0, t0, t2
	add t1, t1, t3
	mv s2, t0 
	mv s3, t1 

	# calculate next head screen address
	mv a1, t0
	mv a2, t1
	call get_address
	lw t2, screen
	add t2, t2, a0
	lw t3, 0(t2) # color at next position

	# collision checks
	lw t4, apple_color
	beq t3, t4, grow_snake_b_2p
	lw t4, border_color
	beq t3, t4, game_over_p2_wins
	lw t4, snake_color
	beq t3, t4, game_over_p2_wins
	lw t4, snake_color_b
	beq t3, t4, game_over_p2_wins
	lw t4, snake_head_color
	beq t3, t4, game_over_p2_wins

	# paint tail end black
	lw t2, 0(s5)
	lw t0, black_color
	sw t0, 0(t2)

	call shift_snake_b_array
	j dont_grow_b_2p

grow_snake_b_2p:
	lw t0, snake_length_b
	la t1, snake_length_b
	addi t0, t0, 1
	sw t0, 0(t1)
	
	call spawn_apple
	call shift_snake_b_array

dont_grow_b_2p:
	# store new head coordinates
	mv t0, s2
	mv t1, s3
	la t2, head_x_b
	la t3, head_y_b
	sw t0, 0(t2)
	sw t1, 0(t3)

	# paint new head
	mv a1, t0
	mv a2, t1
	call get_address
	lw t3, screen
	add t4, t3, a0
	lw t5, snake_head_color  # Both heads use same color visually
	sw t5, 0(t4)

	# save to array
	li a0, 0
	mv a1, t4
	call store_address_snake_b
	
	lw ra, 0(sp)
	addi sp, sp, 16
	ret


# helpers for snake B
shift_snake_b_array:
	lw t0, snake_length_b
	addi t0, t0, -1
	blez t0, ssb_done
	la t1, snake_b
ssb_loop:
	slli t2, t0, 2
	add t3, t1, t2
	addi t4, t3, -4
	lw t5, 0(t4)
	sw t5, 0(t3)
	addi t0, t0, -1
	bgtz t0, ssb_loop
ssb_done:
	ret

store_address_snake_b:
	la a2, snake_b
	slli a0, a0, 2
	add	a2, a2, a0
	sw a1, 0(a2)
	ret

game_over_p1_wins:
	la a0, p1_wins_str
	li a7, 4
	ecall
	call death_anim

	li a0, 0x00FF40DD #pink
	lw a1, screen

	li a2, 5
	li a3, 8
	call draw_at
	li a2, 6
	li a3, 8
	call draw_at
	li a2, 7
	li a3, 8
	call draw_at
	li a2, 10
	li a3, 8
	call draw_at
	li a2, 13
	li a3, 8
	call draw_at
	li a2, 15
	li a3, 8
	call draw_at
	li a2, 17
	li a3, 8
	call draw_at
	li a2, 18
	li a3, 8
	call draw_at
	li a2, 19
	li a3, 8
	call draw_at
	li a2, 21
	li a3, 8
	call draw_at
	li a2, 24
	li a3, 8
	call draw_at
	li a2, 26
	li a3, 8
	call draw_at
	li a2, 5
	li a3, 9
	call draw_at
	li a2, 7
	li a3, 9
	call draw_at
	li a2, 9
	li a3, 9
	call draw_at
	li a2, 10
	li a3, 9
	call draw_at
	li a2, 13
	li a3, 9
	call draw_at
	li a2, 15
	li a3, 9
	call draw_at
	li a2, 18
	li a3, 9
	call draw_at
	li a2, 21
	li a3, 9
	call draw_at
	li a2, 22
	li a3, 9
	call draw_at
	li a2, 24
	li a3, 9
	call draw_at
	li a2, 26
	li a3, 9
	call draw_at
	li a2, 5
	li a3, 10
	call draw_at
	li a2, 6
	li a3, 10
	call draw_at
	li a2, 7
	li a3, 10
	call draw_at
	li a2, 10
	li a3, 10
	call draw_at
	li a2, 13
	li a3, 10
	call draw_at
	li a2, 15
	li a3, 10
	call draw_at
	li a2, 18
	li a3, 10
	call draw_at
	li a2, 21
	li a3, 10
	call draw_at
	li a2, 22
	li a3, 10
	call draw_at
	li a2, 23
	li a3, 10
	call draw_at
	li a2, 24
	li a3, 10
	call draw_at
	li a2, 26
	li a3, 10
	call draw_at
	li a2, 5
	li a3, 11
	call draw_at
	li a2, 10
	li a3, 11
	call draw_at
	li a2, 13
	li a3, 11
	call draw_at
	li a2, 15
	li a3, 11
	call draw_at
	li a2, 18
	li a3, 11
	call draw_at
	li a2, 21
	li a3, 11
	call draw_at
	li a2, 23
	li a3, 11
	call draw_at
	li a2, 24
	li a3, 11
	call draw_at
	li a2, 26
	li a3, 11
	call draw_at
	li a2, 5
	li a3, 12
	call draw_at
	li a2, 10
	li a3, 12
	call draw_at
	li a2, 13
	li a3, 12
	call draw_at
	li a2, 14
	li a3, 12
	call draw_at
	li a2, 15
	li a3, 12
	call draw_at
	li a2, 18
	li a3, 12
	call draw_at
	li a2, 21
	li a3, 12
	call draw_at
	li a2, 24
	li a3, 12
	call draw_at
	li a2, 5
	li a3, 13
	call draw_at
	li a2, 9
	li a3, 13
	call draw_at
	li a2, 10
	li a3, 13
	call draw_at
	li a2, 11
	li a3, 13
	call draw_at
	li a2, 13
	li a3, 13
	call draw_at
	li a2, 15
	li a3, 13
	call draw_at
	li a2, 17
	li a3, 13
	call draw_at
	li a2, 18
	li a3, 13
	call draw_at
	li a2, 19
	li a3, 13
	call draw_at
	li a2, 21
	li a3, 13
	call draw_at
	li a2, 24
	li a3, 13
	call draw_at
	li a2, 26
	li a3, 13
	call draw_at

	li a7, 10
	ecall

game_over_p2_wins:
	la a0, p2_wins_str
	li a7, 4
	ecall
	call death_anim

	li a0, 0x00FF40DD #pink
	lw a1, screen
	li a2, 5
	li a3, 8
	call draw_at
	li a2, 6
	li a3, 8
	call draw_at
	li a2, 7
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
	li a2, 13
	li a3, 8
	call draw_at
	li a2, 15
	li a3, 8
	call draw_at
	li a2, 17
	li a3, 8
	call draw_at
	li a2, 18
	li a3, 8
	call draw_at
	li a2, 19
	li a3, 8
	call draw_at
	li a2, 21
	li a3, 8
	call draw_at
	li a2, 24
	li a3, 8
	call draw_at
	li a2, 26
	li a3, 8
	call draw_at
	li a2, 5
	li a3, 9
	call draw_at
	li a2, 7
	li a3, 9
	call draw_at
	li a2, 11
	li a3, 9
	call draw_at
	li a2, 13
	li a3, 9
	call draw_at
	li a2, 15
	li a3, 9
	call draw_at
	li a2, 18
	li a3, 9
	call draw_at
	li a2, 21
	li a3, 9
	call draw_at
	li a2, 22
	li a3, 9
	call draw_at
	li a2, 24
	li a3, 9
	call draw_at
	li a2, 26
	li a3, 9
	call draw_at
	li a2, 5
	li a3, 10
	call draw_at
	li a2, 6
	li a3, 10
	call draw_at
	li a2, 7
	li a3, 10
	call draw_at
	li a2, 10
	li a3, 10
	call draw_at
	li a2, 13
	li a3, 10
	call draw_at
	li a2, 15
	li a3, 10
	call draw_at
	li a2, 18
	li a3, 10
	call draw_at
	li a2, 21
	li a3, 10
	call draw_at
	li a2, 22
	li a3, 10
	call draw_at
	li a2, 23
	li a3, 10
	call draw_at
	li a2, 24
	li a3, 10
	call draw_at
	li a2, 26
	li a3, 10
	call draw_at
	li a2, 5
	li a3, 11
	call draw_at
	li a2, 9
	li a3, 11
	call draw_at
	li a2, 13
	li a3, 11
	call draw_at
	li a2, 15
	li a3, 11
	call draw_at
	li a2, 18
	li a3, 11
	call draw_at
	li a2, 21
	li a3, 11
	call draw_at
	li a2, 23
	li a3, 11
	call draw_at
	li a2, 24
	li a3, 11
	call draw_at
	li a2, 26
	li a3, 11
	call draw_at
	li a2, 5
	li a3, 12
	call draw_at
	li a2, 9
	li a3, 12
	call draw_at
	li a2, 13
	li a3, 12
	call draw_at
	li a2, 14
	li a3, 12
	call draw_at
	li a2, 15
	li a3, 12
	call draw_at
	li a2, 18
	li a3, 12
	call draw_at
	li a2, 21
	li a3, 12
	call draw_at
	li a2, 24
	li a3, 12
	call draw_at
	li a2, 5
	li a3, 13
	call draw_at
	li a2, 9
	li a3, 13
	call draw_at
	li a2, 10
	li a3, 13
	call draw_at
	li a2, 11
	li a3, 13
	call draw_at
	li a2, 13
	li a3, 13
	call draw_at
	li a2, 15
	li a3, 13
	call draw_at
	li a2, 17
	li a3, 13
	call draw_at
	li a2, 18
	li a3, 13
	call draw_at
	li a2, 19
	li a3, 13
	call draw_at
	li a2, 21
	li a3, 13
	call draw_at
	li a2, 24
	li a3, 13
	call draw_at
	li a2, 26
	li a3, 13
	call draw_at

	li a7, 10
	ecall

###############################################################################
#                                                                             #
#                                                                             #
#                      just onscreen drawing, stop here                       #
#                                                                             #
#                                                                             #
###############################################################################

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

mode_select_screen:
    addi sp, sp, -16
    sw ra, 0(sp)
    
	li a0, 0x00FF40DD #pink
	lw a1, screen

	li a2, 7
	li a3, 6
	call draw_at
	li a2, 9
	li a3, 6
	call draw_at
	li a2, 11
	li a3, 6
	call draw_at
	li a2, 12
	li a3, 6
	call draw_at
	li a2, 13
	li a3, 6
	call draw_at
	li a2, 15
	li a3, 6
	call draw_at
	li a2, 16
	li a3, 6
	call draw_at
	li a2, 17
	li a3, 6
	call draw_at
	li a2, 19
	li a3, 6
	call draw_at
	li a2, 20
	li a3, 6
	call draw_at
	li a2, 21
	li a3, 6
	call draw_at
	li a2, 7
	li a3, 7
	call draw_at
	li a2, 8
	li a3, 7
	call draw_at
	li a2, 9
	li a3, 7
	call draw_at
	li a2, 11
	li a3, 7
	call draw_at
	li a2, 13
	li a3, 7
	call draw_at
	li a2, 15
	li a3, 7
	call draw_at
	li a2, 17
	li a3, 7
	call draw_at
	li a2, 19
	li a3, 7
	call draw_at
	li a2, 23
	li a3, 7
	call draw_at
	li a2, 7
	li a3, 8
	call draw_at
	li a2, 9
	li a3, 8
	call draw_at
	li a2, 11
	li a3, 8
	call draw_at
	li a2, 13
	li a3, 8
	call draw_at
	li a2, 15
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
	li a2, 7
	li a3, 9
	call draw_at
	li a2, 9
	li a3, 9
	call draw_at
	li a2, 11
	li a3, 9
	call draw_at
	li a2, 13
	li a3, 9
	call draw_at
	li a2, 15
	li a3, 9
	call draw_at
	li a2, 17
	li a3, 9
	call draw_at
	li a2, 19
	li a3, 9
	call draw_at
	li a2, 7
	li a3, 10
	call draw_at
	li a2, 9
	li a3, 10
	call draw_at
	li a2, 11
	li a3, 10
	call draw_at
	li a2, 13
	li a3, 10
	call draw_at
	li a2, 15
	li a3, 10
	call draw_at
	li a2, 17
	li a3, 10
	call draw_at
	li a2, 19
	li a3, 10
	call draw_at
	li a2, 23
	li a3, 10
	call draw_at
	li a2, 7
	li a3, 11
	call draw_at
	li a2, 9
	li a3, 11
	call draw_at
	li a2, 11
	li a3, 11
	call draw_at
	li a2, 12
	li a3, 11
	call draw_at
	li a2, 13
	li a3, 11
	call draw_at
	li a2, 15
	li a3, 11
	call draw_at
	li a2, 16
	li a3, 11
	call draw_at
	li a2, 19
	li a3, 11
	call draw_at
	li a2, 20
	li a3, 11
	call draw_at
	li a2, 21
	li a3, 11
	call draw_at
	li a2, 7
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
	li a2, 16
	li a3, 16
	call draw_at
	li a2, 17
	li a3, 16
	call draw_at
	li a2, 18
	li a3, 16
	call draw_at
	li a2, 21
	li a3, 16
	call draw_at
	li a2, 22
	li a3, 16
	call draw_at
	li a2, 23
	li a3, 16
	call draw_at
	li a2, 6
	li a3, 17
	call draw_at
	li a2, 7
	li a3, 17
	call draw_at
	li a2, 10
	li a3, 17
	call draw_at
	li a2, 12
	li a3, 17
	call draw_at
	li a2, 18
	li a3, 17
	call draw_at
	li a2, 21
	li a3, 17
	call draw_at
	li a2, 23
	li a3, 17
	call draw_at
	li a2, 7
	li a3, 18
	call draw_at
	li a2, 10
	li a3, 18
	call draw_at
	li a2, 11
	li a3, 18
	call draw_at
	li a2, 12
	li a3, 18
	call draw_at
	li a2, 17
	li a3, 18
	call draw_at
	li a2, 21
	li a3, 18
	call draw_at
	li a2, 22
	li a3, 18
	call draw_at
	li a2, 23
	li a3, 18
	call draw_at
	li a2, 7
	li a3, 19
	call draw_at
	li a2, 10
	li a3, 19
	call draw_at
	li a2, 16
	li a3, 19
	call draw_at
	li a2, 21
	li a3, 19
	call draw_at
	li a2, 7
	li a3, 20
	call draw_at
	li a2, 10
	li a3, 20
	call draw_at
	li a2, 16
	li a3, 20
	call draw_at
	li a2, 21
	li a3, 20
	call draw_at
	li a2, 6
	li a3, 21
	call draw_at
	li a2, 7
	li a3, 21
	call draw_at
	li a2, 8
	li a3, 21
	call draw_at
	li a2, 10
	li a3, 21
	call draw_at
	li a2, 16
	li a3, 21
	call draw_at
	li a2, 17
	li a3, 21
	call draw_at
	li a2, 18
	li a3, 21
	call draw_at
	li a2, 21
	li a3, 21
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
