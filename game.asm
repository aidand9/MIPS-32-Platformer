#####################################################################
#
# CSCB58 Winter 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Aidan Del Monte, Student Number: 1008161034, UTorID: delmon13, official email: aidan.delmonte@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 512 
# - Display height in pixels: 512 
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Finished milestones 1, 2, and 3
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Health
# 2. Fail condition
# 3. Win Condition
# 4. Disappearing platforms
# 5. Pick-up effects
# 6. Moving Objects
#
# Link to video demonstration for final submission:
# - https://play.library.utoronto.ca/watch/efb4249c069ec816659f36d84dd6b2f6
#
# Are you OK with us sharing the video with people outside course staff?
# - Yes 
#
# Any additional information that the TA needs to know:
# - N/A
#
#####################################################################
.eqv BASE_ADDRESS 0x10008000	# Framebuffer address
.eqv REFRESH 180

# Colors
.eqv BACKGROUND_COLOUR 0x00000000	# Black
.eqv PLATFORM_COLOUR 0x0000FF	# Blue
.eqv PLAYER_COLOUR 0xFF00FF	# Magenta
.eqv PICKUP1_COLOUR 0xFFFF00	# Yellow
.eqv PICKUP2_COLOUR 0x0000ff00	# Green
.eqv PICKUP3_COLOUR 0x00FF5F1F  # Orange
.eqv ENEMY_COLOUR 0xFF0000	# Red
.eqv BORDER_COLOUR 0x0040E0D0   # Turquoise
.eqv WIN_COLOUR 0x008d8c8a	# Silver
.eqv TEXT_COLOUR 0x00FFFFFF	# White


.data     


.text
.globl main

main:
	
    # Clear the screen with the background color
  	li $t7, 0
  	addi $a0, $zero, BACKGROUND_COLOUR
    	jal fill_screen
    	
    	addi $a0, $zero, BORDER_COLOUR
    	li $a1, 64
    	li $a2, 0
    	li $a3, 0
    	jal draw_platform
    	
    	addi $a0, $zero, BORDER_COLOUR     # Draw the turquoise borders
    	li $a1, 64
    	li $a2, 0
    	li $a3, 0
    	jal draw_vertical_border
    	
    	addi $a0, $zero, BORDER_COLOUR
    	li $a1, 64
    	li $a2, 63
    	li $a3, 0
    	jal draw_vertical_border
    	
    	addi $a0, $zero, BORDER_COLOUR
    	li $a1, 64
    	li $a2, 0
    	li $a3, 63
    	jal draw_platform
    	
    	# Colour of platform to be drawn=$a0
    	# Length of platform to be drawn=$a1
    	# X value of platform to be drawn=$a2
    	# Y value of platform to be drawn=$a3
    	
    	addi $a0, $zero, PLATFORM_COLOUR	  
    	li $a1, 62        
    	li $a2, 1	    # Draw the floor platform
    	li $a3, 50      
    	jal draw_platform
    	
    	li $a1, 29
    	li $a2, 1      # Draw the second level, the platform on the left
    	li $a3, 33
    	jal draw_platform
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 5
    	li $a2, 40          # Drawing the enemy "platforms"
    	li $a3, 33
    	jal draw_platform
    	
    	addi $a0, $zero, PLATFORM_COLOUR   	
    	li $a1, 8
    	li $a2, 55       # Draw the second level, the platform on the right
    	li $a3, 33
    	jal draw_platform
    	
    	addi $a0, $zero, PLATFORM_COLOUR
    	li $a1, 41
    	li $a2, 1      # Draw the third level, the platform on the left
    	li $a3, 16
    	jal draw_platform
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 7                      # Draw the enemy platform
    	li $a2, 56
    	li $a3, 16
    	jal draw_platform
    	
    	# Now we will draw the player and the items and enemies, the only arguments are $a0 which will be the colour, $a1 which is the x value, $a2 which is the y value
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	addi $a0, $zero, WIN_COLOUR
    	li $a1, 5	# This is the x value of the win condition
    	li $a2, 8	# This is the y value of the win condition
    	li $a3, 1
    	jal draw_player
    	
    	addi $a0, $zero, PICKUP1_COLOUR
    	li $a1, 40 
    	li $a2, 25
    	move $s2, $a1
    	move $s3, $a2
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, PICKUP2_COLOUR
    	li $a1, 50                        # Draw the pickups
    	li $a2, 45
    	move $s4, $a1
    	move $s5, $a2
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, PICKUP3_COLOUR
    	li $a1, 28
    	li $a2, 12
    	move $s6, $a1
    	move $s7, $a2
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 15
    	li $a2, 49
    	li $a3, 0
    	jal draw_player                # Draw the enemies
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 15
    	li $a2, 36
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 20
    	li $a2, 10
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 3
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR    # Draw the HP bars
    	li $a1, 18
    	li $a2, 3
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 3
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 3
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 3
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 3
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 3
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 3
    	li $a3, 53
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	li $t9, 2
    	
    	jal gameloop

    	
    	
