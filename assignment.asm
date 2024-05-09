.data
	store_cal:	.space 100				# 100 elements, each 1 bit 
	newline: 	.asciiz "\n"
	space:		.asciiz " "
	
	fin:		.asciiz "E:\\Documents\\Computer Architecture\\Assignment\\HK232\\calc_log.txt" 
	
	intro:		.asciiz "\n------------------------- WELCOME TO THE CALCULATOR --------------------------\n"
	intro0:		.asciiz "\nHere is some rules you must follow to use this calculator: \n"
	intro1:		.asciiz "      1. The length of the input should be 100 characters max.\n"
	intro2:		.asciiz "      2. The user must enter the correct valid character including: 0 1 2 3 4 5 6 7 8 9 + - * / . M ^ ! ( ).\n"
	intro3:		.asciiz "      3. + - * / ---> regular calculations follow the order of addition, subtraction, multiplication and division.\n"
	intro4:		.asciiz "      4.   .     ---> Decimal points [Example: 3.5, 4.97, ...].\n"
	intro5:		.asciiz "      5.   ^     ---> Exponential [Example: 3^5, 2^6, ...], only work with INTEGER exponent number!!!!\n"
	intro6:	        .asciiz "      6.   !	 ---> The factorization operator [Example: 3!, 5!, ...].\n"
	intro7:	        .asciiz "      7.  ( )    ---> Parentheses help organize and group operations together in order to perform them in a different way [Example: (1+3)/2, ...].\n"
	intro8:		.asciiz "\n\n--------------------!!!Hope you use this calculator well!!!-------------------\n\n"
	
	MemoryStore: 	.asciiz "\nThe value stored in M: "
	input:		.asciiz "\nPlease insert your expression: "
	Result:		.asciiz "\nThe result: "
	Error:  	.asciiz "\n\nPlease enter again, you have entered the wrong format according to the rules of calculator!!!\n"

	ContinueQues:	.asciiz "\n\nDo you want to continue? Type 1 for YES / Type 2 for NO\n"
	ContinueOpt:	.asciiz "Your option is: "
	ContinueError:  .asciiz "\n\nPlease enter again, you have entered the wrong value according to the rules of question!!!\n"
	
	ten: 		.float 10.000000000000000
	zero: 		.float 0.0
	one:		.float 1.0
.text
main:
	# Declare the M expression 
 	li $s3, 0		# integer
 	l.s $f28, zero		# decimalF
startcal:
	j introduction
	
###############################################################################################################################################################################################################  
##################################################################### Introduction as well as the rule of calculator ##################################################################################################
###############################################################################################################################################################################################################  
introduction:
	#Print 20 newline for interface
	li $t9, 20
	loop_newline:
		beq $t9, 0, introduction_real
		li $v0, 4           	
		la $a0, newline   	
		syscall
		addi $t9, $t9, -1
		j loop_newline
		
introduction_real:	
	#Print all the introduction part	
	li $v0, 4           	
	la $a0, intro   	
	syscall
	li $v0, 4           	
	la $a0, intro0    	
	syscall
	li $v0, 4           	
	la $a0, intro1    	
	syscall
	li $v0, 4           	
	la $a0, intro2   	
	syscall
	li $v0, 4           	
	la $a0, intro3   	
	syscall
	li $v0, 4           	
	la $a0, intro4    	
	syscall
	li $v0, 4           	
	la $a0, intro5    	
	syscall
	li $v0, 4           	
	la $a0, intro6   	
	syscall
	li $v0, 4           	
	la $a0, intro7    	
	syscall
	li $v0, 4           	
	la $a0, intro8    	
	syscall
