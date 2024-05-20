//------------------------------------------------------------------------------

//UNIVERSIDAD DEL VALLE DE GUATEMALA
//Laboratorio 10, parte 1
//Org. de computadoras y assembler
//Nina Nájera - 231088
//Mishell Ciprian - 231169

//------------------------------------------------------------------------------

//encender led PA5
//DECLARACION DE CONSTANTES PARA CONFIGURACION DE PORTA5
//VALORES PARA HABILITAR EL CLK AHB1 PORT A//

.equ RCC_BASE, 0X40023800 //reg base para habilitar el reloj de los periféricos
.equ AHB1ENR_OFFSET, 0X30 //Desplazamiento para habilitar AHB1 0x30 + portA 0

.equ RCC_AHB1ENR, (RCC_BASE + AHB1ENR_OFFSET)

.equ GPIOA_EN, (1 << 0) //ESTABLECER EL BIT 0 EN 1 PARA HABILITAR CLK EN PA

.equ GPIOA_BASE, 0x40020000 //direccion base del puerto A
.equ GPIOA_MODER_OFFSET, 0x00 //direccion del puerto GPIO específico

.equ GPIOA_MODER,	(GPIOA_BASE + GPIOA_MODER_OFFSET)
.equ MODER5_OUT, 	(1 << 10) //Dar valor 01 a bits 11:10

//VALORES PARA ENCENDER PORT 5A

.equ	GPIOA_ODR_OFFSET, 0x14
.equ	LED5_ON, (1 << 5) //dar valor al pin que se usará como salida
.equ	GPIOA_ODR,		(GPIOA_BASE + GPIOA_ODR_OFFSET)

.equ DELAY_COUNT, 10000000 // Aproximadamente 3 segundos de retraso

.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.section .text
.globl __main

__main:
	//enable clock acces to gpioa

	//carga de direccion de RCC_AHB1ENR al r0
	LDR R0, =RCC_AHB1ENR

	//cargar el valor contenido en RCC_AHB1ENR a r1, para definir el pin PA5 como el pin a modificar
	LDR R1, [R0]
	ORR r1, #GPIOA_EN
	STR R1, [R0]

	//ESTABLECER PA5 COMO SALIDA
	LDR R0, =GPIOA_MODER
	LDR R1, [R0]
	ORR R1, #MODER5_OUT
	STR R1, [R0]

	// Repetir el ciclo 10 veces
	MOV R2, #10

loop:
	//ENCENDER EL LED
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1, #LED5_ON
	STR R1, [R0]

	//LLAMAR A LA RUTINA DE RETARDO
	BL delay

	//APAGAR EL LED
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, #LED5_ON
	STR R1, [R0]

	//LLAMAR A LA RUTINA DE RETARDO
	BL delay

	//DECREMENTAR EL CONTADOR Y VERIFICAR SI SE HA COMPLETADO EL CICLO
	SUBS R2, R2, #1
	BNE loop

	bx lr

// Rutina de retardo
delay:
	PUSH {R0, R1, R2}
	LDR R2, =DELAY_COUNT
delay_loop:
	SUBS R2, R2, #1
	BNE delay_loop
	POP {R0, R1, R2}
	BX LR

.section .data

		.align
		.end
//done :)
