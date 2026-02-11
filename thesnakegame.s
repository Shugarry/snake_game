# SNAKE GAME (Group 2)
#s0-s11: savede register 
#t0-t6: temporary register 
#a0-a7: argument register 

# s registers: global constant values
# t registers: temp variable registers

# WIDTH x HEIGHT = 256 x 256
# Pixel size: 8 
.data	#define the state of the game 
	#10 segment maximum (10 x 4 bytes) 
	snake:			.space 40	# each element is a word(4 bytes) poiting to screen location 
	
	#initial head position at (16x16)- center of 32x32 of the grid 
	head_x:			.word 16	# x, y coords for head
	head_y:			.word 16
	
	#color definition in ARGB format( 00 Aplha, RR red, GG green  BB blue)
	#each color is 4 bytes: 0x00RRGGBB 
	border_color:	.word 0x000000FF #BLUE
	snake_color:	.word 0x0000FF00 #GREEN
	apple_color:	.word 0x00FF0000 #RED 
	text_color:		.word 0x00BBBBBB #GRAY TEXT 
	
	#MEMORY-MAPPED DISPLAY BASE ADDRESS 
	#BITMAP DISPLAY STARTS AT 0X10040000(HEAP) 
	screen:			.word 0x10040000	# screen address
	
	#DISPLAYING CONFIGURATION CONSTANTS 
	#SCREEN_ 256 X 256 PIXELS, EACH GAME UNIT 8X8 PIXELS 
	pixel_size:		.word 8
	length:			.word 256	# screen len/width
	width:			.word 256
	
	#GRID DIMENSION: 256 PIXELS / 8 PIXELS = 32 UNITS 
	row_width:		.word 32 #UNITS PER ROW
	bytes_p_pixel:	.word 4 #EACH PIXEL = 4 BYTES(RGBA) 
	
	
	#new variables 
	vel_x:  .word 1 
	vel_y: .word 0
	black: .word 0x00000000
	input: .word 0xFFFF0000 #keyboard control address 
	
	paused: .word 0 
	pause_key : .word 112 

.text
.globl main