###############################################################################################################################################################################################################      
########################################################################### Declare the input function ######################################################################################################## 
###############################################################################################################################################################################################################      
input_state:    
	# Declare the result expression 
	la $t8, 0 		# integer
	l.s $f30, zero		# decimalF
	li $s6, 0 		# isDecimal = False
	li $s5, 0		# Operand = 0
	li $t3, 0		# isFirstNumber = 0 
	
	# print the request to user input
	li $v0, 4           	# System call for print_str
	la $a0, input      	# Load the newline character
	syscall
   
   	# Read the string from the user
	li $v0, 8               # System call for read_string
	la $a0, store_cal       # Load the address of the input buffer
	li $a1, 101             # Maximum number of characters to read
	syscall	   
	
	j FilteringNumber
###############################################################################################################################################################################################################      
######################################################################### FILTERING NUMBER AND OPERATOR ####################################################################################################### 
############################################################################################################################################################################################################### 	
FilteringNumber:
	li $t1, 1         	# sign = 1 to muptiple at the end (positive number)
	li $t2, 0		# isBracket = False
    	li $t4, 0         	# decimalPlace = 0
    	li $s7, 0		# integer part
    	l.s $f0, zero		# decimal part
    
    	lb $t0, store_cal($t9) 

    	beq $t0, 45, negative		# ASCII code for '-'
    	beq $t0, 41, clear_input	# ASCII code for ')'
    	beq $t0, 40, bracket		# ASCII code for '('
    	beq $t0, 77, Memory 		# ASCII code for 'M'
    	
    	# Not the format character, force to stop
    	blt $t0, 48, clear_input    	
    	bgt $t0, 57, clear_input
    
    	j integer_loop
    	
negative:
	# Write the character to file
    	li $v0, 15          		# System call for write to file
    	move $a0, $s2       		# File descriptor
   	la $a1, store_cal($t9)  	# Character to write
    	li $a2, 1           		# Length of data (1 character)
    	syscall             		# Write the character to file
    	
    	li $t1, -1        	# sign = -1 to muptiple at the end (negative number)
    	addi $t9, $t9, 1  	# ignore the '-'
    	
    	lb $t0, store_cal($t9) 
    	beq $t0, 77, Memory 		# ASCII code for 'M'
    	
    	j integer_loop

bracket:
	# Write the character to file
    	li $v0, 15          		# System call for write to file
    	move $a0, $s2       		# File descriptor
   	la $a1, store_cal($t9)  	# Character to write
    	li $a2, 1           		# Length of data (1 character)
    	syscall             		# Write the character to file
    	
	li $t2, 0		# isBracket = True
	addi $t9, $t9, 1  	# ignore the '('
	j Parentheses
   
integer_loop:
	lb $t0, store_cal($t9) 
	
	# Write the character to file
    	li $v0, 15          		# System call for write to file
    	move $a0, $s2       		# File descriptor
   	la $a1, store_cal($t9)  	# Character to write
    	li $a2, 1           		# Length of data (1 character)
    	syscall             		# Write the character to file
	
    
    	beq $t0, 46, check_decimal  	# check decimal part when '.' 
    	beq $t0, 33, Factorization	# check operator when '!'
    	
   	beq $t0, 43, Op_inter		# check operator when '+' 
	beq $t0, 45, Op_inter		# check operator when '-' 
	beq $t0, 42, Op_inter		# check operator when '*' 
	beq $t0, 47, Op_inter		# check operator when '/' 
	beq $t0, 94, Op_inter		# check operator when '^'
	beq $t0, 10, Op_inter    	# The end of the string	
    	
    	# Not the format character, force to stop
    	blt $t0, 48, clear_input    	
    	bgt $t0, 57, clear_input	
    
    	subi $t0, $t0, 48           	# Convert string to integer
    
    	mul $s7, $s7, 10		# number = number * 10.0
    	add $s7, $s7, $t0		# number = number + integer
    
    	addi $t9, $t9, 1           	# Transfer to next char
    	j integer_loop    	
    	 	
check_decimal:
    	addi $t9, $t9, 1           	# Ignore the char '.' 
    	addi $s6, $s6, 1		# isDecimal = True
    	j decimal_loop  	 	 	
    	 	 	 	
