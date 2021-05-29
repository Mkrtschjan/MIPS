# Taline Mkrtschjan
# Program 3
#
# This program is designed to display an array and its smallest element
# 
# C style function
#
# int min(int n, int x[]){
#  int minval;
#  int i;
#
#  minval = x[0];
#  for (i=1; i<n; i+){
#    if ( x[i] < minval {
#      minval = x[i];
#    }
#  }
#
#  return minval;
#}   
.data 
message_array_x:
	.asciiz "int x[] = "
	
message_array_y:
	.asciiz "int y[] = "
	
message_array_z:
	.asciiz "int z[] = "

message_result:
	.asciiz "The smallest integer is: "

newLine:
    	.asciiz "\n"

space:
    	.asciiz " "
    	
comma:
	.asciiz ","
	
openBrace:
	.asciiz "{"
	
closeBrace:
	.asciiz "}"

.align 2

x:
   	.word 0, 1, 4, 9, 16, 25, 36, 49, 64, 81
y:
	.word 29, 23, -17, 11, 5, -2, 3, 7, -13, 19, 27
z:
	.word 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
	
.text

# register map
# Message of arrays x, y, z	$a0 
# Length of arrays x, y, z 	$a0 
# Message of result x, y, z	$a0 
# Address of arrays x, y, z	$a1 
# PrintlnStringInt() parameter	$a1 ($a1 holds min value of array) 
# Loop counter in min()		$s0
# Loop limit in min()		$s1
# Min value of arrays x, y, z	$v0 (return value from min())

.globl main

main:	
	addiu $sp, $sp, -4
	
	la $a0, message_array_x
	jal printString
	jal printOpenBrace
  	
  	li $a0, 10
  	la $a1, x
	
  	jal min
  	
  	# Save result from min() on stack
  	sw $v0, 0($sp)
  	
  	jal printCloseBrace
	jal println
  	
  	# Reload result from stack
  	lw $v0, 0($sp)
  	
  	la $a0, message_result
  	move $a1, $v0
  	jal printlnStringInt
  	
  	jal println
  	
  	la $a0, message_array_y
	jal printString
	jal printOpenBrace
  	
  	li $a0, 11
  	la $a1, y
  	
  	jal min  
  	
  	sw $v0, 0($sp)
  	
  	jal printCloseBrace
  	jal println
  	
  	lw $v0, 0($sp)
  	
  	la $a0, message_result
  	move $a1, $v0
  	jal printlnStringInt
 
  	jal println
	
  	la $a0, message_array_z
  	jal printString
  	jal printOpenBrace
  	
  	li $a0, 12
  	la $a1, z
  	
  	jal min
  	
  	sw $v0, 0($sp)

  	jal printCloseBrace
  	jal println
  	
  	lw $v0, 0($sp)
  	
  	la $a0, message_result
  	move $a1, $v0
  	jal printlnStringInt
  	
  	addiu $sp, $sp, 4
  	
  	#exit
  	li $v0, 10
  	syscall

min:	
	# To check for min value in array
	# $a0 is array length n
	# $a1 is array address
    	# $s0 is loop counter
    	# $s0 starts from 0 to print the whole array
	# $s1 is loop limit
	# $v0 initially holds first element of array
	# $v0 holds min value of array as a return value
	
	# Accounts for stack spaces
	addiu $sp, $sp, -12
	sw $ra, 0($sp)

  	move $s1, $a0
  	move $s0, $zero

  	# Loads first element of array as min value 
  	lw $v0, 0($a1)
 
loop: 
	# To loop through array elements
	# $a0 holds sequential elements of array
	# $a1 is array x, then y, then z address
  	bge $s0, $s1, end_loop

	sll $t0, $s0, 2
	addu $t0, $t0, $a1
	lw $a0, 0($t0)
	
	# Save int element $a0 and min value $v0 on stack
	sw $v0, 4($sp)
	sw $a0, 8($sp)
    	
    	# To print the array
    	jal printInt
    	
    	addi $s0, $s0, 1
    	
    	#To print a space and comma after each integer except for the last
    	bge $s0, $s1, check_min
	jal printComma
	jal printSpace

check_min:
	# To check for min value in array
	# $a0 holds sequential elements of array
	# $v0 holds min value of array
	
	# Reload int element $a0 and min value $v0 from stack
	lw $a0, 8($sp)
	lw $v0, 4($sp)
	
	# To check for min value in array
	bgt $a0, $v0, loop
  	move $v0, $a0
	
	j loop
  
end_loop:
	# To end the loop
  	lw $ra, 0($sp)
  	addiu $sp, $sp, 12
  	
  	jr $ra
  	
printOpenBrace:
	# prints an open brace
	# $a0 holds the open brace address
	
	la $a0, openBrace
	li $v0, 4
	syscall
	
	jr $ra
	
printCloseBrace:
	# prints a closed brace
	# $a0 holds the closed brace address
	
	la $a0, closeBrace
	li $v0, 4
	syscall
	
	jr $ra
 
printComma:
	# prints a comma
	# $a0 holds comma address
	
	la $a0, comma
	li $v0, 4
	syscall
	
	jr $ra

printSpace:
	# prints a space
	
	la $a0, space
	li $v0, 4
	syscall
	
	jr $ra
	
println:
	# prints a new line
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	jr $ra
	
printInt:
	# prints an integer
	# $a0 has integer
	
	li $v0, 1
	syscall
		
	jr $ra

printlnInt:
	# prints an integer with a new line
	# $a0 has integer
	
	li $v0, 1
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	jr $ra

printString:
	# prints a string
	# $a0 has string address
	
	li $v0, 4
	syscall
	
	jr $ra
	
printlnString:
	# prints a string with a new line
	# $a0 has string address
	
	li $v0, 4
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall

	jr $ra
	
printStringInt:
	# prints a string and an integer
	# $a0 is string address
	# $a1 is int
	
	# save return address so not overwritten
	# save $a1 so not overwritten
	
	addiu $sp, $sp, -8
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	# print string
	
	jal printString
	
	# print int
	# get argument from stack
	
	lw $a0, 4($sp)
	jal printInt
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	
	jr $ra

printlnStringInt:
	# prints a string and an integer with new line
	# $a0 is string address
	# $a1 is int
	
	# save return address so not overwritten
	# save $a1 so not overwritten
	
	addiu $sp, $sp, -8
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	# print string
	
	jal printString
	
	# print int
	# get argument from stack
	
	lw $a0, 4($sp)
	jal printlnInt
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	
	jr $ra
