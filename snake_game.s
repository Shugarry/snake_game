.data
	snake1:			.space 1024	# Array for snake1 segments (addresses)
	snake1_length:	.word 3		# snake length including head
	head1_x:		.word 16	# x, y coords for head
	head1_y:		.word 16
	vel1_x:			.word 1
	vel1_y:			.word 0
	
	snake2:			.space 1024
	snake2_length:	.word 3 
	head2_x:		.word 24
	head2_y:		.word 16
	vel2_x:			.word -1 	# starting moving left
	vel2_y:			.word 0 
	
	black_color: 		.word 0x00000000
	border_color:		.word 0x000000FF
	
	snake1_color:		.word 0x0000FF00		# Green
	snake1_head_color:	.word 0x00FCBC3D		# Orange
	
	snake2_color: 		.word 0x000000FF		# Blue
	snake2_head_color: 	.word 0x00FF00FF 		# Purple/Magenta
	apple_color:		.word 0x00FF0000
	text_color:			.word 0x00BBBBBB
	
	# Challenge A - score
	score: 			.word 0
	score_msg: 		.asciz "Score: "
	
	screen:			.word 0x10040000	# screen address
	input:			.word 0xFFFF0000
	input_data:		.word 0xFFFF0004
	
	bytes_per_row:	.word 128
	total_bytes:	.word 4096
	
	difficulty_ms:	.word 0

	game_over_str:	.asciz "Game Over\n"
	player1_wins: 	.asciz "Player 1 wins \n"
	player2_wins: 	.asciz "Player 2  wins \n" 
	tie: 			.asciz "there is a tie\n"
	difficulty_str:	.asciz "Please select difficulty 1, 2, or 3 using keyboard\n"
	start_screen_drawn: .word 0
	obstacle_color: .word 0x000000FF


.text
.globl main
main:
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
	call start_screen
	la a0, difficulty_str 
    	li a7, 4 
    	ecall 
    	call difficulty_select 
    	call clear_screen
    
	#draw border
	lw a0, screen
	lw a1, border_color
	call draw_border
	
	call draw_obstacles
	
	# Initialize both snakes
	call init_snake1
	call init_snake2 
	
	la t0, score 
	sw zero, 0(t0) 
	call display_score 
	
	#spawn first apple
	call spawn_apple 
	
	

	call main_loop 

#initalize snake 1 
init_snake1:
	addi sp, sp, -16
	sw ra, 12(sp) 
	lw s0, screen 
	lw s1, snake1_color 
	lw s4, snake1_head_color 
	lw s2, head1_x 
	lw s3, head1_y 
	
	la t5, snake1 
	li t6, 0 
	
	lw t4, snake1_length 

init1_loop:
	bge t6, t4, init1_done 
	sub t0, zero, t6 
	add a1, s2, t0 
	mv a2, s3 
	call get_address 
	add t1, s0, a0
	
	beqz t6, draw1_head 
	sw s1, 0(t1) 
	j store1_seg 

draw1_head: 
	sw s4, 0(t1) 

store1_seg: 
	slli t2, t6, 2 
	add t3, t5, t2
	sw t1, 0(t3) 
	
	addi t6, t6, 1
	j init1_loop 

init1_done:
	lw ra, 12(sp)    
	addi sp, sp, 16  
	ret

init_snake2: 
	addi sp, sp , -16 
	sw ra, 12(sp) 
	
	lw s0, screen 
	lw s1, snake2_color 
	lw s4, snake2_head_color 
	lw s2, head2_x 
	lw s3, head2_y 
	
	la t5, snake2
	li t6, 0 
	lw t4, snake2_length 

init2_loop: 
	bge t6, t4, init2_done 
	add a1, s2, t6 
	mv a2, s3 
	call get_address 
	add t1, s0, a0 
	
	beqz t6, draw2_head 
	sw s1, 0(t1) 
	j store2_seg 

draw2_head: 
	sw s4, 0(t1) #draw head 

