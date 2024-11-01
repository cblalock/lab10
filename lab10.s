.data               # start of data section
# put any global or static variables here

.section .rodata    # start of read-only data section
# constants here, such as strings
# modifying these during runtime causes a segmentation fault, so be cautious!
multPrintString: .string "%d * %d = %d\n"
divPrintString: .string "answer is %d\n"

.text           # start of text /code
# everything inside .text is read-only, which includes your code!
.global main  # required, tells gcc where to begin execution



# === functions here ===

#takes a (rdi), /2, return whole num result
divby2:
    #save any callee saved registers
        #options:
        #1. save all callee saved registers %rbx, r12-15, rsp, rbp ( look at powerpoint )
        #2. just save the callee saved registers that we use
        #3. don't use any callee saved registers
        #4. ignore the rules

    #set up registers, %rdi -> %rdx
    movq %rdi, %rax     # n in rax
    #set up local variables
    movq $2, %rcx       # 2 in rcx
    #division
    cqto                #convert quad to oct. sign extend %rax-> %rdx (quad to 8, oct(8) to 16, doubles)
    idivq %rcx          #rdx:rax (n) / rcx(2) --> / in rax, % in rdx

    #result in %rax



    ret     #end of divby2()

main:           # start of main() function
# preamble
pushq %rbp
movq %rsp, %rbp

# === code here ===
# a = 2 * b = 3 = 6
# setup variables
movq $2, %rax       # a=2 in rax
movq %rax, %r12     # a=2 from rax into r12 (callee saved register (still there when return))
movq $3, %rbx       # b=3 in rbx

# multiplication
imulq %rbx          # rbx (3) * rax(2) -> 6, rdx:rax (c)

#printf("%d*%d =%d\n", a, b, c);
#1. save any caller saved registers
#2. set up registers: %rdi, %rsi, %rdx, %rcx
movq $multPrintString, %rdi    #ptr to string in rdi
movq %r12, %rsi                 # a in rsi 
movq %rbx, %rdx                 # b in rdx
movq %rax, %rcx                 # c in rcx
#3. place 0 in rax, no floating pt registers
xorq %rax, %rax     #0 in rax
#4. call function
call printf

#divby2(a)
#1. save any caller saved registers
#2. set up registers %rdi
movq %r12, %rdi         # a in rdi
#3. 0 in rax
xorq %rax, %rax
#4. call function
call divby2

#printf("answer is %d\n")
#1. save any callee saved regs
#2. set up regs rdi, rsi
movq $divPrintString, %rdi
movq %rax, %rsi
#3. 0 in rax
xorq %rax, %rax
#4. call function
call divPrintString


# return
movq $0, %rax   # place return value in rax
leave           # undo preamble, clean up the stack
ret             # return