main:
	#DRAWING TEXT/NAME ON SCREEN 
	#A0= COLOR, A1= SCREEN, A2=X, A3=Y
	
	# Text on screen
	lw a0, text_color #LOAD TEXT COLOR(GRAY)
	lw a1, screen #LOAD SCREEN BASE ADDRESS
	
	
	#DRAWING PIXEL AT (1,1)- PART OF a LETTER 
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
	#WE CAN SEE HUNDRERD MORE SIMILAR CALLS AND THIS FRAW "SNAKE GAME" or somthing similar on the screen 
	
	#initalize and render 2-segment snake 
	#calculate head position address 
	#store in snake[0]
	# Load head coords and screen ADDRESSES/COLORS INTO SAVED REGISTERS 
	lw s0, screen #S0 = SCREEN BASE ADDRESS 
	lw s1, snake_color #S1= SNAKE COLOR
	lw s2, head_x #S2= head X coordinate 
	lw s3, head_y #s3= head Y coodirnate 
	
	
	#head
	#calculate address for head at (head_x, head_y) 
	mv a1, s2 #a1 = head_x (argument for fucntion) # Args for offset calc (head_x = a1, head_y = a2)
	mv a2, s3 #a2 = head_y (arguemnt for function) 
	
	# Calculate offset, stored in a0
	call head_offset_calc #returns offset in a0 
	
	#calculate aactual memory address: screen + offset 
	# Add the offset to the "pointer", store in t0
	add t0, s0, a0
	
	#paint head green 
	# Change pixel color
	sw s1, 0(t0) #store color at calculated address 
	
	# Store the "coordinate" in the array /store address in snake array at index 0 
	li a0, 0	# Store in 0 offset of snake array, first position, a0= array index(0 for head)
	mv a1, t0	# Argument for address to store, a1= address to store
	call store_address_snake
	
	
	
	
	#first body segment (x-1, y) 
	# same steps as before but for "tail" of the snake	
	li t0, -1 #t0 = -1 (move left from head9 
	mv a1, s2 #reset for head_x 
	mv a2, s3 #reset for head_y 
	
	
	add a1, a1, t0	# for tail subtract 1 to x coord a1= head_x -1
	call head_offset_calc #calcualte offset
	add t0, s0, a0 # get actual address
	sw s1, 0(t0) #paint in screen 
	
	li a0, 1	# second index of array/ store at index 1 
	mv a1, t0
	call store_address_snake
	
	
	#second body segment (x-2,y) 
	# repeat for second block of tail
	li t0, -2 #t0=-2 (two left from head) 
	mv a1, s2
	mv a2, s3
	
	add a1, a1, t0	# for tail subtract 1 to x coord / a1 = head_x - 2 
	call head_offset_calc
	add t0, s0, a0
	sw s1, 0(t0) #paint green
	
	li a0, 2	# second index of array/ store in index 2 
	mv a1, t0
	call store_address_snake

	# Bonus part: coloring and letters
	#challenge A: drawing border around screen 
	#top row (y=0); x=0 to x=31 
	#botton row (y=31): x=0 to x=31 
	#left column (x=0): y=0 to y=31 
	#right column (x=31): y=0 to y=31
	
	lw t0, border_color #t0 = blue color
	lw t6, screen #t6 = screen pointer 
	
	
	#top border (y=0) 
	#manually draws 32 pixels acrros top row
	#each sw writes 4 bytes(one pixel) 
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
	#until complete the 32 pixels 
	
	#botton border (y=31) 
	#jump to last row: offset = 31 rows x 128 bytes/row = 3968
	li t1, 3968 #t1 = 31 x 128 
	add t6, t6, t1 #move pointer to row 31 

	sw t0, 0(t6) #pixel at (0,31)
	sw t0, 4(t6) #pixel at (1,31)
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
	
	
	#left and right bordes (x=0 to x=31)
	#draw vertical lines using loop-like pattern
	lw t6, screen
	addi t6, t6, 128 #move to row 1 
	sw t0, 0(t6) #left border at (0,1) 
	sw t0, 124(t6) #right border at (31,1) offset 31x4=124 
	#repeat until 32 bits 
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
	j main_loop 

#function_ head_offset cal 
#calculate byte offset from screen base for given (x,y) coordinates 
#formula: offset = ((y*32) + x) x4
#optimized: y<<5(x32) + x, then <<2(x4) 
#a0 = byte offset from screen base 
# a1 -> head_x coord (0-31)
# a2 -> head_y coord (0-31) 
# ret -> offset

head_offset_calc:
	#y * 32 (since grid is 32 units wide) 
	slli a0, a2, 5	# head_y x 32 a= = y << 5 = y x 32
	
	#add x coordinates 
	add a0, a0, a1	# add head_x  a0 = (y x 32) + x 
	
	#multiply by 4 (bytes per pixel) 
	slli a0, a0, 2	# multiply by 4 #a0 = ((y x 329 + x ) x 4 
	
	
	ret #offset 

#fucntion_store_address_snake 
#stores a screen address in the snake array at specified index 
# a0 -> array index
# a1 -> memory address / argument to store
# ret -> NONE

store_address_snake:
	#load base address of snake array 
	la a2, snake	# load snake array
	
	#calcualte byte offset: index x 4 (since words are 4 bytes) 
	#a0 = index x 4 
	slli a0, a0, 2	# multiply array index by 4 to get offset since we are working with words, 4 bytes each
	
	#add offset to base address
	# a2= &snake[index] 
	add	a2, a2, a0	# add offset to address
	
	#store the address in the array 
	sw a1, 0(a2)	# store address inside index of "array"
	
	ret


#function draw at 
# a0 -> color of pixel to draw /4 bytes ARGB)
# a1 -> address of screen bitmap
# a2 -> x coord (0-31)
# a3 -> y coord  (0.31) 
# ret -> NONE
draw_at:
	#CALCULATE OFFSET: (Y x 32 + X) x 4 
	slli t0, a3, 5 #t0 = y x 32
	add t0, t0, a2 #add: t0= (y x 32 + x )
	slli t0, t0, 2 #t0 = (y x 32 + x ) x 4
	
	
	#calculate final memory addressn
	add t1, a1, t0  #t1 = screen + offset 
	
	#write color to memory 
	sw a0, 0(t1) #pain the pixel 
	ret

