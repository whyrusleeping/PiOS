.globl GetGpioAddress
GetGpioAddress:
ldr r0,=0x20200000 /* Store address of GPIO controller in r0 */
mov pc,lr /* 'return' */

.globl SetGpioFunction
SetGpioFunction:
/* Ensure that r0 is less than 54 */
cmp r0,#53
/* 
if r0 <= 53 then do:
ensure that r1 is less than 8
*/
cmpls r1,#7
/* if either fails, return early */
movhi pc,lr

/* push return address to the stack */
push {lr}
/* preserve r0 values */
mov r2,r0
bl GetGpioAddress

/*
While r2 is greater than 9, subtract 10 from it, and increment r0 by 4
essentially setting r0 = 4 * (r0 [pin number] / 10)
*/
functionLoop$:
	cmp r2,#9
	subhi r2,#10
	addhi r0,#4
	bhi functionLoop$

add r2, r2, lsl #1
lsl r1,r2
str r1,[r0]
pop {pc}

/*
Sets a given gpio pin on or off
*/
.globl SetGpio
SetGpio:
pinNum .req r0
pinVal .req r1

cmp pinNum, #53
movhi pc,lr /* return if pinNum < 53 */
push {lr}
mov r2, pinNum
.unreq pinNum
pinNum .req r2
bl GetGpioAddress /* call function to get GPIO address */
gpioAddr .req r0

pinBank .req r3
lsr pinBank, pinNum, #5
lsl pinBank,#2
add gpioAddr,pinBank
.unreq pinBank

and pinNum, #31
setBit .req r3
mov setBit,#1
lsl setBit,pinNum
.unreq pinNum

teq pinVal, #0
.unreq pinVal
streq setBit,[gpioAddr,#40]
strne setBit,[gpioAddr,#28]
.unreq setBit
.unreq gpioAddr
pop {pc}