store2_seg: 
	slli t2, t6, 2 
	add t3, t5, t2
	sw t1, 0(t3)  #store address in snake array 
	
	addi t6, t6, 1 
	j init2_loop 

init2_done: 
	lw ra,12(sp) 
	addi sp,sp,16 
	ret 

main_loop: 
	#delay 
	lw a0, difficulty_ms 
	li a7, 32 
	ecall 
	
	#checking  for both players 
	call input_checked_player1 
	call input_checked_player2 
	
	call update_snake1 
	call update_snake2
	
	#check collisions between snakes 
	call check_snake_collisions
	j main_loop 

#player 1 input handler wasd 
input_checked_player1:
	addi sp, sp, -16 
	sw ra, 12(sp) 
	la t0, input 
	lw t0, 4(t0) 
	lw t0, 0(t0) 
	
	la a0, vel1_x 
	la a1, vel1_y 
	lw t1, 0(a0) 
	lw t2, 0(a1) 
	
	addi t3, t0, -119
	beqz t3, p1_dir_w
	
	addi t3, t0, -97
	beqz t3, p1_dir_a
	
	addi t3, t0, -115
	beqz t3, p1_dir_s 
	
	addi t3, t0,-100
	beqz t3, p1_dir_d 
	
	#no valid key pressed 
	sw t1, 0(a0) 
	sw t2, 0(a1)
	
    	
	lw ra, 12(sp) 
	addi sp, sp, 16 
	ret
	
p1_dir_w: 
	lw t1, 0(a1) 
	li t2, 1 
	beq t1, t2, dir_ret_p1 
	sw zero, 0(a0) 
	li t0, -1
	sw t0, 0(a1) 
	j dir_ret_p1 

p1_dir_s: 
	lw t1, 0(a1) 
	li t2, -1 
	beq t1, t2, dir_ret_p1 
	sw zero, 0(a0) 
	li t0, 1
	sw t0, 0(a1) 
	j dir_ret_p1
	
p1_dir_a:
	lw t1, 0(a0) 
	li t2, 1
	beq t1, t2, dir_ret_p1
	li t0, -1 
	sw t0, 0(a0) 
	sw zero, 0(a1) 
	j dir_ret_p1 
	
p1_dir_d: 
	lw t1, 0(a0)
	li t2, -1 
	beq t1, t2, dir_ret_p1 
	li t0, 1 
	sw t0, 0(a0) 
	sw zero, 0(a1) 

dir_ret_p1: 
	lw ra, 12(sp)
	addi sp, sp,16 
	ret
	
#player 2 
input_checked_player2:
	addi sp, sp, -16 
	sw ra, 12(sp) 
	la t0, input 
	lw t0, 4(t0) 
	lw t0, 0(t0) 
	
	la a0, vel2_x 
	la a1, vel2_y 
	lw t1, 0(a0) 
	lw t2, 0(a1) 
	
	addi t3, t0, -105 
	beqz t3, p2_dir_i 
	addi t3, t0, -106 
	beqz t3, p2_dir_j 
	addi t3, t0, -107
	beqz t3, p2_dir_k 
	addi t3, t0, -108 
	beqz t3, p2_dir_l 
	
	#no valid key pressed 
	sw t1, 0(a0) 
	sw t2, 0(a1) 
	
	lw ra, 12(sp) 
	addi sp, sp, 16 
	ret 

p2_dir_i: 
	lw t1, 0(a1) 
	li t2, 1 
	beq t1, t2, dir_ret_p2 
	sw zero, 0(a0) 
	li t0, -1 
	sw t0, 0(a1) 
	j dir_ret_p2 
	
p2_dir_k: 
	lw t1, 0(a1) 
	li t2, -1 
	beq t1, t2, dir_ret_p2 
	sw zero, 0(a0) 
	li t0, 1
	sw t0, 0(a1) 
	j dir_ret_p2 