draw_player:
	
	sll $t0, $a2, 6 # Multipy y by 64
	add $t0, $t0, $a1 # Now $t0 holds y*width + x
	sll $t0, $t0, 2  
	li $t1, BASE_ADDRESS
	add $t1, $t1, $t0  # $t1 = base_address + offset
	
	sw $a0, 0($t1)
	sw $a0, 4($t1)
	sw $a0, 8($t1)
	
	subi, $a2, $a2, 1
	sll $t0, $a2, 6 # Multipy y by 64
	add $t0, $t0, $a1 # Now $t0 holds y*width + x
	sll $t0, $t0, 2  
	li $t1, BASE_ADDRESS
	add $t1, $t1, $t0  # $t1 = base_address + offset
	
	sw $a0, 0($t1)
	
	bne $a3, 1, not_player
	addi $t8, $zero, PICKUP2_COLOUR
	sw $t8, 4($t1)
	j continue
	
	
not_player:
	
	sw $a0, 4($t1)
	
continue:	
	sw $a0, 8($t1)
	
	subi, $a2, $a2, 1
	sll $t0, $a2, 6 # Multipy y by 64
	add $t0, $t0, $a1 # Now $t0 holds y*width + x
	sll $t0, $t0, 2  
	li $t1, BASE_ADDRESS
	add $t1, $t1, $t0  # $t1 = base_address + offset
		
	sw $a0, 0($t1)
	sw $a0, 4($t1)
	sw $a0, 8($t1)
	
	jr $ra
    	  	


gameloop:
	
	addi $a0, $zero, PLAYER_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 1
    	jal draw_player
	
	addi $t7, $t7, 1
	andi $t6, $t7, 1
	
	beqz $t6, even
	
odd:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 15
    	li $a2, 36
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 15
    	li $a2, 49
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 15
    	li $a2, 37
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 15
    	li $a2, 48
    	li $a3, 0
    	jal draw_player
    	
    	j passed
	
	
even:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 15
    	li $a2, 37
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 15
    	li $a2, 48
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 15
    	li $a2, 36
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, ENEMY_COLOUR
    	li $a1, 15
    	li $a2, 49
    	li $a3, 0
    	jal draw_player	


passed:	
	
	li $t0, 0xffff0000
	lw $t1, 0($t0)
	bne $t1, 1, gravity  # If no keyboard input, jump to gravity
	lw $t1, 4($t0)
	
	
	
	


input_p:	
	bne $t1, 112, not_p


	j main # If p is pressed, reset program
	
	
not_p:
	
	bne $t1, 100, not_d # If keyboard input isn't d jump to not_d case
	
	
