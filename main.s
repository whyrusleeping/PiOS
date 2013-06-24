.section .init
.globl _start
_start:
b main

.section .text
main:
mov sp,#0x8000


pinNum .req r0
pinFunc .req r1
mov pinNum,#16
mov pinFunc,#1
bl SetGpioFunction
.unreq pinFunc
.unreq pinNum

/* we only care about pin 16 right now */
ptrn .req r4
ldr ptrn,=pattern
ldr ptrn,[ptrn]
seq .req r5
mov seq r5

loop$:

/* call SetGpio with parameters 16 (ok led) and 0 (low = on) */
pinNum .req r0
pinVal .req r1
mov pinVal,#0
mov pinNum,#16
bl SetGpio
.unreq pinNum
.unreq pinVal

mov r0,#0x80000
bl Wait

pinNum .req r0
pinVal .req r1
mov pinVal,#1
mov pinNum,#16
bl SetGpio
.unreq pinNum
.unreq pinVal

mov r0,#0x80000
bl Wait

b loop$


.section .data
.align 2
pattern:
.int 0b11010110100101001011010001010110