p2_dir_j: 
	lw t1, 0(a0) 
	li t2, 1
	beq t1, t2, dir_ret_p2 
	li t0,-1
	sw t0, 0(a0) 
	sw zero, 0(a1) 
	j dir_ret_p2 
	
p2_dir_l: 
	lw t1, 0(a0) 
	li t2, -1 
	beq t1, t2, dir_ret_p2
	li t0, 1
	sw t0,  0(a0) 
	sw zero, 0(a1) 

dir_ret_p2: 
	lw ra, 12(sp) 
	addi sp, sp, 16 
	ret 

update_snake1: 
	addi sp, sp, -20
	sw ra, 16(sp) 
	sw s5, 12(sp) 
	sw s6, 8(sp) 
	
	#get current head 
	la t0, snake1 
	lw t1, 0(t0) 
	lw t2, snake1_color 
	sw t2, 0(t1) 
	
	#get tail address 
	lw t1, snake1_length 
	addi t1, t1, -1 
	slli t1, t1, 2 
	add t1, t0, t1 
	mv s5, t1 
	
	#update head position 
	lw t0, head1_x 
 	lw t1, head1_y 
 	lw t2, vel1_x 
 	lw t3, vel1_y 
 	add t0, t0, t2 
 	add t1, t1, t3 
 	
 	#store new head position 
 	la t2, head1_x 
 	la t3, head1_y 
 	sw t0, 0(t2) 
 	sw t1, 0(t3) 
 	
 	#collision check 
 	li t4, 1 
 	blt t0, t4, game_over_p2_wins 
 	blt t1, t4, game_over_p2_wins
 	li t5, 30 
 	bgt t0, t5, game_over_p2_wins 
 	bgt t1, t5, game_over_p2_wins
 	lw t4, border_color       
    	beq t3, t4, game_over_p2_wins  #hit obstacle 

 	#get new head screen address
 	mv a1, t0 
 	mv a2, t1 
 	call get_address
 	lw t2, screen 
 	add t2, t2, a0 
 	
 	lw t3, 0(t2)
 	
 	#apple collision check 
 	lw t4, apple_color 
 	beq t3, t4, grow_snake1
 	
 	#no apple 
 	lw t2, 0(s5) 
 	lw t0, black_color 
 	sw t0, 0(t2) 
 	
 	#shift snake array 
 	call shift_snake1_array 
 	j update1_done 
 
 grow_snake1: 
 	#increase length 
 	lw t0, snake1_length 
 	addi t0, t0, 1 
 	la t1, snake1_length 
 	sw t0, 0(t1) 
 	
 	
 	#spawn new apple / update score 
 	call increase_score 
	call spawn_apple 
	call shift_snake1_array

update1_done: 
	#paint the new head 
	lw a1, head1_x 
	lw a2, head1_y 
	call get_address 
	lw t3, screen
	add t4, t3, a0 
	lw t5, snake1_head_color 
	sw t5, 0(t4)
	
	# Store new head address in snake array 0
	li a0, 0 
	mv a1, t4
	call store_address_snake1 
	
	lw s6, 8(sp) 
	lw s5, 12(sp) 
	lw ra, 16(sp) 
	addi sp, sp, 20 
	ret 
	
#shift snake1 array 
shift_snake1_array: 
	lw t0, snake1_length 
	addi t0, t0, -1
	blez t0, s1_done 
	la t1, snake1

s1_loop: 
	slli t2, t0, 2 
	add t3, t1, t2 
	addi t4, t3, -4 
	lw t5, 0(t4) 
	sw t5, 0(t3) 
	addi t0, t0, -1
	bgtz t0, s1_loop
s1_done:
	ret
	
#store address in snake1 array at index a0 
store_address_snake1: 
	la a2, snake1
	slli a0, a0, 2 
	add a2, a2, a0 
	sw a1, 0(a2) 
	ret

