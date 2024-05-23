#Program : ADD 2 FLOATING-POINT NUMBERS WITHOUT USING MIPS FLOATING-POINT INSTRUCTIONS
.include "macro.mac"
# Data segment
.data
# variable definition
temp: .space 4
readData1: .space 4
readData2: .space 4
writeData1: .float 0.0
writeData2: .float 0.0
tenfile: .asciiz "FLOAT2.BIN"
fdescr: .word 0
endl: .asciiz "\n"
# input/output statement
ourcode: "result from our code: "
mips: "result from mips float instruction: "
str_dl1: .asciiz "Data 1 = "
str_dl2: .asciiz "\nData 2 = "
str_tc: .asciiz "success." 
str_loi: .asciiz "can't open file."
time: .asciiz "execution time: "
#-----------------------------------
# Code segment
 .text
#-----------------------------------
# main program
#-----------------------------------

# get to main program
j main

#----------------- create File ---------------------
createFile:
#open file
la $a0,tenfile
addi $a1,$zero,1 # open with a1=1 (write-only)
addi $v0,$zero,13
syscall
bgez $v0,tiep
puts str_loi # can't open file
# write to file
tiep: sw $v0,fdescr #save file descriptor
# the first 4 byte (data type word)
lw $a0,fdescr # file descriptor
la $a1,writeData1
addi $a2,$zero,4 #write 4 byte float
addi $v0,$zero,15
syscall
# the last 4 byte (data type word)
la $a1,writeData2
addi $a2,$zero,4 #write 4 byte float
addi $v0,$zero,15
syscall
# close file
lw $a0,fdescr
addi $v0,$zero,16
syscall
jr $ra
#------------------------------------------------

#----------------- read File --------------------
readFile:
# open file 
la $a0,tenfile 
addi $a1,$zero,0 #a1=0 (read only) 
addi $v0,$zero,13 
syscall 
bgez $v0,tiep1 
baoloi: puts str_loi  # can't open file
j Kthuc 
tiep1: sw $v0,fdescr #save file descriptor 
# the first 4 byte (data type word)
lw $a0,fdescr 
la $a1,readData1 
addi $a2,$zero,4 
addi $v0,$zero,14 
syscall 
# the first 4 byte (data type word)
la $a1,readData2 
addi $a2,$zero,4 
addi $v0,$zero,14 
syscall 
# close file 
lw $a0,fdescr 
addi $v0,$zero,16 
syscall 
jr $ra
#------------------------------------------------

### Read a float from keyboard
### Input  : None
### Output : $v0 -> 32 bits of the float
readFloat:
addi $v0, $zero, 6
syscall
mfc1  $v0, $f0
jr $ra
   
### Print a float to screen
### Input  : $a0 -> 32 bits of the float
### Output : None   
writeResult:
addi $sp, $sp, -4
sw $a0, 0($sp)
li $v0, 4
la $a0, ourcode
syscall
lw $a0, 0($sp) # Restore $s0
addi $sp, $sp, 4
mtc1 $a0, $f12
addi $v0, $zero, 2
syscall
jr $ra


### Extract the sign bit of the float
extractSign:
srl $v0, $a0, 31
jr $ra
   
### Extract the biased exponent field of the float
extractBiasedExponent:
sll $v0, $a0, 1
srl $v0, $v0, 24
jr $ra 

### Extract the fraction field of the double
extractFraction:
sll $v0, $a0, 9
srl $v0, $v0, 9
addi $v0, $v0, 0x800000
jr $ra 
 
AlignBinaryPoints:
beq $t1, $t2, exit
slt $t3, $t1, $t2
beqz $t3, alignSecondNum
firstNum:
srl $t4, $t4, 1
addi $t1, $t1, 1
bne $t1, $t2, firstNum
move $s3, $t1
move $s4, $t4
j exit
alignSecondNum:
secondNum:
srl $t5, $t5 ,1
addi $t2, $t2, 1
bne $t1, $t2, secondNum
move $s6, $t2
move $s7, $t5
exit:
jr $ra

covert_two_complement:
beqz $t1, number2
xori $t4, $t4, 0x0
move $s4, $t4
number2:
beqz $t2, exit1
xori $t5, $t5, 0xFFFFFFFF
move $s7, $t5
exit1:
jr $ra


#$a3: fraction bit
#$a2: BiasedExpoent bit
#$a1: sign bit
addition:
bne $t1, $t2, subtract      #sign bit is not equal
#get element of addtion
add $a3, $t3, $t4
add $a2, $zero, $t5 
add $a1, $zero, $t1
#cope with overflow
move $t0, $a3       
srl $t0, $t0, 24
beqz $t0, continue        
srl $a3, $a3, 1
addi $a2, $t5, 1
continue: 
sll $a3, $a3, 9
srl $a3, $a3, 9
sll $a1, $a1, 31
sll $a2, $a2, 23
add $a1, $a1, $a2
add $v0, $a1, $a3
j exit2

subtract:
#get element of addtion
slt $t0 ,$t3, $t4
beqz $t0, reverse
sub $a3, ,$t4, $t3
add $a1, $zero, $t2
j continue1
reverse:
sub $a3, ,$t3, $t4
add $a1, $zero, $t1
continue1: 
add $a2, $zero, $t5 

#normalize
loop:
lui $t1, 0x0080           # Load upper 16 bits with 0x0080
ori $t1, $t1, 0x0000      # Load lower 16 bits with 0x0000, so $t1 now contains 0x00800000
slt $t0, $a3, $t1         # > t0 = 0 ; < t0 = 1
beqz $t0, exit3
sll $a3, $a3, 1
subi $a2, $a2, 1	
j loop
exit3:
sll $a3, $a3, 9
srl $a3, $a3, 9
sll $a1, $a1, 31
sll $a2, $a2, 23
add $a1, $a1, $a2
add $v0, $a1, $a3
exit2:
jr $ra


main:
#get input1
jal readFloat
sw $v0, writeData1

#get input2
jal readFloat
sw $v0, writeData2


#create File FLOAT2.BIN with 2 input
jal createFile
#read File FLOAT2.BIN 
jal readFile
lw $s0, readData1
lw $s1, readData2

#element from number 1
move $a0, $s0
jal extractSign                   #bit sign
move $s2, $v0
jal extractBiasedExponent         #bit Biased Exponent
move $s3, $v0 
jal extractFraction               #bit Fraction
move $s4, $v0 

#element from number 2
move $a0, $s1                      
jal extractSign                   #bit sign
move $s5, $v0
jal extractBiasedExponent         #bit Exponent
move $s6, $v0 
jal extractFraction               #bit Fraction
move $s7, $v0 


#Align Binary Points
add $t1, $zero, $s3   #BiasedExponent1
add $t2, $zero, $s6   #BiasedExponent2
add $t4, $zero, $s4   #fraction1
add $t5, $zero, $s7   #fraction2
jal AlignBinaryPoints

add $t1, $zero, $s2   #sign1
add $t2, $zero, $s5   #sign2
add $t3, $zero, $s4   #fraction1
add $t4, $zero, $s7   #fraction2
add $t5, $zero, $s3   #BiasedExponent1
add $t6, $zero, $s6   #BiasedExponent2
jal addition

move $a0, $v0
jal writeResult

li $v0, 4
la $a0, endl
syscall

li $v0, 4
la $a0, mips
syscall

mtc1 $s0, $f1
mtc1 $s1, $f2
add.s $f12, $f1, $f2
addi $v0, $zero, 2
syscall

# finish program (syscall)
Kthuc: addiu $v0,$zero,10
 syscall


#------------------------------------------------