input_d:   	
	
	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, 3
	sll $t1, $t1, 2
	
	add $t0, $t0, $t1
	lw $t3, 0($t0)
	
	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	subi $t1, $t1, 64
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, 3
	sll $t1, $t1, 2
	
	add $t0, $t0, $t1
	lw $t4, 0($t0)

	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	subi $t1, $t1, 128
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, 3
	sll $t1, $t1, 2
	
	add $t0, $t0, $t1
	lw $t5, 0($t0)
	
	
	beq $t3, BORDER_COLOUR, gravity      # If the pixel that we are moving to is a border/platform, don't allow the user to move
	beq $t4, BORDER_COLOUR, gravity
	beq $t5, BORDER_COLOUR, gravity
	beq $t3, PLATFORM_COLOUR, gravity
	beq $t4, PLATFORM_COLOUR, gravity
	beq $t5, PLATFORM_COLOUR, gravity
	
	
	beq $t3, PICKUP2_COLOUR, pickup_2d  # If the pixel we are trying to move to has color PICKUP2_COLOUR, handle the case
	beq $t4, PICKUP2_COLOUR, pickup_2d
	beq $t5, PICKUP2_COLOUR, pickup_2d
	j not_pickup_2d
	
# This is the pickup that increases hp
pickup_2d:
	# Redraw the player as the color of the item it just picked up quickly
	addi $a0, $zero, PICKUP2_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player             
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s4
    	move $a2, $s5
    	li $a3, 0                 # Remove the item from the screen
    	jal draw_player
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	addi $t9, $t9, 1  # This is the HP Count
    	
    	bne $t9, 3, pickup_d_not_3      
    	
pickup_d_3:     # If the new hp count is equal to 3, draw the third HP bar

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR        
    	li $a1, 18
    	li $a2, 43
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 53
    	jal draw_platform	
	
	j gravity

pickup_d_not_3:

    	addi $a0, $zero, PLAYER_COLOUR  # If the HP is equal to 2, draw the second HP bar
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	j gravity

				
not_pickup_2d:
	
	
	beq $t3, PICKUP1_COLOUR, pickup_1d 
	beq $t4, PICKUP1_COLOUR, pickup_1d
	beq $t5, PICKUP1_COLOUR, pickup_1d
	j not_pickup_1d

	# This is the pickup that makes a platform disappear	
pickup_1d:

	addi $a0, $zero, PICKUP1_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s2
    	move $a2, $s3
    	li $a3, 0           # Clear the item from the screen
    	jal draw_player
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 41
    	li $a2, 1      # Make the platform disappear
    	li $a3, 16
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 8
    	li $a2, 55      # Make the platform disappear
    	li $a3, 33
    	jal draw_platform
    	


    	
    	
    	j gravity

	
not_pickup_1d:
	
	beq $t3, WIN_COLOUR, win_d
	beq $t4, WIN_COLOUR, win_d
	beq $t5, WIN_COLOUR, win_d
	j not_win_d


win_d:

	j you_win

	

not_win_d:

	beq $t3, PICKUP3_COLOUR, pickup3_ability
	beq $t4, PICKUP3_COLOUR, pickup3_ability
	beq $t5, PICKUP3_COLOUR, pickup3_ability
				
					
	beq $t3, ENEMY_COLOUR, enemy_on_d
	beq $t4, ENEMY_COLOUR, enemy_on_d
	beq $t5, ENEMY_COLOUR, enemy_on_d
	j not_enemy_on_d
	
enemy_on_d:
	
	# Draw the player as red temporarily
	addi $a0, $zero, ENEMY_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	li $v0, 32
    	li $a0, REFRESH
	syscall
	
	subi $t9, $t9, 1 # Subtract one from the HP bar
	
	bne $t9, 2, not_two_d

# If they now have 2 lives, remove the third hp bar and reset them to spawn
two_d:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 53
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	li $a3, 0
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	j gravity
	

# If they have 0 lives, send them to the game over screen
not_two_d:

	bne $t9, 1, game_over

# If they now have one life, remove the second HP bar
one_d:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	li $a3, 0
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player	
	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	j gravity
	
	