#update snake 2 position 
update_snake2:
	addi sp, sp, -20
	sw ra, 16(sp)
	sw s5, 12(sp)
	
	#paint old head to body
	la t0, snake2
	lw t1, 0(t0)
	lw t2, snake2_color
	sw t2, 0(t1)
	
	#getting tail address
	lw t1, snake2_length
	addi t1, t1, -1
	slli t1, t1, 2
	add t1, t0, t1
	mv s5, t1
	
	#updating position
	lw t0, head2_x
	lw t1, head2_y
	lw t2, vel2_x
	lw t3, vel2_y
	add t0, t0, t2
	add t1, t1, t3
	
	#store new position
	la t2, head2_x
	la t3, head2_y
	sw t0, 0(t2)
	sw t1, 0(t3)
	
	#wall collision
	li t4, 1
	blt t0, t4, game_over_p1_wins
	blt t1, t4, game_over_p1_wins
	li t5, 30
	bgt t0, t5, game_over_p1_wins
	bgt t1, t5, game_over_p1_wins
	
	lw t4, border_color        
    	beq t3, t4, game_over_p1_wins  #hit obstacle
	#get new head address
	mv a1, t0
	mv a2, t1
	call get_address
	lw t2, screen
	add t2, t2, a0
	
	#check apple
	lw t3, 0(t2)
	lw t4, apple_color
	beq t3, t4, grow_snake2
	
	#remove tail
	lw t2, 0(s5)
	lw t0, black_color
	sw t0, 0(t2)
	
	call shift_snake2_array
	j update2_done


grow_snake2:
	lw t0, snake2_length
	addi t0, t0, 1
	la t1, snake2_length
	sw t0, 0(t1)
	call increase_score
	call spawn_apple
	call shift_snake2_array

update2_done:
	#paint new head
	lw a1, head2_x
	lw a2, head2_y
	call get_address
	lw t3, screen
	add t4, t3, a0
	lw t5, snake2_head_color
	sw t5, 0(t4)
	
	#store in array
	li a0, 0
	mv a1, t4
	call store_address_snake2
	
	lw s5, 12(sp)
	lw ra, 16(sp)
	addi sp, sp, 20
	ret

shift_snake2_array:
	lw t0, snake2_length
	addi t0, t0, -1
	blez t0, s2_done
	la t1, snake2
s2_loop:
	slli t2, t0, 2
	add t3, t1, t2
	addi t4, t3, -4
	lw t5, 0(t4)
	sw t5, 0(t3)
	addi t0, t0, -1
	bgtz t0, s2_loop
s2_done:
	ret

store_address_snake2:
	la a2, snake2
	slli a0, a0, 2
	add a2, a2, a0
	sw a1, 0(a2)
	ret

# Check collisions between snakes
check_snake_collisions:
	addi sp, sp, -16 
	sw ra, 12(sp) 
	
	# Get head positions 
	lw t0, head1_x 
	lw t1, head1_y 
	lw t2, head2_x
	lw t3, head2_y 
	
	#checking if heads collide
	bne t0, t2, check_p1_body 
	bne t1, t3, check_p1_body 
	
	#heads collided
	lw t4, snake1_length 
	lw t5, snake2_length 
	beq t4, t5, tie_game 
	bgt t4, t5, game_over_p1_wins 
	j game_over_p2_wins

check_p1_body:

	#check if player 1 head collides with player 2 body
	mv a0, t0 
	mv a1, t1 
	la a2, snake2 
	lw a3, snake2_length 
	call check_point_in_snake 
	bnez a0, game_over_p2_wins # P1 hit P2 s body  P1 loses
	
check_p2_body: 

	#check if player 2 head collides with player 1 body
	mv a0, t2 
	mv a1, t3 
	la a2, snake1
	lw a3, snake1_length 
	call check_point_in_snake 
	bnez a0, game_over_p1_wins #P2 hit P1 s body then P2 loses
	
	#no collision
	lw ra, 12(sp) 
	addi sp, sp, 16 
	ret 

