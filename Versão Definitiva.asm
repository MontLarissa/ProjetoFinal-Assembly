TITLE Batalha Naval - Projeto Final
.MODEL SMALL
.stack 0100h
IMPMENSAG MACRO MGSDESJ
              LEA DX, MGSDESJ
              MOV AH,09
              INT 21H
ENDM
PULA_LINHA MACRO
               PUSH AX
               PUSH DX
               MOV  AH, 02
               MOV  DL, 10
               INT  21H
               POP  DX
               POP  AX
ENDM
INFORMATRIZ MACRO COLUNAINICIAL, LINHAINICIAL,LINHAFINAL
                MOV BX,COLUNAINICIAL
                MOV SI,LINHAINICIAL
                MOV DI,LINHAFINAL
ENDM
LIMPA_TELA MACRO
    ;Limpa a Tela
               MOV AH, 06H
               MOV AL, 0
               MOV BH, 07H
               MOV CX, 0
               MOV DX, 184FH
               INT 10H
    ;Move Cursor
               MOV AH, 02H
               MOV BH, 0        ;Coluna
               MOV DH, 3        ;Linha
               MOV DL, 0
               INT 10H
ENDM
SALVAMJOGO MACRO
               PUSH BX
               PUSH SI
               PUSH DI
ENDM
VOLTAVALOR MACRO
               POP BX
               POP SI
               POP DI
ENDM
ESPAÇO MACRO
    PUSH AX
    PUSH DX

    MOV AH, 02H
    MOV DL, 20H
    INT 21H

    POP DX
    POP AX
ENDM
TAB MACRO
         PUSH AX
         PUSH DX

         MOV  AH, 02H
         MOV  DL, 09H
         INT  21H

         POP  DX
         POP  AX
ENDM
NUMEROS MACRO
            MOV DL,AL
            INT 21H
            INC AL
ENDM
LETRAS MACRO
           MOV DX, [DI]
           ADD DI, 2
           INT 21H
