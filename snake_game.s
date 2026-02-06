# SNAKE GAME (Group 2)
#
# s registers: global constant values
# t registers: temp variable registers
# 
# 2WIDTH x HEIGHT = 256 x 256
# Pixel size: 8 
#
.data
	snake:			.space 40	# Array size 10 words basically
	head_x:			.word 16	# x, y coords for head
	head_y:			.word 16
	vel_x:			.word 1
	vel_y:			.word 0

	black_color: 	.word 0x00000000
	border_color:	.word 0x000000FF
	snake_color:	.word 0x0000FF00
	apple_color:	.word 0x00FF0000
	text_color:		.word 0x00BBBBBB
	
	screen:			.word 0x10040000	# screen address
	input:			.word 0xFFFF0000
	input_data:		.word 0xFFFF0004
	
	
	pixel_size:		.word 8
	length:			.word 256	# screen len/width
	width:			.word 256
	
	row_width:		.word 32
	bytes_p_pixel:	.word 4

.text
.globl main
main:
	# Text on screen
	lw a0, text_color
	lw a1, screen
	
	li a2, 1
	li a3, 1
	call draw_at
	li a2, 2
	li a3, 1
	call draw_at
	li a2, 5
	li a3, 1
	call draw_at
	li a2, 9
	li a3, 1
	call draw_at
	li a2, 10
	li a3, 1
	call draw_at
	li a2, 12
	li a3, 1
	call draw_at
	li a2, 13
	li a3, 1
	call draw_at
	li a2, 23
	li a3, 1
	call draw_at
	li a2, 24
	li a3, 1
	call draw_at
	li a2, 26
	li a3, 1
	call draw_at
	li a2, 27
	li a3, 1
	call draw_at
	li a2, 28
	li a3, 1
	call draw_at
	li a2, 1
	li a3, 2
	call draw_at
	li a2, 4
	li a3, 2
	call draw_at
	li a2, 6
	li a3, 2
	call draw_at
	li a2, 8
	li a3, 2
	call draw_at
	li a2, 12
	li a3, 2
	call draw_at
	li a2, 14
	li a3, 2
	call draw_at
	li a2, 24
	li a3, 2
	call draw_at
	li a2, 26
	li a3, 2
	call draw_at
	li a2, 28
	li a3, 2
	call draw_at
	li a2, 1
	li a3, 3
	call draw_at
	li a2, 2
	li a3, 3
	call draw_at
	li a2, 4
	li a3, 3
	call draw_at
	li a2, 6
	li a3, 3
	call draw_at
	li a2, 8
	li a3, 3
	call draw_at
	li a2, 10
	li a3, 3
	call draw_at
	li a2, 12
	li a3, 3
	call draw_at
	li a2, 14
	li a3, 3
	call draw_at
	li a2, 24
	li a3, 3
	call draw_at
	li a2, 26
	li a3, 3
	call draw_at
	li a2, 28
	li a3, 3
	call draw_at
	li a2, 1
	li a3, 4
	call draw_at
	li a2, 3
	li a3, 4
	call draw_at
	li a2, 5
	li a3, 4
	call draw_at
	li a2, 7
	li a3, 4
	call draw_at
	li a2, 9
	li a3, 4
	call draw_at
	li a2, 10
	li a3, 4
	call draw_at
	li a2, 11
	li a3, 4
	call draw_at
	li a2, 12
	li a3, 4
	call draw_at
	li a2, 13
	li a3, 4
	call draw_at
	li a2, 24
	li a3, 4
	call draw_at
	li a2, 26
	li a3, 4
	call draw_at
	li a2, 27
	li a3, 4
	call draw_at
	li a2, 28
	li a3, 4
	call draw_at
	li a2, 3
	li a3, 15
	call draw_at
	li a2, 4
	li a3, 15
	call draw_at
	li a2, 6
	li a3, 15
	call draw_at
	li a2, 8
	li a3, 15
	call draw_at
	li a2, 10
	li a3, 15
	call draw_at
	li a2, 11
	li a3, 15
	call draw_at
	li a2, 12
	li a3, 15
	call draw_at
	li a2, 13
	li a3, 15
	call draw_at
	li a2, 15
	li a3, 15
	call draw_at
	li a2, 16
	li a3, 15
	call draw_at
	li a2, 17
	li a3, 15
	call draw_at
	li a2, 18
	li a3, 15
	call draw_at
	li a2, 20
	li a3, 15
	call draw_at
	li a2, 21
	li a3, 15
	call draw_at
	li a2, 22
	li a3, 15
	call draw_at
	li a2, 23
	li a3, 15
	call draw_at
	li a2, 24
	li a3, 15
	call draw_at
	li a2, 25
	li a3, 15
	call draw_at
	li a2, 26
	li a3, 15
	call draw_at
	li a2, 2
	li a3, 16
	call draw_at
	li a2, 5
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
	li a2, 15
	li a3, 16
	call draw_at
	li a2, 17
	li a3, 16
	call draw_at
	li a2, 18
	li a3, 16
	call draw_at
	li a2, 20
	li a3, 16
	call draw_at
	li a2, 21
	li a3, 16
	call draw_at
	li a2, 22
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
	li a2, 2
	li a3, 17
	call draw_at
	li a2, 4
	li a3, 17
	call draw_at
	li a2, 5
	li a3, 17
	call draw_at
	li a2, 6
	li a3, 17
	call draw_at
	li a2, 7
	li a3, 17
	call draw_at
	li a2, 8
	li a3, 17
	call draw_at
	li a2, 10
	li a3, 17
	call draw_at
	li a2, 11
	li a3, 17
	call draw_at
	li a2, 15
	li a3, 17
	call draw_at
	li a2, 17
	li a3, 17
	call draw_at
	li a2, 20
	li a3, 17
	call draw_at
	li a2, 21
	li a3, 17
	call draw_at
	li a2, 24
	li a3, 17
	call draw_at
	li a2, 25
	li a3, 17
	call draw_at
	li a2, 3
	li a3, 18
	call draw_at
	li a2, 4
	li a3, 18
	call draw_at
	li a2, 5
	li a3, 18
	call draw_at
	li a2, 7
	li a3, 18
	call draw_at
	li a2, 8
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
	li a2, 18
	li a3, 17
	call draw_at
	li a2, 19
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
	li a2, 24
	li a3, 18
	call draw_at
	li a2, 26
	li a3, 18
	call draw_at
	li a2, 2
	li a3, 27
	call draw_at
	li a2, 3
	li a3, 27
	call draw_at
	li a2, 8
	li a3, 27
	call draw_at
	li a2, 10
	li a3, 27
	call draw_at
	li a2, 13
	li a3, 27
	call draw_at
	li a2, 14
	li a3, 27
	call draw_at
	li a2, 15
	li a3, 27
	call draw_at
	li a2, 19
	li a3, 27
	call draw_at
	li a2, 20
	li a3, 27
	call draw_at
	li a2, 22
	li a3, 27
	call draw_at
	li a2, 24
	li a3, 27
	call draw_at
	li a2, 26
	li a3, 27
	call draw_at
	li a2, 27
	li a3, 27
	call draw_at
	li a2, 28
	li a3, 27
	call draw_at
	li a2, 29
	li a3, 27
	call draw_at
	li a2, 2
	li a3, 28
	call draw_at
	li a2, 4
	li a3, 28
	call draw_at
	li a2, 5
	li a3, 28
	call draw_at
	li a2, 7
	li a3, 28
	call draw_at
	li a2, 9
	li a3, 28
	call draw_at
	li a2, 10
	li a3, 28
	call draw_at
	li a2, 12
	li a3, 28
	call draw_at
	li a2, 13
	li a3, 28
	call draw_at
	li a2, 14
	li a3, 28
	call draw_at
	li a2, 18
	li a3, 28
	call draw_at
	li a2, 21
	li a3, 28
	call draw_at
	li a2, 23
	li a3, 28
	call draw_at
	li a2, 24
	li a3, 28
	call draw_at
	li a2, 25
	li a3, 28
	call draw_at
	li a2, 26
	li a3, 28
	call draw_at
	li a2, 27
	li a3, 28
	call draw_at
	li a2, 28
	li a3, 28
	call draw_at
	li a2, 2
	li a3, 29
	call draw_at
	li a2, 4
	li a3, 29
	call draw_at
	li a2, 6
	li a3, 29
	call draw_at
	li a2, 7
	li a3, 29
	call draw_at
	li a2, 8
	li a3, 29
	call draw_at
	li a2, 9
	li a3, 29
	call draw_at
	li a2, 10
	li a3, 29
	call draw_at
	li a2, 11
	li a3, 29
	call draw_at
	li a2, 13
	li a3, 29
	call draw_at
	li a2, 18
	li a3, 29
	call draw_at
	li a2, 20
	li a3, 29
	call draw_at
	li a2, 21
	li a3, 29
	call draw_at
	li a2, 22
	li a3, 29
	call draw_at
	li a2, 23
	li a3, 29
	call draw_at
	li a2, 24
	li a3, 29
	call draw_at
	li a2, 26
	li a3, 29
	call draw_at
	li a2, 27
	li a3, 29
	call draw_at
	li a2, 1
	li a3, 30
	call draw_at
	li a2, 2
	li a3, 30
	call draw_at
	li a2, 4
	li a3, 30
	call draw_at
	li a2, 6
	li a3, 30
	call draw_at
	li a2, 7
	li a3, 30
	call draw_at
	li a2, 9
	li a3, 30
	call draw_at
	li a2, 10
	li a3, 30
	call draw_at
	li a2, 12
	li a3, 30
	call draw_at
	li a2, 13
	li a3, 30
	call draw_at
	li a2, 14
	li a3, 30
	call draw_at
	li a2, 15
	li a3, 30
	call draw_at
	li a2, 19
	li a3, 30
	call draw_at
	li a2, 20
	li a3, 30
	call draw_at
	li a2, 21
	li a3, 30
	call draw_at
	li a2, 23
	li a3, 30
	call draw_at
	li a2, 24
	li a3, 30
	call draw_at
	li a2, 26
	li a3, 30
	call draw_at
	li a2, 27
	li a3, 30
	call draw_at
	li a2, 28
	li a3, 30
	call draw_at
	li a2, 29
	li a3, 30
	call draw_at

	# Load head coords and screen ADRESSES
	lw s0, screen
	lw s1, snake_color

	lw s2, head_x
	lw s3, head_y
	
	mv a1, s2 # Args for offset calc (head_x = a1, head_y = a2)
	mv a2, s3
	
	# Calculate offset, stored in a0
	call head_offset_calc
	
	# Add the offset to the "pointer", store in t0
	add t0, s0, a0
	
	# Change pixel color
	sw s1, 0(t0)
	
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

	# Bonus part: coloring and letters
	lw t0, border_color
	lw t6, screen

	sw t0, 0(t6)
	sw t0, 4(t6)
	sw t0, 8(t6)
	sw t0, 12(t6)
	sw t0, 16(t6)
	sw t0, 20(t6)
	sw t0, 24(t6)
	sw t0, 28(t6)
	sw t0, 32(t6)
	sw t0, 36(t6)
	sw t0, 40(t6)
	sw t0, 44(t6)
	sw t0, 48(t6)
	sw t0, 52(t6)
	sw t0, 56(t6)
	sw t0, 60(t6)
	sw t0, 64(t6)
	sw t0, 68(t6)
	sw t0, 72(t6)
	sw t0, 76(t6)
	sw t0, 80(t6)
	sw t0, 84(t6)
	sw t0, 88(t6)
	sw t0, 92(t6)
	sw t0, 96(t6)
	sw t0, 100(t6)
	sw t0, 104(t6)
	sw t0, 108(t6)
	sw t0, 112(t6)
	sw t0, 116(t6)
	sw t0, 120(t6)
	sw t0, 124(t6)

	li t1, 3968
	add t6, t6, t1

	sw t0, 0(t6)
	sw t0, 4(t6)
	sw t0, 8(t6)
	sw t0, 12(t6)
	sw t0, 16(t6)
	sw t0, 20(t6)
	sw t0, 24(t6)
	sw t0, 28(t6)
	sw t0, 32(t6)
	sw t0, 36(t6)
	sw t0, 40(t6)
	sw t0, 44(t6)
	sw t0, 48(t6)
	sw t0, 52(t6)
	sw t0, 56(t6)
	sw t0, 60(t6)
	sw t0, 64(t6)
	sw t0, 68(t6)
	sw t0, 72(t6)
	sw t0, 76(t6)
	sw t0, 80(t6)
	sw t0, 84(t6)
	sw t0, 88(t6)
	sw t0, 92(t6)
	sw t0, 96(t6)
	sw t0, 100(t6)
	sw t0, 104(t6)
	sw t0, 108(t6)
	sw t0, 112(t6)
	sw t0, 116(t6)
	sw t0, 120(t6)
	sw t0, 124(t6)

	lw t6, screen
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)	
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)	
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)	
	addi t6, t6, 128
	sw t0, 0(t6)
	sw t0, 124(t6)
	# Border done lol
	

	# End program	
	li a7, 10
	ecall

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
	
	