#checking if point is in snake array a2 of length a3
check_point_in_snake:
	addi sp, sp, -16
	sw ra, 12(sp)
	
	li t0, 0 
	mv t1, a2 
	mv t2, a3 
	
	#converting coordinates to screen address for comparison
	mv t3, a0
	mv t4, a1
	mv a1, t3
	mv a2, t4
	call get_address
	lw t5, screen
	add t5, t5, a0		
	
	mv a1, t3
	mv a2, t4
	
	mv a0, t3
	mv a1, t4

check_loop: 
	bge t0, t2, point_not_found
	lw t3, 0(t1) 		#load segment address
	beq t3, t5, point_found
	addi t1, t1, 4 
	addi t0, t0, 1 
	j check_loop 

point_found:
	li a0, 1
	j point_check_done
	
point_not_found:
	li a0, 0 

point_check_done:
	lw ra, 12(sp)
	addi sp, sp, 16
	ret 

game_over_p1_wins: 
	la a0, player1_wins
	li a7, 4
	ecall
	j game_over_end

game_over_p2_wins:
	la a0, player2_wins 
	li a7, 4 
	ecall
	j game_over_end
	
tie_game: 
	la a0, tie
	li a7, 4 
	ecall 

game_over_end: 
	la a0, score_msg 
	li a7, 4 
	ecall 
	lw a0, score 
	li a7, 1 
	ecall 
	
	#for a new line
	li a0, 10
	li a7, 11
	ecall
	
	call death_anim
	li a7, 10
	ecall

display_score:
	addi sp, sp, -16
	sw ra, 12(sp)
	
	la a0, score_msg
	li a7, 4
	ecall
	
	lw a0, score
	li a7, 1
	ecall
	
	li a0, 10
	li a7, 11
	ecall
	
	lw ra, 12(sp)
	addi sp, sp, 16
	ret

#increase score by 1
increase_score:
	addi sp, sp, -16
	sw ra, 12(sp)
	
	la t0, score
	lw t1, 0(t0)
	addi t1, t1, 1
	sw t1, 0(t0)
	
	call display_score
	
	lw ra, 12(sp)
	addi sp, sp, 16
	ret

#apple at random location
spawn_apple:
	addi sp, sp, -16
	sw ra, 12(sp)

spawn_try:
	#random x 
	li a7, 42
	li a0, 0
	li a1, 30
	ecall
	addi t0, a0, 1
	
	#random y 
	li a7, 42
	li a0, 0
	li a1, 30
	ecall
	addi t1, a0, 1
	
	#get screen address
	mv a1, t0
	mv a2, t1
	call get_address
	lw t2, screen
	add t2, t2, a0
	
	# Check if location is empty (black)
	lw t3, 0(t2)
	lw t4, black_color
	bne t3, t4, spawn_try
	
	#paint apple
	lw t4, apple_color
	sw t4, 0(t2)
	
	lw ra, 12(sp)
	addi sp, sp, 16
	ret


difficulty_select:
	li a0, 100
	li a7, 32
	ecall

	la t0, input
	lw t0, 4(t0)
	lw t0, 0(t0)

	la t2, difficulty_ms

	li t1, 49	# '1'
	li t3, 200
	sw t3, 0(t2)
	beq t0, t1, difficulty_end
	
	li t1, 50	# '2'
	li t3, 100
	sw t3, 0(t2)
	beq t0, t1, difficulty_end
	
	li t1, 51	# '3'
	li t3, 50
	sw t3, 0(t2)
	beq t0, t1, difficulty_end

	j difficulty_select

difficulty_end:
	ret

#flash screen red
death_anim:
	lw t0, screen
	li t1, 0x00FF0000	# Red
	lw t2, total_bytes
	add t3, t0, t2
	mv t4, t0
	
death_loop:
	bge t4, t3, death_sleep
	sw t1, 0(t4)
	addi t4, t4, 4
	j death_loop
	
death_sleep:
	li a0, 2000
	li a7, 32
	ecall
	ret

#convert coordinates to screen offset
get_address:
	slli a0, a2, 5	# y*32
	add a0, a0, a1	# +x
	slli a0, a0, 2	# *4 (bytes per pixel)
	ret

