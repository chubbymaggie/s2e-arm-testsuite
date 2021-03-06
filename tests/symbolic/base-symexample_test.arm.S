.global _start
.text
.arm

.set stackstart, 	0x6000
.set symbstart,  	0x8000
.set exitval,     0xFF

/* Init */
_start:
	mov sp, #stackstart
	mov r8, #symbstart

/* Get an example */
symcon_main:
  bl symbolic_int
  mov r0, #0
  ldr r7, [r8]              @get the symbolic value
  cmp r7, #exitval
  bne ex_exit
  beq ff_exit
  
ff_exit: 
  mov r0, r8			          @address of symb. value
	mov r1, #4			          @size of symb. value = 4byte
  bl s2e_get_example
  ldr r0, [r8]
	adr r1, fftestok
	bl s2e_kill_state         @exiting with 0xFF

ex_exit: 
  mov r0, r8			          @address of symb. value
	mov r1, #4			          @size of symb. value = 4byte
  bl s2e_get_example
  ldr r0, [r8]
	adr r1, extestok
	bl s2e_kill_state         @exiting with an example != 0xFF

/* Create a symbolic integer value */
symbolic_int:
	stmfd sp!,{r14}
	sub r8, r8, #4		        @decrement (custom symb. value 'stack')
  // create symbint
	mov r0, r8			          @address of symb. value
	mov r1, #4			          @size of symb. value = 4byte
	adr r2, symname	          @symbol name
  bl s2e_make_symbolic
  // dump symbint
  mov r0, r8
  mov r1, #4
  adr r2, symarea
  bl s2e_print_memory
  ldmfd sp!,{r15}

.align 2
extestok:             .asciz "Test OK! Check exit values (example)."
.align 2
fftestok:             .asciz "Test OK! Check exit values (0xFF)."
.align 2
symarea:		          .asciz "Symbolic area"
.align 2
symname:		          .asciz "Symbolic integer"
.end
