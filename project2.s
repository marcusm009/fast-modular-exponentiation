# Marcus Mills
# CDA 3101
# Project 2

.data

# Create an array named "A" with 12 integers and allocate memory for average
promptMessage1:	.asciiz "Enter the first integer x: "
promptMessage2: .asciiz "Enter the second integer k: "
promptMessage3:	.asciiz "Enter the third integer n: "
resultMessage:	.asciiz "The result of x^k mod n = "

x:		.word 0
k:		.word 0
n:		.word 0
temp:		.word 0
result:		.word 1

.text
	.globl main
	main:
		# Prompts the user for the first number
		li $v0, 4
		la $a0, promptMessage1
		syscall

		# Takes in the first number
		li $v0, 5
		syscall
		sw $v0, x

		# Prompts the user for the second number
		li $v0, 4
		la $a0, promptMessage2
		syscall

		# Takes in the second number
		li $v0, 5
		syscall
		sw $v0, k

		# Prompts the user for the third number
		li $v0, 4
		la $a0, promptMessage3
		syscall

		# Takes in the third number
		li $v0, 5
		syscall
		sw $v0, n

		# Call the fme function
		lw $a0, x
		lw $a1, k
		lw $a2, n
		jal fme
		sw $v0, result

		# Display the results
		li $v0, 4
		la $a0, resultMessage
		syscall

		li $v0, 1
		lw $a0, result
		syscall

		# Tell the OS that this is the end of the program
		li $v0, 10
		syscall

#---------------------------------------------------------------------------------------
	# fme function
	.globl fme
	fme:
		# Stack allocation
		subu $sp, $sp, 8	# Allocate 2 words to stack
		sw $ra, 0($sp) 		# Return address
		sw $s1, 4($sp) 		# Original k

		# Base Case
		lw $v0, result 		# Load result into $v0
		beq $a1, 0, fmeDone	# If k == 0, call fmeDone

		# Recursive Call
		addi $t2, $zero, 2 	# $t2 = 2 for division
		div $a1, $t2		# Divide k by 2
		mflo $a1		# Update k with new quotient
		mfhi $s1		# Store k % 2 in $s1
		jal fme			# Recursive call

#-------------- Called after recursion reaches base case

		lw $t1, temp		# Load temp into $t1
		beq $s1, 1, odd		# Call the odd function if k % 2 is equal to 1
		addi $v0, $zero, 1	# Set result to 1 for even
		bne $s1, 1, even	# Call the even function

		odd:
			div $a0, $a2		# Divide x by n
			mfhi $v0		# Move the modulus to result

		even:
			mul $v0, $v0, $t1	# Multiply result by temp
			mul $v0, $v0, $t1	# Multiply result by temp again
			div $v0, $a2		# Divide result by n
			mfhi $v0		# Set result to modulus of last division


		fmeDone:
			# De-allocate the stack and return back to original function
			lw $ra, 0($sp)
			lw $s1, 4($sp)
			addu $sp, $sp, 8
			sw $v0, temp
			jr $ra