decimal_loop:
    	lb $t0, store_cal($t9)
    
    	beq $t0, 10, end_decimal    	# The end of the string
    	beq $t0, 43, end_decimal	# check operator when '+' 
	beq $t0, 45, end_decimal	# check operator when '-' 
	beq $t0, 42, end_decimal	# check operator when '*' 
	beq $t0, 47, end_decimal	# check operator when '/' 
	beq $t0, 94, end_decimal	# check operator when '^' 
    	
    	# Not the format character, force to stop
    	beq $t0, 33, clear_input	# check operator when '!' 
    	blt $t0, 48, clear_input    	
    	bgt $t0, 57, clear_input
    
    	subi $t0, $t0, 48           	# Convert string to integer
    
   	mul $s7, $s7, 10		# number = number * 10.0
   	
   	# Out of range memory, force to stop 
    	blt $s7, -10000000, clear_input
    	bgt $s7, 10000000, clear_input
    	
    	add $s7, $s7, $t0		# number = number + integer
   
    	addi $t4, $t4, 1            	# decimalPlace += 1
    	addi $t9, $t9, 1            	# Transfer to next char
    	j decimal_loop   	 	 	 	 	
    	 	 	 	 	 	
end_decimal:
	l.s $f8, ten			# temp = 10.0 
	
	mtc1 $s7, $f0
    	cvt.s.w $f0, $f0            	# Convert integer type to float type   
    	
    	bgtz $t4, divide_loop     	# decimalPlace > 0 --> convert integer to decimal
    	j divide_loop_end      	 	 	 	 	 	 	
    		 	 	 	 	 	 	 	
divide_loop:
    	beq $t4, 0, divide_loop_end   	# decimalPlace = 0 --> out the loop
    	div.s $f0, $f0, $f8           	# result /= 10.0
    
    	subi $t4, $t4, 1             	# decimalPlace -= 1
    	j divide_loop  
    	
divide_loop_end: 
	lb $t0, store_cal($t9) 
	
	# multiple when the negative or positive number 
    	mtc1 $t1, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	mul.s $f0, $f0, $f31          	# result *= sign

   	beq $t0, 43, Op_dec		# check operator when '+' 
	beq $t0, 45, Op_dec		# check operator when '-' 
	beq $t0, 42, Op_dec		# check operator when '*' 
	beq $t0, 47, Op_dec		# check operator when '/' 
	beq $t0, 94, Op_dec		# check operator when '^' 
	
	beq $t0, 10, ExeOperand		# The end of the string
    	
    	j FilteringNumber    	  	 	 	 	 	 	 	 	 	  	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	
###############################################################################################################################################################################################################      
########################################################################## GET THE OPERAND ######################################################################################################## 
############################################################################################################################################################################################################### 	    	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	
Op_inter:	
	beq $t0, 10, ExeOperand		# The end of the string
	bgt $s5, 0, ExeOperand		# check if there is any operator
	move $s5, $t0			# Operand = 0 	 
	bgt $t3, 0, ExeOperand
	
	li $t3, 1
	
	add $t8, $t8, $s7		# result = result + number
	mul $t8, $t8, $t1		# result *= sign

	addi $t9, $t9, 1           	# Transfer to next char
	j FilteringNumber
	
Op_dec:
	beq $t0, 10, ExeOperand		# The end of the string
	move $s5, $t0			# Operand = 0 	 
	bgt $t3, 0, ExeOperand
	
	li $t3, 1
	
	add.s $f30, $f30, $f0		# result = result + number

	addi $t9, $t9, 1           	# Transfer to next char
	j FilteringNumber

ExeOperand:
	beq $s5, 43, Addiction		# check operator when '+' 
	beq $s5, 45, Subtraction	# check operator when '-' 
	beq $s5, 42, Multiplication	# check operator when '*' 
	beq $s5, 47, Division		# check operator when '/' 
	beq $s5, 94, Exponent		# check operator when '^' 
	beq $s5, 0, print_dec_int	# check operator when nothing 
	