# This is the case where the player is allowed to move
not_enemy_on_d:	
	# Clear the old location of the player
	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player 
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	# Draw the player at the new location
    	addi $a0, $zero, PLAYER_COLOUR
    	addi $s0, $s0, 1
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 1
    	jal draw_player
    	

    	
    	j gravity
    	
not_d:

	bne $t1, 97, not_a
input_a:

	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, -1
	sll $t1, $t1, 2

	add $t0, $t0, $t1
	lw $t3, 0($t0)
	
	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	subi $t1, $t1, 64
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, -1
	sll $t1, $t1, 2

	add $t0, $t0, $t1
	lw $t4, 0($t0)
	
	
	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	subi $t1, $t1, 128
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, -1
	sll $t1, $t1, 2

	add $t0, $t0, $t1
	lw $t5, 0($t0)

	beq $t3, BORDER_COLOUR, gravity      # If the pixel that we are moving to is a border/platform, don't allow the user to move
	beq $t4, BORDER_COLOUR, gravity
	beq $t5, BORDER_COLOUR, gravity
	beq $t3, PLATFORM_COLOUR, gravity
	beq $t4, PLATFORM_COLOUR, gravity
	beq $t5, PLATFORM_COLOUR, gravity
	
	beq $t3, PICKUP2_COLOUR, pickup_2a
	beq $t4, PICKUP2_COLOUR, pickup_2a
	beq $t5, PICKUP2_COLOUR, pickup_2a
	j not_pickup_2a
	
pickup_2a:

	addi $a0, $zero, PICKUP2_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s4
    	move $a2, $s5
    	li $a3, 0
    	jal draw_player
    	
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	addi $t9, $t9, 1

    	bne $t9, 3, pickup_a_not_3
    	
pickup_a_3:

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 53
    	jal draw_platform	
	
	j gravity

pickup_a_not_3:

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	j gravity		
	
	
	
not_pickup_2a:
	
	
	beq $t3, PICKUP1_COLOUR, pickup_1a
	beq $t4, PICKUP1_COLOUR, pickup_1a
	beq $t5, PICKUP1_COLOUR, pickup_1a
	j not_pickup_1a
	
pickup_1a:

	addi $a0, $zero, PICKUP1_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s2
    	move $a2, $s3
    	li $a3, 0
    	jal draw_player
    	
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 41
    	li $a2, 1      # Draw the third level, the platform on the left
    	li $a3, 16
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 8
    	li $a2, 55      # Make the platform disappear
    	li $a3, 33
    	jal draw_platform
    	

    	
    	j gravity

	
not_pickup_1a:
		
	beq $t3, WIN_COLOUR, win_a
	beq $t4, WIN_COLOUR, win_a
	beq $t5, WIN_COLOUR, win_a
	j not_win_a
	
win_a:

	j you_win


	
not_win_a:	
	
	beq $t3, PICKUP3_COLOUR, pickup3_ability
	beq $t4, PICKUP3_COLOUR, pickup3_ability
	beq $t5, PICKUP3_COLOUR, pickup3_ability				
						
	beq $t3, ENEMY_COLOUR, enemy_on_a
	beq $t4, ENEMY_COLOUR, enemy_on_a
	beq $t5, ENEMY_COLOUR, enemy_on_a
	j not_enemy_on_a
	
enemy_on_a:

	addi $a0, $zero, ENEMY_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
	subi $t9, $t9, 1
	
	bne $t9, 2, not_two_a

two_a:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 53
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	li $a3, 0
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	j gravity
	


not_two_a:

	bne $t9, 1, game_over
	
one_a:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	li $a3, 0
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player	
	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	j gravity
    		
	



not_enemy_on_a:
	
	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	addi $s0, $s0, -1
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 1
    	jal draw_player
	
	j gravity
	
	
not_a:

	bne $t1, 119, not_w
	
	
