# SNAKE GAME (Group 2)
# Challenge 6
# 
# s registers: global constant values
# t registers: temp variable registers
# 
# 2WIDTH x HEIGHT = 256 x 256
# Pixel size: 8 
#
.data
	snake:			.space 40	# Array size 10 words basically
	snake_length:	.word 5		# snake length including head (makes life easier). starts at 2
	head_x:			.word 16	# x, y coords for head
	head_y:			.word 16
	vel_x:			.word 1
	vel_y:			.word 0
	apples:			.space 80
	max_apples:		.word 1

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
	difficulty_str:	.asciz "please select difficulty 1 2 or 3 in MMIO keyboard input\n'"

.text
.globl main
main:
	lw a0, screen
	lw a1, border_color
	call draw_border

	# Load head coords and screen ADRESSES
	lw s0, screen
	lw s1, snake_color
	lw s4, snake_head_color

	lw s2, head_x
	lw s3, head_y
	lw s5, apples
	
	mv a1, s2 # Args for offset calc (head_x = a1, head_y = a2)
	mv a2, s3
	
	# Calculate offset, stored in a0
	call head_offset_calc
	
	# Add the offset to the "pointer", store in t0
	add t0, s0, a0
	
	# Change pixel color
	sw s4, 0(t0)
	
	# Store the "coordinate" in the array
	li a0, 0	# Store in 0 offset of snake array, first position
	mv a1, t0	# Argument for address to store
	call store_address_snake

	# same steps as before but for "tail" of the snake	
	li t0, -1
	mv a1, s2
	mv a2, s3
	
	add a1, a1, t0	# for tail subtract 1 to x coord
	call head_offset_calc
	add t0, s0, a0
	sw s1, 0(t0)
	
	li a0, 1	# second index of array
	mv a1, t0
	call store_address_snake
	
	# repeat for second block of tail
	li t0, -2
	mv a1, s2
	mv a2, s3
	
	add a1, a1, t0	# for tail subtract 1 to x coord
	call head_offset_calc
	add t0, s0, a0
	sw s1, 0(t0)
	
	li a0, 2	# second index of array
	mv a1, t0
	call store_address_snake
	
	# repeat for third block of tail
	li t0, -3
	mv a1, s2
	mv a2, s3
	
	add a1, a1, t0
	call head_offset_calc
	add t0, s0, a0
	sw s1, 0(t0)
	
	li a0, 3	# third index of array
	mv a1, t0
	call store_address_snake

	# repeat for fourth block of tail
	li t0, -4
	mv a1, s2
	mv a2, s3
	
	add a1, a1, t0
	call head_offset_calc
	add t0, s0, a0
	sw s1, 0(t0)
	
	li a0, 4	# fourth index of array
	mv a1, t0
	call store_address_snake

	la a0, difficulty_str
	li a7, 4
	ecall

	call spawn_food
	li a7, 10
	ecall
	
	call difficulty_select

	call main_loop
	
	# End program	
	li a7, 10
	ecall
	
get_random_number:
	li a0 0
	li a1 29
	li a7, 42
	ecall
	addi a0, a0, 1
	ret
	
spawn_food:
	addi sp, sp, -16
	sw ra 0(sp)
	
	# Direccion x
	call get_random_number
	
	li a1, 0
	li a2, 0
	call set_elem
	
	# Direccion y
	call get_random_number
	
	li a1, 0
	li a2, 1
	call set_elem
	
	li a1, 0
	li a2, 0
	call get_elem
	mv t0, a0
	
	li a1, 0
	li a2, 1
	call get_elem
	mv t1, a0

	lw a0, apple_color
	mv a1, s0
	lw a2, 0(t0)
	lw a3, 0(t1)
	call draw_at

set_elem:
    slli t1, a1, 3         # fila*8
    slli t2, a2, 2         # columna*4
    add  t1, t1, t2        # offset = fila*8 + columna*4
    add  t1, s5, t1        # dirección absoluta
    sw   a0, 0(t1)	   # Guardamos a0 en la posiciones calculada de fila a1, columna a2
    ret
	
get_elem:
    slli t1, a1, 3
    slli t2, a2, 2
    add  t1, t1, t2
    add  t1, s5, t1
    lw   a0, 0(t1)
    ret


difficulty_select:
	li a0, 100 # 100 ms delay
	li a7, 32
	ecall

    la t0, input	# check keypress
	lw t0, 4(t0)
	lw t0, 0(t0)

	la, t2, difficulty_ms

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

	# paint tail end black
	lw t2, 0(t1)
	lw t0, black_color
	sw t0, 0(t2)

	#shift snake array
	call shift_snake_array

	# update head pos
	lw t0, head_x
	lw t1, head_y
	lw t2, vel_x
	lw t3, vel_y
	add t0, t0, t2
	add t1, t1, t3
	
	# check wall collision
    li t4, 1
    blt t0, t4, game_over      # if head_x < 0
    blt t1, t4, game_over      # if head_y < 0
    li t5, 30
    bgt t0, t5, game_over      # if head_x > 31
    bgt t1, t5, game_over      # if head_y > 31
	
	# check body collision
	mv a1, t0				# head_x
	mv a2, t1				# head_y
	call head_offset_calc

	lw t2, screen
	add t2, t2, a0

	la t3, snake
	lw t5, snake_length
	li t5, 0				# iterator

body_collision_loop:		#iterate array to check for collision
	bge t5, t4, body_collision_done

	slli t6, t5, 2
	add t6, t6, t3
	lw t6, 0(t6)

	beq t6, t2, game_over

	addi t5, t5, 1
	j body_collision_loop

body_collision_done:
	
	# store new head coordinates
	la t2, head_x
	la t3, head_y
	sw t0, 0(t2)
	sw t1, 0(t3)

    # new head address calculation
    mv a1, t0				# a1 = new head_x
    mv a2, t1				# a2 = new head_y
    call head_offset_calc	# returns offset in a0

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
head_offset_calc:
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
