.globl GetSystemTimerAddress
GetSystemTimerAddress:
ldr r0,=0x20003000
mov pc,lr

.globl GetTimeStamp
GetTimeStamp:
push {lr}
bl GetSystemTimerAddress
ldrd r0,r1,[r0,#4]
pop {pc}

.globl Wait
Wait:
push {lr}
delay .req r2
mov delay, r0
bl GetTimeStamp
start .req r3
end .req r4
mov start, r0
add end, start, delay
WaitLoop$:
	bl GetTimeStamp
	cmp r0, end
	bls WaitLoop$
.unreq start
.unreq end
.unreq delay
pop {pc}

