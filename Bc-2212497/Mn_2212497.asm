# PROGRAM: De 2
.data
Message: .asciiz "The random number you generated was: "	
multiplier: .float 1000.0
endl: .asciiz "\n" 
filename: .asciiz "SOLE.TXT"
format: .asciiz "hehe"
format1: .asciiz "So f1 (2 so le): "
format2: .asciiz "So f2 (3 so le): "
format3: .asciiz "So f3 (4 so le): "
.text

j main

write_file:
#open file 
li $v0,13           	# open_file syscall code = 13
la $a0,filename     	# get the file name
li $a1,1           	# file flag = write (1)
syscall
move $s1,$v0        	# save the file descriptor. $s0 = file
    	
#Write format the file
li $v0,15		# write_file syscall code = 15
move $a0,$s1		# file descriptor
la $a1, format1		# the string that will be written
la $a2, 17		# length of the toWrite string
syscall

#Write sole to file
li $v0,15
move $a0,$s1
move $a1, $s2
addi $a2,$zero, 7
syscall
    	
#Write format the file
li $v0,15		# write_file syscall code = 15
move $a0,$s1		# file descriptor
la $a1, format2		# the string that will be written
la $a2, 17		# length of the toWrite string
syscall

#Write sole to file
li $v0,15
move $a0,$s1
move $a1, $s3
addi $a2,$zero, 8
syscall
    	    
#Write format the file
li $v0,15		# write_file syscall code = 15
move $a0,$s1		# file descriptor
la $a1, format3		# the string that will be written
la $a2, 17		# length of the toWrite string
syscall

#Write sole to file
li $v0,15
move $a0,$s1
move $a1, $s4
addi $a2,$zero, 9
syscall    	    	
    	    			
#MUST CLOSE FILE IN ORDER TO UPDATE THE FILE
li $v0,16         		# close_file syscall code
move $a0,$s1      		# file descriptor to close
syscall    # close file
jr $ra	

set_seed:
li $v0, 40
add $a0, $zero, $zero  
add $a1, $zero,$t1
syscall
jr $ra

get_time:
li $v0, 30
syscall
move $t1, $a0
jr $ra

random_float:
# load 1000 to $f1 in order to get range (0, 1000)
l.s $f1, multiplier
li $v0, 43
add $a0, $zero, $zero
syscall  
mul.s $f0, $f0, $f1 
jr $ra

print_float:
li $v0,4
la $a0,Message
syscall
mov.s $f12, $f0
li $v0, 2
syscall

li $v0,4
la $a0,endl
syscall
jr $ra

print_endl:
li $v0,4
la $a0, endl
syscall
jr $ra

sole1: #fff.ff
#print string
li $v0, 4
la $a0, format1
syscall

#allocate heap memory for format 1
li $v0, 9
li $a0, 6
syscall
move $s0, $v0

#get natural part to $a2 and fraction part to $a3
li $t2, 100
mtc1 $t2, $f1
mul.s $f2, $f0, $f1
cvt.w.s $f3, $f2
mfc1 $a2, $f2
div $a2, $t2
mfhi $a3
mflo $a2

#solve narutal part
div $a2, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 0($s0)
mfhi $a2
li $t2, 10
div $a2, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 1($s0)
mfhi $a2
addi $t3, $a2, 48
sb $t3, 2($s0)

add $t3, $zero, 46
sb $t3, 3($s0)

#solve fraction part of sole 1
li $t2, 10
div $a3, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 4($s0)
mfhi $t3
addi $t3, $t3, 48
sb $t3, 5($s0)

li $t3, 10      # end line with \n
sb $t3, 6($s0)

li $v0,4
move $a0, $s0
syscall
jr $ra

sole2: #fff.fff
#print string
li $v0, 4
la $a0, format2
syscall

#allocate heap memory for format 1
li $v0, 9
li $a0, 8
syscall
move $s0, $v0

#get natural part to $a2 and fraction part to $a3
li $t2, 1000
mtc1 $t2, $f1
mul.s $f2, $f0, $f1
cvt.w.s $f3, $f2
mfc1 $a2, $f2
div $a2, $t2
mfhi $a3
mflo $a2

#solve narutal part
li $t2, 100
div $a2, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 0($s0)
mfhi $a2
li $t2, 10
div $a2, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 1($s0)
mfhi $a2
addi $t3, $a2, 48
sb $t3, 2($s0)

add $t3, $zero, 46
sb $t3, 3($s0)

#solve fraction part of sole 2
li $t2, 100
div $a3, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 4($s0)
mfhi $a3
li $t2, 10
div $a3, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 5($s0)
mfhi $a3
addi $t3, $a3, 48
sb $t3, 6($s0)

li $t3, 10      # end line with \n
sb $t3, 7($s0)

li $v0,4
move $a0, $s0
syscall
jr $ra

sole3: #fff.ffff
#print string
li $v0, 4
la $a0, format3
syscall

#allocate heap memory for format 1
li $v0, 9
li $a0, 9
syscall
move $s0, $v0

#get natural part to $a2 and fraction part to $a3
li $t2, 10000
mtc1 $t2, $f1
mul.s $f2, $f0, $f1
cvt.w.s $f3, $f2
mfc1 $a2, $f2
div $a2, $t2
mfhi $a3
mflo $a2

#solve narutal part
li $t2, 100
div $a2, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 0($s0)
mfhi $a2
li $t2, 10
div $a2, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 1($s0)
mfhi $a2
addi $t3, $a2, 48
sb $t3, 2($s0)

add $t3, $zero, 46
sb $t3, 3($s0)

#solve fraction part of sole 3
li $t2, 1000
div $a3, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 4($s0)
mfhi $a3
li $t2, 100
div $a3, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 5($s0)
mfhi $a3
li $t2, 10
div $a3, $t2
mflo $t3
addi $t3, $t3, 48
sb $t3, 6($s0)
mfhi $a3
addi $t3, $a3, 48
sb $t3, 7($s0)

li $t3, 10      # end line with \n
sb $t3, 8($s0)

li $v0,4
move $a0, $s0
syscall
jr $ra


main:
# GET TIME 
jal get_time

# SET SEED
jal set_seed

# RANDOM 3 FLOATINT POINT NUMBER 
# sole1
jal random_float
jal print_float
jal sole1
move $s2, $s0
#sole2
jal random_float
jal print_float
jal sole2
move $s3, $s0
#sole3
jal random_float
jal print_float
jal sole3
move $s4, $s0

#Write to file
jal write_file

# FINISH PROGRAM
li $v0, 10
syscall  # terminate