ENDM
;!!Ajeitar as matrizes!!;
.DATA
    MATRIZMAPA   DW 0,0,0,0,0,0,1,1,1,0     ,     1,1,1,0,0,0,0,0,0,0
                 DW 0,0,1,0,0,0,0,1,0,0     ,     0,0,0,0,1,0,0,0,0,0
                 DW 0,0,1,0,0,0,0,0,0,0     ,     0,0,0,1,1,0,0,0,0,0
                 DW 0,0,0,0,0,0,0,1,0,0     ,     0,0,0,0,1,0,1,1,0,0
                 DW 0,0,0,0,0,0,0,1,1,0     ,     0,0,0,0,0,0,0,0,0,0
                 DW 0,0,0,0,0,0,0,1,0,0     ,     1,1,1,1,0,0,0,0,0,0
                 DW 1,1,1,0,0,0,0,0,0,0     ,     0,0,0,0,0,0,0,1,0,0
                 DW 0,0,0,0,0,1,1,0,0,0     ,     1,1,0,0,0,0,0,1,1,0
                 DW 0,0,0,0,0,0,0,0,0,0     ,     0,0,0,0,0,0,0,1,0,0
                 DW 1,1,1,1,0,0,0,0,0,0     ,     0,0,0,0,0,0,0,0,0,0

                 DW 1,1,1,0,0,0,0,1,1,1     ,     0,0,0,1,0,0,0,1,1,0
                 DW 0,1,0,0,0,0,0,0,1,0     ,     0,0,0,1,1,0,0,0,0,0
                 DW 0,0,0,0,0,0,0,0,0,0     ,     0,0,0,1,0,0,0,1,1,1
                 DW 0,0,0,1,1,1,1,0,0,0     ,     0,1,0,0,0,0,0,0,0,0
                 DW 0,0,0,0,0,0,0,0,0,0     ,     0,1,0,0,0,0,0,1,1,1
                 DW 0,0,0,0,0,0,0,0,0,0     ,     0,0,0,0,0,0,0,0,1,0
                 DW 0,0,0,0,0,1,0,0,0,1     ,     0,0,0,0,1,0,0,0,0,0
                 DW 0,0,0,0,0,1,0,0,0,1     ,     0,0,0,0,1,0,0,0,0,0
                 DW 0,0,0,0,0,0,0,0,0,1     ,     0,0,0,0,1,0,0,0,0,0
                 DW 1,1,0,0,0,0,0,0,0,0     ,     0,0,0,0,1,0,0,0,0,0
                     
    MATRIZIMPRESSÃO DW 10 DUP(10 DUP('~'))
    LETRA        DW 41H,42H,43H,44H,45H,46H,47H,48H,49H,04AH
    ARMAZENACORDENADA  DW 2 DUP (0)
    ACERTOCONTADOR     DB 19
    TENTATIVAS         DB 70
    ;Mensagens;
    ;Pagina Inicial;
    LOGO1        DB 13,10,'              ===================================================              ', '$'
    LOGO2        DB 13,10,'              =                                                 =            ', '$'
    LOGO3        DB 13,10,'              =     Batalha     Naval     Em     Assembly       =            ','$'
    LOGO4        DB 13,10,'              =                                                 =            ','$'
    LOGO5        DB 13,10,'              ===================================================              ', 13,10, '$'
    ENTMSG1      DB 13,10,'              Insira ate 3 numeros de 0-9 para iniciar o jogo:', '$'

    PEDECORDENADA      DB 13,10,'              Informe a cordenada do tiro:', '$'
    CORDENADANAOACEITA DB 13,10,'              Cordenada nao encontrada, tente novamente', '$'
    ACERTODETIRO       DB 13,10,'              Acerto de tiro!', '$'
    ERRODETIRO         DB 13,10,'              Nao ha inimigos nessa cordenada.', '$'
    SAIRJOGO           DB 13,10,'              Para sair do jogo aperte ESC', '$'
    DESISTIUMSGDB      DB 13,10,'              Voce desistiu do jogo, que pena', '$'
    FIMDJOGO DB 13,10,'              GAME OVER', '$'
.CODE
MAIN PROC
    ;Acesso ao DATA
                     MOV               AX, @DATA
                     MOV               DS,AX 
                     
                     CALL              INICIAR
                     
                     XOR AX,AX
                     MOV AL,TENTATIVAS
                     MOV CX,AX
        TENTATIVASS:              
                     CALL              IMPRIMEINTERFACE
                     CALL              INTERFACE
                     LOOP TENTATIVASS

                     LIMPA_TELA
                     IMPMENSAG         FIMDJOGO
    ;Termina o programa
                     MOV               AH,4CH
                     INT               21H
MAIN ENDP
INICIAR PROC
                     LIMPA_TELA
                     IMPMENSAG         LOGO1
                     IMPMENSAG         LOGO2
                     IMPMENSAG         LOGO3
                     IMPMENSAG         LOGO4
                     IMPMENSAG         LOGO5
                     IMPMENSAG         ENTMSG1
                     MOV               CX, 3
                     XOR               BX,BX
                     XOR               DX,DX
                     MOV               AH,1
    LerEnt:          
                     INT               21h
                     CMP               AL, 0DH
                     JE                CompENT
                     MOV               DL,AL
                     ADD               BL, DL
                     LOOP              LerEnt
    CompENT:         
                     CMP               BL, 4
                     JB                PulaParaFim

    DivDerminadaM:   
                     MOV               AX, BX
                     MOV               BL, 4
                     DIV               BL
    CompQUA:         
                     CMP               AH, 1
                     JE                QUA1

                     CMP               AH, 2
                     JE                QUA2

                     CMP               AH, 3
                     JE                QUA3
                      
                     CMP               AH, 0
                     JE                QUA4
    PulaParaFim:     
                     JMP               RetornaEnt
    QUA1:            
                     INFORMATRIZ       0,0,360
                     SALVAMJOGO
                     JMP               RetornaEnt
    QUA2:            

                     INFORMATRIZ       20,0,360
                     SALVAMJOGO
                     JMP               RetornaEnt
    QUA3:            

                     INFORMATRIZ       0,400,760
                     SALVAMJOGO
                     JMP               RetornaEnt
    QUA4:            
                     INFORMATRIZ       20,400,760
                     SALVAMJOGO
                     JMP               RetornaEnt
    RetornaEnt:      
                     VOLTAVALOR
                     RET