#draw border around play area
draw_border:
	li t0, 0
	lw t1, total_bytes
	lw t2, bytes_per_row

db_loop:
	bge t0, t1, db_end

	rem t3, t0, t2
	beqz t3, db_draw	#left edge

	addi t4, t0, 4
	rem t3, t4, t2
	beqz t3, db_draw	#right edge

	blt t0, t2, db_draw	#top row
	sub t5, t1, t2
	bge t0, t5, db_draw	#bottom row

	j db_next

db_draw:
	add t6, a0, t0
	sw a1, 0(t6)

db_next:
	addi t0, t0, 4
	j db_loop

db_end:
	ret


start_screen:
    addi sp, sp, -16
    sw ra, 0(sp)
    
    li a0, 0x00FF40DD  
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

draw_obstacles:
    addi sp, sp, -16
    sw ra, 0(sp)
    
    lw a0, obstacle_color
    lw a1, screen

    # Block 1 (2x2 square at 23,4)
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
    
    # Block 2 (horizontal line at y=8, x=1-14)
    li a3, 8
    li a2, 1
    call draw_at
    li a2, 2
    call draw_at
    li a2, 3
    call draw_at
    li a2, 4
    call draw_at
    li a2, 5
    call draw_at
    li a2, 6
    call draw_at
    li a2, 7
    call draw_at
    li a2, 8
    call draw_at
    li a2, 9
    call draw_at
    li a2, 10
    call draw_at
    li a2, 11
    call draw_at
    li a2, 12
    call draw_at
    li a2, 13
    call draw_at
    li a2, 14
    call draw_at
    
    # Block 3 (horizontal line at y=12, x=17-30)
    li a3, 12
    li a2, 17
    call draw_at
    li a2, 18
    call draw_at
    li a2, 19
    call draw_at
    li a2, 20
    call draw_at
    li a2, 21
    call draw_at
    li a2, 22
    call draw_at
    li a2, 23
    call draw_at
    li a2, 24
    call draw_at
    li a2, 25
    call draw_at
    li a2, 26
    call draw_at
    li a2, 27
    call draw_at
    li a2, 28
    call draw_at
    li a2, 29
    call draw_at
    li a2, 30
    call draw_at
    
    
    li a3, 16
    li a2, 1
    call draw_at
    li a2, 2
    call draw_at
    li a2, 3
    call draw_at
    li a2, 4
    call draw_at
    li a2, 5
    call draw_at
    li a2, 6
    call draw_at
    li a2, 7
    call draw_at
    li a2, 8
    call draw_at
    li a2, 9
    call draw_at
    li a2, 10
    call draw_at
    li a2, 11
    call draw_at
    li a2, 12
    call draw_at
    li a2, 13
    call draw_at
    li a2, 14
    call draw_at
    
   
    li a3, 20
    li a2, 17
    call draw_at
    li a2, 18
    call draw_at
    li a2, 19
    call draw_at
    li a2, 20
    call draw_at
    li a2, 21
    call draw_at
    li a2, 22
    call draw_at
    li a2, 23
    call draw_at
    li a2, 24
    call draw_at
    li a2, 25
    call draw_at
    li a2, 26
    call draw_at
    li a2, 27
    call draw_at
    li a2, 28
    call draw_at
    li a2, 29
    call draw_at
    li a2, 30
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
    
    # At (22,26)
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

clear_screen:
    addi sp, sp, -16
    sw ra, 12(sp)
    
    lw t0, screen
    lw t1, black_color
    lw t2, total_bytes
    add t3, t0, t2
    mv t4, t0

cs_loop:
    bge t4, t3, cs_done
    sw t1, 0(t4)
    addi t4, t4, 4
    j cs_loop
    
cs_done:
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
    
draw_at:
	slli t0,a3, 5 
	add t0,t0,a2
	slli t0, t0, 2 
	add t1, a1, t0
	sw a0, 0(t1) 
	ret
 	