main_loop:
	#cal check_pause key 
	#check key board 
	la t0, input 
	lw t0, 0(t0) 
	lw t1, 0(t0) 
	beqz t1, no_input #if 0 no key pressed 
	 
	#key pressed 
	lw t2, 4(t0) #if it is 1, load the value of offset 4(the key) 
	
	#comparing with ASCII 
	li t3, 119 
	beq t2,t3, key_w 
	
	li t3, 97 
	beq t2, t3, key_a 
	
	li t3, 115
	beq t2, t3, key_s
	
	li t3, 100 
	beq t2, t3, key_d  #if key == d, jump to key_d 
	j no_input 

key_w:
    la t5, vel_x        # Load ADDRESS of vel_x
    sw zero, 0(t5)      # Store 0 to vel_x
    la t5, vel_y        # Load ADDRESS of vel_y  
    li t4, -1
    sw t4, 0(t5)        # Store -1 to vel_y
    j input_checked

key_s:
    la t5, vel_x        # Load ADDRESS of vel_x
    sw zero, 0(t5)      # Store 0 to vel_x
    la t5, vel_y        # Load ADDRESS of vel_y
    li t4, 1
    sw t4, 0(t5)        # Store 1 to vel_y
    j input_checked
    
key_a: 
    la t5, vel_x        # Load ADDRESS of vel_x
    li t4, -1
    sw t4, 0(t5)        # Store -1 to vel_x
    la t5, vel_y        # Load ADDRESS of vel_y
    sw zero, 0(t5)      # Store 0 to vel_y
    j input_checked

key_d:
    la t5, vel_x        # Load ADDRESS of vel_x
    li t4, 1 
    sw t4, 0(t5)        # Store 1 to vel_x
    la t5, vel_y        # Load ADDRESS of vel_y
    sw zero, 0(t5)      # Store 0 to vel_y
    j input_checked
    
    
no_input: 
	#continue movement 

input_checked:

    
    	#load address of the tail
    	la t3, snake 
    	lw t4, 8(t3)
    
    	#store the color black at that address 
    	la t5, black 
    	lw t5, 0(t5) 
    	sw t5, 0(t4) 
    
    	#load the value of offset 4 and store it at offset 8 
    	lw t4, 4(t3) 
    	sw t4, 8(t3) 
    
    	#offset 0 to offset 4 
    	lw t4, 0(t3) 
    	sw t4, 4(t3) 
    
    	# Load current head position
    	la t0, head_x      # Load address of head_x
    	lw t5, 0(t0)       # Load head_x value
    
    	la t0, head_y      # Load address of head_y
    	lw t6, 0(t0)       # Load head_y value
    
    #load velocity 
    la t0, vel_x       # Load address of vel_x
    lw t1, 0(t0)       # Load vel_x value
    
    la t0, vel_y       # Load address of vel_y
    lw t2, 0(t0)       # Load vel_y value
    
    #calculate new position 
    add t5, t5, t1     # new_x = head_x + vel_x
    add t6, t6, t2     # new_y = head_y + vel_y 
    
    #store new position 
    la t0, head_x      # Load address of head_x
    sw t5, 0(t0)       # Store new x position
    
    la t0, head_y      # Load address of head_y
    sw t6, 0(t0)       # Store new y position
    
    mv a1, t5
    mv a2, t6
    call head_offset_calc
    
    la t0, screen      # Load address of screen variable
    lw t0, 0(t0)       # Load screen base address
    add t4, t0, a0     # Calculate screen address
    
    sw t4, 0(t3)       # Store new head address in snake[0]
    
    la t5, snake_color # Load address of snake_color
    lw t5, 0(t5)       # Load snake_color value
    sw t5, 0(t4)       # Draw new head green

    li a0, 100 
    li a7, 32 
    ecall 
    j main_loop

game_over: 
	j game_over 