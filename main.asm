; ***********************************************************
;   INTESC electronics & embedded
;
;   Curso b�sico de microcontroladores en ensamblador	    
;
;   Pr�ctica 5: Uso del m�dulo EUSART
;   Objetivo: Conocer el funcionamiento del m�dulo EUSART
;
;   Fecha: 05/Jun/16
;   Creado por: Daniel Hern�ndez Rodr�guez
; ************************************************************

LIST    P = 18F4550	;PIC a utilizar
INCLUDE <P18F4550.INC>

;************************************************************
;Configuraci�n de fusibles
CONFIG  FOSC = HS   
CONFIG  PWRT = ON
CONFIG  BOR = OFF
CONFIG  WDT = OFF
CONFIG  MCLRE = ON
CONFIG  PBADEN = OFF
CONFIG  LVP = OFF
CONFIG  DEBUG = OFF
CONFIG  XINST = OFF

;***********************************************************
;C�digo

CBLOCK  0x080
    recibido
ENDC
    
ORG 0x00    ;Iniciar el programa en el registro 0x00
    
    movlw   0x00
    movwf   TRISB	;Puerto B como salida
    movlw   0xFF
    movwf   TRISC	;CONF. PARA HABILITAR EUSART

;CONFIGURACI�N PARA LA RECEPCI�N DE DATOS
    movlw   D'12'
    movwf   SPBRG	    ;Configuraci�n de baudios adecuada (9600)
    bcf	    TXSTA,BRGH	    ;Low speed
    bcf	    BAUDCON,BRG16   ;Selecci�n de velocidad adecuada (8 bit) Solo SPBRG
    bcf	    TXSTA,SYNC	    ;Puerto serial as�ncrono
    bsf	    RCSTA,SPEN	    ;Habilita puerto serial
    bsf	    RCSTA,CREN	    ;Habilitamos la recepci�n
    
;CONFIGURACI�N PARA EL ENV�O DE DATOS
    ;movlw   D'12'
    ;movwf   SPBRG		    ;Configuraci�n de baudios adecuada (9600)
    ;bcf	    TXSTA,BRGH	    ;Low speed
    ;bcf	    BAUDCON,BRG16   ;Selecci�n de velocidad adecuada (8 bit) Solo SPBRG
    ;bcf	    TXSTA,SYNC	    ;Puerto serial as�ncrono
    ;bsf	    RCSTA,SPEN	    ;Habilita puerto serial
    bsf	    TXSTA,TXEN	    ;Habilitamos el env�o
    
ESPERA
    btfss   PIR1,RCIF	    ;Esperamos a que est� lista la conversi�n
    goto    ESPERA	    ;Regresamos a espera
    movff   RCREG,recibido  ;Almacenamos el dato recibido
    movff   recibido,PORTB  ;Mostramos el dato recibido en el puerto B
    movff   recibido,TXREG  ;Enviamos por TX el mismo dato recibido
    bsf	    RCSTA,CREN	    ;Habilitamos la recepci�n de datos
    goto    ESPERA	    ;Regresamos a esperar la recepci�n de un dato
	
end