print_dec_int:
	bgt $s6, 0, end_string
	j end_integer 	 	 	 	  	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 			 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	  	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	  	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 			 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	  	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	 	 	 	 	 	
###############################################################################################################################################################################################################      
############################################################################### ADDITION ####################################################################################################### 
############################################################################################################################################################################################################### 	
Addiction:	
	move $s5, $t0			# Operand = $t0	 
	beq $s6, 0, add_integer
	bgt $s6, 1, add_decimal_2
	beq $t8, $zero, add_decimal

	# multiple when the negative or positive number 
    	mtc1 $t8, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	add.s $f30, $f31, $f0          # result = result + number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
	
add_integer:
	mul $s7, $s7, $t1		# result *= sign
	add $t8, $t8, $s7		# result = result + number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)

	beq $t0, 10, result_integer    	# The end of the string
	beq $t0, 0, result_integer    	# The end of the string
	j FilteringNumber

add_decimal:
	# multiple when the negative or positive number 
    	mtc1 $s7, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	add.s $f30, $f30, $f31         	# result = result + number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber

add_decimal_2:
	add.s $f30, $f30, $f0         	# result = result + number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
###############################################################################################################################################################################################################      
############################################################################### SUBTRACTION ####################################################################################################### 
############################################################################################################################################################################################################### 	
Subtraction:
	move $s5, $t0			# Operand = $t0	 
	beq $s6, 0, sub_integer
	bgt $s6, 1, sub_decimal_2
	beq $t8, $zero, sub_decimal
	
	# multiple when the negative or positive number 
    	mtc1 $t8, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	sub.s $f30, $f31, $f0          	# result = result + number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
	
sub_integer:
	mul $s7, $s7, $t1		# result *= sign
	sub $t8, $t8, $s7		# result = result - number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_integer    	# The end of the string
	beq $t0, 0, result_integer    	# The end of the string
	j FilteringNumber
	
sub_decimal:
	# multiple when the negative or positive number 
    	mtc1 $s7, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	sub.s $f30, $f30, $f31         	# result = result - number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber

sub_decimal_2:
	sub.s $f30, $f30, $f0         	# result = result - number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
###############################################################################################################################################################################################################      
############################################################################## MULTIPLICATION ####################################################################################################### 
############################################################################################################################################################################################################### 	
Multiplication:
	move $s5, $t0			# Operand = $t0	 
	beq $s6, 0, mul_integer
	bgt $s6, 1, mul_decimal_2
	beq $t8, $zero, mul_decimal
	
	# multiple when the negative or positive number 
    	mtc1 $t8, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	mul.s $f30, $f31, $f0          	# result = result + number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
	
mul_integer:
	mul $s7, $s7, $t1		# result *= sign
	mul $t8, $t8, $s7		# result = result - number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_integer    	# The end of the string
	beq $t0, 0, result_integer    	# The end of the string
	j FilteringNumber
	
mul_decimal:
	# multiple when the negative or positive number 
    	mtc1 $s7, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	mul.s $f30, $f30, $f31         	# result = result - number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber

mul_decimal_2:
	mul.s $f30, $f30, $f0         	# result = result - number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
###############################################################################################################################################################################################################      
################################################################################ DIVISION ####################################################################################################### 
############################################################################################################################################################################################################### 	
Division:
	move $s5, $t0			# Operand = $t0	 
	beq $s6, 0, div_integer
	bgt $s6, 1, div_decimal_2
	beq $t8, $zero, div_decimal
	
	# multiple when the negative or positive number 
    	mtc1 $t8, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	div.s $f30, $f31, $f0          	# result = result + number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
	
div_integer:
	mul $s7, $s7, $t1		# result *= sign
	
    	mtc1 $s7, $f0	
    	cvt.s.w $f0, $f0           	# Convert integer type to float type           
    	mtc1 $t8, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type   
    	
    	                
    	div.s $f30, $f31, $f0         	# result = result / number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
	