INICIAR ENDP
IMPRIMEINTERFACE PROC
                     SALVAMJOGO
                     LIMPA_TELA
                     Pula_linha
                     TAB
                     TAB
ESPAÇO
                     MOV               CX, 10
                     MOV               AL, 30H
                     MOV               AH, 02H
    NUMEROS1:        
ESPAÇO
ESPAÇO
ESPAÇO
                     NUMEROS
                     LOOP              NUMEROS1

    MATRIZELETRAS:   
                     PULA_LINHA
                     TAB
                     TAB
                     LEA               DI, LETRA
                     XOR               BX, BX
                     XOR               SI, SI
                     MOV               CX, 10
                     JMP               L1
    MUDALINHA:       
                     XOR               BX, BX
                     ADD               SI, 20
                     MOV               CX, 10
                     CMP               SI, 180
                     JG                FIM
    L1:              
                     PULA_LINHA
                     TAB
                     TAB
                     MOV               AH, 02H
                     LETRAS
    IMPRIMELINHA:    
ESPAÇO
ESPAÇO
ESPAÇO
                     MOV               DX, MATRIZIMPRESSÃO[SI][BX]
                     OR                DL, 30H
                     INT               21H
                     ADD               BX, 2
                     LOOP              IMPRIMELINHA
                     JMP               MUDALINHA
    FIM:             
                     VOLTAVALOR
                     RET
IMPRIMEINTERFACE ENDP
INTERFACE PROC
                         PULA_LINHA
                         SALVAMJOGO
    
    INICIO:              
                         IMPMENSAG         PEDECORDENADA
    
                         XOR               SI, SI
                         MOV               CX, 2
                         MOV               AH, 1
    Ler:                 
                         INT               21h
                         CMP               AL, 01BH
                         JE                ESCACIONADO
                         MOV               DL, AL
                         MOV               ARMAZENACORDENADA[SI], DX
                         ADD               SI, 2
                         LOOP              Ler

                         CALL              CONVERSAODECORDENADA

                         XOR               SI,SI
VERIFICAÇÃO:
                         MOV               AX,ARMAZENACORDENADA[SI]
                         CMP               AX,18H
                         JBE               SAIR
    ERRORCOR:            
                         IMPMENSAG         CORDENADANAOACEITA
                         JMP               INICIO
    ESCACIONADO:         
                CALL SAIRESC
    SAIR:                
                         VOLTAVALOR
                         RET
INTERFACE ENDP
CONVERSAODECORDENADA PROC
                         LEA               SI, ARMAZENACORDENADA
                         MOV               AX,[SI]
                         JMP               COMPL
    MINUSCULO:           
                         SUB               AX, 20H
    COMPL:               
                         CMP               AX, 4AH
                         JG                MINUSCULO
                         SUB               AX,41H
                         ADD               AX,AX
                         MOV               [SI],AX

    CONVERTENUMERO:      
                         ADD               SI,2
                         MOV               AX,[SI]
    COMPN:               
                         SUB               AX,30H
                         ADD               AX,AX
                         MOV               [SI],AX

                         RET
CONVERSAODECORDENADA ENDP
SAIRESC PROC
                         LIMPA_TELA
                         IMPMENSAG         DESISTIUMSGDB
                         MOV               AH,4CH
                         INT               21H
                         RET
SAIRESC ENDP
END MAIN