input_w:


	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	subi $t1, $t1, 192
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	sll $t1, $t1, 2

	add $t0, $t0, $t1
	lw $t3, 0($t0)
	
	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	subi $t1, $t1, 192
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, 1
	sll $t1, $t1, 2

	add $t0, $t0, $t1
	lw $t4, 0($t0)
	
	
	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	subi $t1, $t1, 192
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, 2
	sll $t1, $t1, 2

	add $t0, $t0, $t1
	lw $t5, 0($t0)
	
	beq $t3, BORDER_COLOUR, end_gameloop      # If the pixel that we are moving to is a border/platform, don't allow the user to move
	beq $t4, BORDER_COLOUR, end_gameloop
	beq $t5, BORDER_COLOUR, end_gameloop
	beq $t3, PLATFORM_COLOUR, end_gameloop
	beq $t4, PLATFORM_COLOUR, end_gameloop
	beq $t5, PLATFORM_COLOUR, end_gameloop
	
	beq $t3, PICKUP2_COLOUR, pickup_2w
	beq $t4, PICKUP2_COLOUR, pickup_2w
	beq $t5, PICKUP2_COLOUR, pickup_2w
	j not_pickup_2w
	


pickup_2w:

	addi $a0, $zero, PICKUP2_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s4
    	move $a2, $s5
    	li $a3, 0
    	jal draw_player
    	
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	addi $t9, $t9, 1
    	
    	bne $t9, 3, pickup_w_not_3
    	
pickup_w_3:

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 53
    	jal draw_platform	
	
	j end_gameloop

pickup_w_not_3:

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	j end_gameloop


not_pickup_2w:

	beq $t3, PICKUP1_COLOUR, pickup_1w
	beq $t4, PICKUP1_COLOUR, pickup_1w
	beq $t5, PICKUP1_COLOUR, pickup_1w
	j not_pickup_1w
	
pickup_1w:

	addi $a0, $zero, PICKUP1_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s2
    	move $a2, $s3
    	li $a3, 0
    	jal draw_player
    	
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 41
    	li $a2, 1      # Draw the third level, the platform on the left
    	li $a3, 16
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 8
    	li $a2, 55      # Make the platform disappear
    	li $a3, 33
    	jal draw_platform
    	

    	
    	j end_gameloop
	
	
	
	
not_pickup_1w:


	beq $t3, WIN_COLOUR, win_w
	beq $t4, WIN_COLOUR, win_w
	beq $t5, WIN_COLOUR, win_w
	j not_win_w
	
win_w:

	j you_win
	
	
	
not_win_w:

	beq $t3, PICKUP3_COLOUR, pickup3_ability_nogravity
	beq $t4, PICKUP3_COLOUR, pickup3_ability_nogravity
	beq $t5, PICKUP3_COLOUR, pickup3_ability_nogravity



	beq $t3, ENEMY_COLOUR, enemy_on_w
	beq $t4, ENEMY_COLOUR, enemy_on_w
	beq $t5, ENEMY_COLOUR, enemy_on_w
	j not_enemy_on_w
	
enemy_on_w:

	addi $a0, $zero, ENEMY_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
	subi $t9, $t9, 1
	
	bne $t9, 2, not_two_w

two_w:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 53
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	li $a3, 0
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	j end_gameloop
	


not_two_w:

	bne $t9, 1, game_over
	
one_w:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	li $a3, 0
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player	
	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	j end_gameloop
	
	
	
not_enemy_on_w:

	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	addi $s1, $s1, -1
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 1
    	jal draw_player
	
	j end_gameloop

not_w:
	