div_decimal:
	# multiple when the negative or positive number 
    	mtc1 $s7, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	div.s $f30, $f30, $f31         	# result = result - number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber

div_decimal_2:
	div.s $f30, $f30, $f0         	# result = result - number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
###############################################################################################################################################################################################################      
############################################################################## FACTORIZATION ####################################################################################################### 
############################################################################################################################################################################################################### 	
Factorization:
	li $t6, 1  					# Number of iterations
    	loop1:
        	mul $t6, $t6, $s7  			# Multiply result by x
        	subi $s7, $s7, 1      			# Increment the loop counter
        	beq $s7, $zero, fac_result       		# Repeat the loop if the counter is not equal $s7
        	j loop1
        fac_result:	
		move $s7, $t6			# result = sign
		
		addi $t9, $t9, 1           	# Transfer to next char
		lb $t0, store_cal($t9)
		
		beq $t0, 43, integer_loop		# check operator when '+' 
		beq $t0, 45, integer_loop		# check operator when '-' 
		beq $t0, 42, integer_loop		# check operator when '*' 
		beq $t0, 47, integer_loop		# check operator when '/' 
		
		# Not the format character, force to stop
		beq $t0, 94, clear_input 		# check operator when '^'
		beq $t0, 33, clear_input		# check operator when '!' 
		beq $t0, 41, clear_input		# ASCII code for ')'
    		beq $t0, 40, clear_input		# ASCII code for '('
    		beq $t0, 77, clear_input 		# ASCII code for 'M'
		
		beq $s5, $zero, fac_print
		j integer_loop
	
	fac_print:
		la $a0, Result
		li $v0, 4
		syscall 
	
		mul $s7, $s7, $t1		# result *= sign
	
		# Print the result
    		move $a0, $s7
    		li $v0, 1
    		syscall
		
    		j AskUser		
###############################################################################################################################################################################################################      
################################################################################ EXPONENT ####################################################################################################### 
############################################################################################################################################################################################################### 	
Exponent:
	move $s5, $t0			# Operand = $t0	 
	beq $s6, 0, ex_integer
	bgt $s6, 1, clear_input
	beq $t8, $zero, ex_decimal
	
	j FilteringNumber
	
ex_integer:
	li $t6, 1
    	loop_integer:
        	mul $t6, $t6, $t8  		# Multiply result by x
        	subi $s7, $s7, 1      		# Decrement the loop counter
        	bne $s7, $zero, loop_integer        	# Repeat the loop if the counter is not zero		
	move $t8, $t6		# result = number
		
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_integer    	# The end of the string
	beq $t0, 0, result_integer    	# The end of the string
	j FilteringNumber
	
ex_decimal:
	l.s $f29, one
	loop_decimal:
        	mul.s $f29, $f29, $f30  		# Multiply result by x
        	subi $s7, $s7, 1      			# Decrement the loop counter
        	bne $s7, $zero, loop_decimal        	# Repeat the loop if the counter is not zero
	mov.s $f30, $f29		# result  number
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	beq $t0, 10, result_decimal    	# The end of the string
	beq $t0, 0, result_decimal    	# The end of the string
	j FilteringNumber
###############################################################################################################################################################################################################      
############################################################################## PARENTHESES ####################################################################################################### 
############################################################################################################################################################################################################### 	
Parentheses:
	j clear_input

###############################################################################################################################################################################################################      
############################################################################### MEMORY ####################################################################################################### 
###############################################################################################################################################################################################################
Memory:
	la $a0, MemoryStore
	li $v0, 4
	syscall
	
	beq $s3, 0, m_print_decimal
	j m_print_integer
	
m_print_decimal:
	mov.d $f12, $f28
	li $v0, 2
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	
	li $s6, 1
	
	mov.d $f0, $f28			# Store M to $f0
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	
	bgt $s5, $zero, ExeOperand

	beq $t0, 10, end_string    	# The end of the string
	beq $t0, 0, end_string    	# The end of the string
	j FilteringNumber
	
