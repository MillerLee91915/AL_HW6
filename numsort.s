.set SWI_Write, 0x5
.set SWI_Open, 0x1
.set SWI_Close, 0x2
.set AngelSWI, 0x123456

/* ========================= */
/*       DATA section        */
/* ========================= */
    .data
    .align 4
str_addr:
    .space 400

    .align 4
format_1:
    .ascii "%d,"

    .align 4
format_2:
    .ascii "%d"

    .align 4
format_3:
    .ascii "The string is %s\n\000"

filename:
	.ascii "result.txt\000"

/* ========================= */
/*       TEXT section        */
/* ========================= */
    .section .text
    .global NumSort
    .type NumSort,%function

.open_param:
	.word filename
	.word 0x4
	.word 0x8

.write_param:
	.space 4   /* file descriptor */
	.space 4   /* address of the string */
	.space 4   /* length of the string */

.close_param:
	.space 4
/* ========================= */
/*    Seleciotn  section     */
/* ========================= */
NumSort:
    /* function start */
    MOV ip, sp
    STMFD sp!, {r0-r9, fp, ip, lr, pc}
    SUB fp, ip, #4
    /* --- begin your function --- */
    /* Get array address from r0 */
    LDR r0, [ip], #4
    /* Get array size from r1 */
    LDR r1, [ip], #4
	
    /* Get array address and save at r10 */
    MOV r10, r0 
    /* Get array size and save at r9 */
    MOV r9, r1

    /* malloc and set the address to r8 */
    MOV r0, r9, LSL #2
    bl malloc
    MOV r8, r0

    MOV r2, #0
	MOV r4, #0
	MOV r5, #0
LOOP:
    /* copy arrA to arrB*/ 
    CMP r5, r9
    BGE EXIT0
    LDR r7,[r10,r2,LSL#2]
    ADD r2, #1
    STR r7,[r8,r4,LSL#2]
    ADD r4, #1
    ADD r5, r5, #1
    B LOOP
    
EXIT0:
    /* r0 contains the address of array */
    MOV r0, r8
    /* r1 contains the first element    */
    MOV r1, #0 
    /* r2 contains the number of element */
    MOV r2, r9

    MOV r3,r1                                              @ start index i
    SUB r7,r2,#1                                           @ compute n - 1
LOOP1:                                                     @ start loop
    MOV r4,r3
    ADD r5,r3,#1                                           @ init index 2
LOOP2: 
    LDR r1,[r0,r4,LSL #2]                                  @ load value A[mini]
    LDR r6,[r0,r5,LSL #2]                                  @ load value A[j]
    CMP r6,r1                                              @ compare value
    MOVLT r4,r5                                            @ j -> mini
    ADD r5,#1                                              @ increment index j
    CMP r5,r2                                              @ end ?
    BLT LOOP2                                              @ no -> loop
    CMP r4,r3                                              @ mini <> j ?
    BEQ LOOP3                                              @ no
    LDR r1,[r0,r4,LSL #2]                                  @ yes store A[mini] to B[i]
    LDR r6,[r0,r3,LSL #2]
    STR r1,[r0,r3,LSL #2]
    STR r6,[r0,r4,LSL #2]
LOOP3:
    ADD r3,#1                                              @ increment i
    CMP r3,r7                                              @ end ?
    BLT LOOP1                                              @ no -> loop 
EXIT:
    /* sprintf to str */
	MOV r4, #0
	MOV r5, #1
LOOP4: 
    CMP r5, r9
    BGE EXIT1
    MOV r6, r5
    SUB r6, r6, #1
    LDR r0, =str_addr
    ADD r0, r0, r4
    LDR r1, =format_1
    LDR r2, [r8,r6,LSL#2]
    BL sprintf
    
    ADD r4, r0
    ADD r5, r5, #1
    B LOOP4
EXIT1:
    MOV r6, r5
    SUB r6, r6, #1
    LDR r0, =str_addr
    ADD r0, r0, r4
    LDR r1, =format_2
    LDR r2, [r8,r6,LSL#2]
    BL sprintf

    LDR r0,=format_3
    LDR r1,=str_addr
    BL printf

    /* open a file */
    MOV r0, #SWI_Open
	ADR r1, .open_param
	SWI AngelSWI
    /* r2 is file descriptor */
	MOV r2, r0 

    ADR r1, .write_param
    /* store file descriptor */
	STR r2, [r1, #0]

    LDR r3, =str_addr
    /* store the address of string */
	STR r3, [r1, #4]

    MOV r3, #19
	STR r3, [r1, #8]

    MOV r0, #SWI_Write
	SWI AngelSWI

    /* close a file */
    ADR r1, .close_param
	STR r2, [r1, #0]
    /* --- end of your function --- */
    /* put result array’s address into r0 */ 
    MOV r0, r8 
    nop
    /* function exit */
    LDMFD sp!, {r0-r9, fp, ip, pc}
.end