gravity:

	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	addi $t1, $t1, 64
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	sll $t1, $t1, 2
	
	add $t0, $t0, $t1
	lw $t3, 0($t0)
	
	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	addi $t1, $t1, 64
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, 1
	sll $t1, $t1, 2
	
	add $t0, $t0, $t1
	lw $t4, 0($t0)
	
	li $t0, BASE_ADDRESS
	sll $t1, $s1, 6 # Multipy y by 64
	addi $t1, $t1, 64
	add $t1, $t1, $s0 # Now $t0 holds y*width + x
	addi $t1, $t1, 2
	sll $t1, $t1, 2
	
	add $t0, $t0, $t1
	lw $t5, 0($t0)
	
	beq $t3, PLATFORM_COLOUR, end_gameloop
	beq $t4, PLATFORM_COLOUR, end_gameloop
	beq $t5, PLATFORM_COLOUR, end_gameloop
	
	beq $t3, PICKUP2_COLOUR, gravity_pickup2
	beq $t4, PICKUP2_COLOUR, gravity_pickup2
	beq $t5, PICKUP2_COLOUR, gravity_pickup2
	j not_gravity_pickup2
	
	
gravity_pickup2:

	addi $a0, $zero, PICKUP2_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s4
    	move $a2, $s5
    	li $a3, 0
    	jal draw_player
    	
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	
    	addi $t9, $t9, 1
    	bne $t9, 3, pickup_gravity_not_3
    	
pickup_gravity_3:

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 53
    	jal draw_platform	
	
	j end_gameloop

pickup_gravity_not_3:

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	j end_gameloop
	
	
not_gravity_pickup2:


	beq $t3, PICKUP1_COLOUR, gravity_pickup1
	beq $t4, PICKUP1_COLOUR, gravity_pickup1
	beq $t5, PICKUP1_COLOUR, gravity_pickup1
	j not_gravity_pickup1
	
	
	
gravity_pickup1:

	addi $a0, $zero, PICKUP1_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s2
    	move $a2, $s3
    	li $a3, 0
    	jal draw_player
    	
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 41
    	li $a2, 1      # Draw the third level, the platform on the left
    	li $a3, 16
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 8
    	li $a2, 55      # Make the platform disappear
    	li $a3, 33
    	jal draw_platform
    	

    	
    	
    	j end_gameloop
	
	
	
	
not_gravity_pickup1:


	beq $t3, WIN_COLOUR, gravity_win
	beq $t4, WIN_COLOUR, gravity_win
	beq $t5, WIN_COLOUR, gravity_win
	j not_gravity_win
	
	
gravity_win:
	
	j you_win
	
	
	
not_gravity_win:
	
	
	beq $t3, PICKUP3_COLOUR, pickup3_ability_nogravity
	beq $t4, PICKUP3_COLOUR, pickup3_ability_nogravity
	beq $t5, PICKUP3_COLOUR, pickup3_ability_nogravity	
	
	
	beq $t3, ENEMY_COLOUR, enemy_on_gravity
	beq $t4, ENEMY_COLOUR, enemy_on_gravity
	beq $t5, ENEMY_COLOUR, enemy_on_gravity
	j not_enemy_on_gravity
	
		
enemy_on_gravity:

	addi $a0, $zero, ENEMY_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	
	subi $t9, $t9, 1
	
	bne $t9, 2, not_two_gravity

two_gravity:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 43
    	li $a3, 53
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	li $a3, 0
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	j end_gameloop
	


not_two_gravity:

	bne $t9, 1, game_over
	
one_gravity:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 60
    	jal draw_platform

    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 59
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 58
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 57
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 56
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 55
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 54
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	li $a1, 18
    	li $a2, 23
    	li $a3, 53
    	jal draw_platform
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	li $a3, 0
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player	
	
    	addi $a0, $zero, PLAYER_COLOUR
    	li $a1, 1	# This is the x value of the player
    	li $a2, 40	# This is the y value of the player
    	li $a3, 1
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	jal draw_player
    	
    	j end_gameloop
    	
    			
	
	
	
	
not_enemy_on_gravity:
	
	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, PLAYER_COLOUR
    	addi $s1, $s1, 1
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 1
    	jal draw_player



end_gameloop:
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
	j gameloop
	

 