m_print_integer:
	move $a0, $s3
	li $v0, 1
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	
	move $s7, $s3			# Store M to $s7
	
	addi $t9, $t9, 1           	# Transfer to next char
	lb $t0, store_cal($t9)
	
	bgt $s5, $zero, ExeOperand
	
	beq $t0, 10, end_integer    	# The end of the string
	beq $t0, 0, end_integer    	# The end of the string
	j FilteringNumber
###############################################################################################################################################################################################################
########################################################################### PRINT IF ONE NUMBER DECIMAL ##############################################################################################################################    
###############################################################################################################################################################################################################
end_string:
	la $a0, Result
	li $v0, 4
	syscall 
	
	# multiple when the negative or positive number 
    	mtc1 $t1, $f31		
    	cvt.s.w $f31, $f31            	# Convert integer type to float type           
    	mul.s $f0, $f0, $f31          	# result *= sign
    	
    	li $s3, 0			# store for M
    	mov.d $f28, $f0			# store for M
    
    	# Print the result
    	mov.d $f12, $f0
    	li $v0, 2
    	syscall
 
    	j AskUser
###############################################################################################################################################################################################################
########################################################################### PRINT IF ONE NUMBER INTEGER ##############################################################################################################################    
###############################################################################################################################################################################################################    
end_integer:
	bgt $t8, $zero, result_integer
	bgt $s6, $zero, result_decimal
	
	la $a0, Result
	li $v0, 4
	syscall 
	
	mul $s7, $s7, $t1		# result *= sign
	
	l.s $f28, zero			# store for M
	move $s3, $s7			# store for M
	
	# Print the result
    	move $a0, $s7
    	li $v0, 1
    	syscall
    	
    	j AskUser
############################################################################################################################################################################################################### 	
########################################################################## PRINT IF RESULT INTEGER ##############################################################################################################################    
###############################################################################################################################################################################################################    
result_integer:
	la $a0, Result
	li $v0, 4
	syscall 
	
	l.s $f28, zero		# store for M
	move $s3, $t8		# store for M
	
	# Print the result
    	move $a0, $t8
    	li $v0, 1
    	syscall
 
    	j AskUser
############################################################################################################################################################################################################### 	
########################################################################## PRINT IF RESULT DECIMAL ##############################################################################################################################    
###############################################################################################################################################################################################################    
result_decimal:
	la $a0, Result
	li $v0, 4
	syscall 
	
	li $s3, 0		# store for M
	mov.d $f28, $f30	# store for M
	
	# Print the result
    	mov.d $f12, $f30
    	li $v0, 2
    	syscall
 
    	j AskUser
######################################################################################################################################################################################################################################                                                                                                                                  
##################################################################### Ask for continue or not ################################################################################################## 	
###############################################################################################################################################################################################################
AskUser:
	li $v0, 4           	
	la $a0, ContinueQues  	
	syscall

	li $v0, 4           	
	la $a0, ContinueOpt  	
	syscall

	li $v0, 5
	syscall
	move $a0, $v0

	beq $a0, 1, new_loop
	beq $a0, 2, EXIT

	li $v0, 4           	
	la $a0, ContinueError 	
	syscall

	j AskUser
###############################################################################################################################################################################################################
########################################################################### RESET DATA FOR NEW LOOP ##############################################################################################################################    
###############################################################################################################################################################################################################    
clear_input:
    	li $t4, 0                  
    	l.s $f0, zero
    	li $s7, 0
    	li $t9, 0
    
    	la $a0, Error 
    	li $v0, 4 
    	syscall
    
    	j input_state

new_loop:
	li $t4, 0                  
    	l.s $f0, zero
    	li $s7, 0
    	li $t9, 0
    
    	j startcal
###############################################################################################################################################################################################################
########################################################################### EXIT ##############################################################################################################################              
###############################################################################################################################################################################################################    
EXIT:
	li $v0, 10
	syscall
        
