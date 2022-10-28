#####################################################################################################################
####### CS3520-Assignment 1: Rervesible Prime Square#################################################################
#        Author: TEFONYANE LIBETSO                       ############################################################
########## DATE: 15/OCTOBER/2022#####################################################################################

####### Data Segment#################################################################################################
.data
	num: .word 1   # The first number to be increment to checkif it is prime and it to find square of prime#########
	divisor: .word 0  # A number to divide the increment number to check factors#####################################
	count:	.word 0    # A variable to store the number of factors found#############################################
	numbers_printed:.word 0
	next_line:.asciiz  "\n"
#####################################################################################################################
#.text segment#######################################################################################################
.text
.globl main
.ent main

main:
	lw $t0 , num			# store the numbers in the temporary variables 
	lw $t1 , divisor
	lw $t2 , count
	lw $t5,numbers_printed	# $t5, holds total of numbers printed
	
	
Loop1:
	move $a0 , $t0			### copy the contents of $t0, $t1 and $t2 in the 
	move $a1 , $t1			## variables $a0,$a1, and $a2
	move $a2 , $t2
	
	jal Prime_test			# call the function Prime_test to check if num is a prime######
	
	
	beq $v0, 1, Found_pr	# Check if the returned value of the Prime_test is True(1), or False(0), if it's true,jump 
	add $t0, $t0, 1			# else increment the number to be check then
	j Loop1					# Jump to the Loop1 to check the next prime

Found_pr:
	mul $a0, $t0, $t0		## store the squared value of prime hold by $t0 in the variable $a0 then
	
	jal Reverse           	## call the reverse to returned value of the Squared Prime
	
	move $t3, $v0			## copy the reversed square value in the temporary variable $t3
	
	move $a0, $v0			# copy the contents of returned value in the Argument register
	mul $a1, $t0, $t0		# store the square of $num is the temporaty variable to $a1
	
	jal Palindrome			## call Palindrome check if the square number and its reverse is a palindrome
	
	move $a0, $v0 			
	
	beq $a0, 1 , True		# if the square is a palindrome jump the branch true
	j Not_palind			# otherwise go the Not_palind
	
True:
	add $t0, $t0, 1			# if the the Square is a palindrome increment the $num and jump back to check the other prime
	j Loop1
	
Not_palind:					# if the number is not a palindrome :
	move $a0, $t0
	
	jal Reverse
	
	move $t4, $a0
	li $a1,0
	li $a2,0
	
	jal Prime_test
	
	beq $a0, 1 , To_Check_square
	j Reverse_not_squrare
	
To_Check_square:
	move $a0, $t3
	move $a1, $t4
	
	jal CheckSquare
	
	bne $v0, 1, Reverse_not_squrare	
	j True4	
	
Reverse_not_squrare:
	add $t0, $t0, 1			# Increment the $num to check other prime number
	j Loop1					# jump back to Loop1
	
True4:
	move $t3,$t0			# store the number (num) that its square is reversible Prime Square in the temporary variable $t3 
	j Print					# branch to print the reversible Prime Square

# print the reversible Prime Square
Print:
	add $t5,$t5,1
	mul $a0, $t3, $t3
	li $v0, 1
	move $a0,$a0
	syscall
	beq $t5, 10 ,Exit		# if 10 number have been printed Exit the program 
	add $t0, $t0,1			# otherwise increment the $num and go back to increment $num to check the other prime
	
	# Skip the line
	li $v0,4
	la $a0, next_line
	syscall
	j Loop1
Exit:
li $v0, 10
syscall

.end main
	
###############################################################################################################################
## This function will check if the number held by the temporary variable is a prime ############################################
################################################################################################################################

.globl Prime_test
.ent Prime_test

Prime_test:

Loop2:
	bgt $a1,$a0, Test
	add $a1, $a1, 1
	rem $a3, $a0, $a1
	beq $a3, 0, Loop3
	
	j Loop2
	
Loop3:
	add $a2, $a2, 1
	bgt $a1, $a0, Test
	j Loop2
	
Test:
	beq $a2, 2, True1
	j False
	
True1:
	li $a0, 1
	move $v0, $a0
	jr $ra
	
False:
	li $a0, 0
	move $v0, $a0
	jr $ra
	
.end Prime_test

.globl Reverse
.ent Reverse

######################################################################################################################
# The function will resevrse the square of the value held by the temporary variable $t0 are return the reversed value
######################################################################################################################
#### Code Segment for the function Reverse############################################################################
Reverse:
	move $a0, $a0
	li $a1, 0
	
	
Loop4:
	beq $a0, 0, Return
	mul $a1, $a1, 10
	rem $a2, $a0, 10
	add $a1, $a1, $a2
	
	div $a0, $a0, 10
	j Loop4
	
Return:
	move $a0, $a1
	move $v0, $a0
	jr $ra

.end Reverse  ###### This is the end of the function Reverse#########################################################
#####################################################################################################################

#####################################################################################################################
######################################Palindrome Test Fucntion Starts here###########################################
#####################################################################################################################
.globl Palindrome
.ent Palindrome
Palindrome:
LOop5:
	beq $a0, $a1, True2
	j False1
	
True2:
	li $a0, 1
	move $v0, $a0
	jr $ra
	
False1:
	li $a0, 0
	move $v0, $a0
	jr $ra
.end Palindrome

####################################This is the end of the Palindrome function#######################################

################### This is function CheckSquare#####################################################################
############The complexity of this function is to check the Reversed Square is a Square if so it has to find the ####
## its Square root and immediatly check if that Square root is prime then it will return True(1) if both Conditions are met
#########Otherwise the returned value will be False(1)###############################################################
#####################################################################################################################
.globl CheckSquare

CheckSquare:
	divu $t3, $a0, $a1
	beq $t3, $a1, SquareNum
	j Not_Square
	
	
SquareNum:
	li $v0, 1
	
	jr $ra

Not_Square:
	li $v0, 0
	jr $ra
.end CheckSquare
#######################################################################################################################