draw_vertical_border:

	sll $a3, $a3, 6 # Multipy y by 64
	add $a3, $a3, $a2 # Now $a3 holds y*width + x
	sll $a3, $a3, 2  
	li $t0, BASE_ADDRESS
	add $t0, $t0, $a3  # $t0 = base_address + offset
	
	li $t1, 0 # Counter
	
vertical_loop:	
	beq $t1, $a1, vertical_end
	sw $a0, 0($t0)
	addi $t1, $t1, 1
	addi $t0, $t0, 256
	j vertical_loop
	
	
	
vertical_end:

	jr $ra
   	   	


    	
draw_platform:
	
	sll $a3, $a3, 6 # Multipy y by 64
	add $a3, $a3, $a2 # Now $a3 holds y*width + x
	sll $a3, $a3, 2  
	li $t0, BASE_ADDRESS
	add $t0, $t0, $a3  # $t0 = base_address + offset
	
	li $t1, 0 # Counter
	
draw_platform_loop:
	beq $t1, $a1, platform_end
	sw $a0, 0($t0)
	addi $t0, $t0, 4
	addi $t1, $t1, 1
	j draw_platform_loop
	


platform_end:
	jr $ra

	

fill_screen:
	
	li $t0, BASE_ADDRESS
    	li $t1, 0  # Loop counter
    
fill_loop:	
	beq $t1, 4096, fill_end
	sw $a0, 0($t0)
	addi $t1, $t1, 1
	addi $t0, $t0, 4
	j fill_loop

    
fill_end:
    	jr $ra
    	
    	
pickup3_ability:

	addi $a0, $zero, PICKUP3_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s6
    	move $a2, $s7
    	li $a3, 0
    	jal draw_player
    	
	addi $a0, $zero, BACKGROUND_COLOUR
	li $a1, 5
	li $a2, 8
	li $a3, 0
	jal draw_player

	addi $a0, $zero, WIN_COLOUR
	li $a1, 55
	li $a2, 8
	li $a3, 1
	jal draw_player  
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	
    	j gravity
    	
    	
pickup3_ability_nogravity:

	addi $a0, $zero, PICKUP3_COLOUR
    	move $a1, $s0	# This is the x value of the player
    	move $a2, $s1	# This is the y value of the player
    	move $s0, $a1   # $s0 will store the current x value of the player
    	move $s1, $a2	# $s1 will store the current y value of the player
    	li $a3, 0
    	jal draw_player
    	
    	addi $a0, $zero, BACKGROUND_COLOUR
    	move $a1, $s6
    	move $a2, $s7
    	li $a3, 0
    	jal draw_player
    	
	addi $a0, $zero, BACKGROUND_COLOUR
	li $a1, 5
	li $a2, 8
	li $a3, 0
	jal draw_player

	addi $a0, $zero, WIN_COLOUR
	li $a1, 55
	li $a2, 8
	li $a3, 1
	jal draw_player  
    	
    	
    	li $v0, 32
    	li $a0, REFRESH
    	syscall
    	
    	
    	j end_gameloop
    	
    	
game_over:
	# Clear screen
    	addi $a0, $zero, BACKGROUND_COLOUR
    	jal fill_screen
    	# Draw all of the letters
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 6
    	li $a2, 10
    	li $a3, 10
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 6
    	li $a2, 11
    	li $a3, 9
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 6
    	li $a2, 11
    	li $a3, 16
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 4
    	li $a2, 16
    	li $a3, 12
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 2
    	li $a2, 14
    	li $a3, 12
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 7
    	li $a2, 20
    	li $a3, 10
    	jal draw_vertical_border

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 21
    	li $a3, 9
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 7
    	li $a2, 26
    	li $a3, 10
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 21
    	li $a3, 12
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 8
    	li $a2, 30
    	li $a3, 9
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 31
    	li $a3, 10
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 32
    	li $a3, 11
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 33
    	li $a3, 12
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 34
    	li $a3, 11
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 35
    	li $a3, 10
    	jal draw_vertical_border

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 8
    	li $a2, 36
    	li $a3, 9
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 7
    	li $a2, 40
    	li $a3, 10
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 41
    	li $a3, 9
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 40
    	li $a3, 13
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 41
    	li $a3, 17
    	jal draw_platform

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 8
    	li $a2, 20
    	li $a3, 30
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 6
    	li $a2, 21
    	li $a3, 29
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 8
    	li $a2, 27
    	li $a3, 30
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 6
    	li $a2, 21
    	li $a3, 38
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 9
    	li $a2, 31
    	li $a3, 29
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 2
    	li $a2, 32
    	li $a3, 38
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 9
    	li $a2, 34
    	li $a3, 29
    	jal draw_vertical_border

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 9
    	li $a2, 38
    	li $a3, 30
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 39
    	li $a3, 29
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 39
    	li $a3, 34
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 39
    	li $a3, 39
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 10
    	li $a2, 47
    	li $a3, 30
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 48
    	li $a3, 29
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 3
    	li $a2, 53
    	li $a3, 30
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 5
    	li $a2, 48
    	li $a3, 33
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 4
    	li $a2, 52
    	li $a3, 34
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 57
    	li $a3, 39
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 9
    	li $a2, 57
    	li $a3, 29
    	jal draw_vertical_border
    	
wait_for_restart:
	
	li $t0, 0xffff0000
	lw $t1, 0($t0)
	bne $t1, 1, wait_for_restart  # If no keyboard input, jump to gravity
	lw $t1, 4($t0)
	bne $t1, 112, wait_for_restart  # If p is pressed, restart game
	j main
   	   	
    	


you_win:

    	addi $a0, $zero, BACKGROUND_COLOUR
    	jal fill_screen

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 7
    	li $a2, 15
    	li $a3, 15
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 6
    	li $a2, 15
    	li $a3, 21
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 7
    	li $a2, 21
    	li $a3, 15
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 7
    	li $a2, 18
    	li $a3, 21
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 11
    	li $a2, 26
    	li $a3, 16
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 8
    	li $a2, 27
    	li $a3, 15
    	jal draw_platform

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 11
    	li $a2, 35
    	li $a3, 16
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 8
    	li $a2, 27
    	li $a3, 27
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 12
    	li $a2, 40
    	li $a3, 15
    	jal draw_vertical_border	
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 8
    	li $a2, 41
    	li $a3, 27
    	jal draw_platform
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 12
    	li $a2, 49
    	li $a3, 15
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 11
    	li $a2, 17
    	li $a3, 35
    	jal draw_vertical_border

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 18
    	li $a3, 46
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 19
    	li $a3, 45
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 20
    	li $a3, 44
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 21
    	li $a3, 43
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 22
    	li $a3, 44
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 23
    	li $a3, 45
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 24
    	li $a3, 46
    	jal draw_vertical_border

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 11
    	li $a2, 25
    	li $a3, 35
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 12
    	li $a2, 30
    	li $a3, 35
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 12
    	li $a2, 35
    	li $a3, 35
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 36
    	li $a3, 36
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 37
    	li $a3, 37
    	jal draw_vertical_border
 
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 38
    	li $a3, 38
    	jal draw_vertical_border

    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 39
    	li $a3, 39
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 40
    	li $a3, 40
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 41
    	li $a3, 41
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 42
    	li $a3, 42
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 43
    	li $a3, 43
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 12
    	li $a2, 44
    	li $a3, 35
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 1
    	li $a2, 49
    	li $a3, 46
    	jal draw_vertical_border
    	
    	addi $a0, $zero, TEXT_COLOUR
    	li $a1, 9
    	li $a2, 49
    	li $a3, 35
    	jal draw_vertical_border
    	
    	j wait_for_restart
    	

    	
program_end:
	li $v0, 10
	syscall
