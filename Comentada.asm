TITLE Batalha Naval - Projeto Final
.MODEL SMALL
.stack 0100h
;Macro que mostra mensagem inicial na tela
IMPMENSAG MACRO MGSDESJ
              LEA DX, MGSDESJ        ;Carrega o endereço da string em DX
              MOV AH,09              ;Faz a exibição onde a string aponta para DX até encontrar o $
              INT 21H
ENDM
;Pular linha
PULA_LINHA MACRO
               PUSH AX               
               PUSH DX               
               MOV  AH, 02          ;É efetuado um "enter" como forma de pular linha
               MOV  DL, 10          ;Função para exibição de caractere para a exibição do caractere ASCII 10 (nova linha)
               INT  21H             
               POP  DX              ;É usado PUSH e POP par salvar e restaurar os valores dos registradores AX e DX,
               POP  AX              ;evitando interferências em outras operações.
ENDM
;Macro para declarações 
INFORMATRIZ MACRO COLUNAINICIAL, LINHAINICIAL,LINHAFINAL        ;Definição dos limites dos qadrantes da matriz
                MOV BX,COLUNAINICIAL                            ;Configuração dos registradores onde:BX coluna inicial
                MOV SI,LINHAINICIAL                             ;SI linha inicial
                MOV DI,LINHAFINAL                               ;DI para a linha final 
ENDM
;Macro para limpar a tela
LIMPA_TELA MACRO
    
               MOV AH, 06H           ;É feita a limpeza dela usando a interrupção 10h, função 06h (função scroli das linhas/limpar a tela) 
               MOV AL, 0             ;0 é definido correspondente ao valor de linhas que deverá rolar, ou seja, todas as linhas
               MOV BH, 07H           ;07h correspondente ao fundo preto, atributo de vídeo para preencher a tela.
               MOV CX, 0
               MOV DX, 184FH
               INT 10H               ;Exibição
    ;Move Cursor
               MOV AH, 02H
               MOV BH, 0        ;Coluna
               MOV DH, 3        ;Linha
               MOV DL, 0
               INT 10H
ENDM
;Salvar jogo
SALVAMJOGO MACRO               ;Salva os valores de BX, SI e DI na pilha.
               PUSH BX
               PUSH SI
               PUSH DI
ENDM
;Volta o valor
VOLTAVALOR MACRO               ;Recupera esses valores da pilha para restaurar o estado anterior.
               POP BX
               POP SI
               POP DI
ENDM
;Espaçamento
ESPAÇO MACRO                          ;Função para o enquadramento da matriz, adicionando espaços visuais.
    PUSH AX
    PUSH DX

    MOV AH, 02H                       ;Move o cursor uma única posição para a direita, adicionando espaço fixo.
    MOV DL, 20H                       ; Função para a exibição do espaço do código ASCII 20h atribuída a DL.
    INT 21H

    POP DX
    POP AX
ENDM
;Tabulação
TAB MACRO
         PUSH AX
         PUSH DX

         MOV  AH, 02H
         MOV  DL, 09H                ;Adiciona um espaçamento horizontal com o código ASCII 09h. 
         INT  21H                    ;Move o cursor para a próxima posição da tabulação predefinida

         POP  DX
         POP  AX
ENDM
;Impressão dos números
NUMEROS MACRO
            MOV DL,AL                ;Imprime o número armazenado em AL
            INT 21H
            INC AL                   ;Incrementa o mesmo
ENDM
;Impressão das letras
LETRAS MACRO
           MOV DX, [DI]              ;Imprime o caractere armazenado no endereço apontador para DI 
           ADD DI, 2                 ;Incrementa DI para o mesmo apontar para o próximoo caractere
           INT 21H
ENDM
;Declaração das matrizes
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
    ;Mensagens;
    ;Pagina Inicial;
    LOGO1        DB 13,10,'              ===================================================              ', '$'
    LOGO2        DB 13,10,'              =                                                 =            ', '$'
    LOGO3        DB 13,10,'              =     Batalha     Naval     Em     Assembly       =            ','$'
    LOGO4        DB 13,10,'              =                                                 =            ','$'
    LOGO5        DB 13,10,'              ===================================================              ', 13,10, '$'
    ENTMSG1      DB 13,10,'              Insira ate 3 numeros de 0-9 para iniciar o jogo:', '$'
.CODE
MAIN PROC
    ;Acesso ao DATA
                     MOV               AX, @DATA
                     MOV               DS,AX

                     CALL              INICIAR
                     CALL              IMPRIMEINTERFACE
    ;Termina o programa
                     MOV               AH,4CH
                     INT               21H
MAIN ENDP
;Ínicio de procedimento
INICIAR PROC
                     LIMPA_TELA                              ;Chama a macro LIMPA_TELA
                     IMPMENSAG         LOGO1                 ;Exibição das linhas 
                     IMPMENSAG         LOGO2
                     IMPMENSAG         LOGO3
                     IMPMENSAG         LOGO4
                     IMPMENSAG         LOGO5
                     IMPMENSAG         ENTMSG1              ;Até a última mensagem de ínicio do jogo
                     MOV               CX, 3                ;Definição do número máximo de entradas
                     XOR               BX,BX                ;Limpa BX
                     XOR               DX,DX                ;Limpa DX
                     MOV               AH,1                 ;Leitura de entrada de caractere
    LerEnt:          
                     INT               21h
                     CMP               AL, 0DH              ;Verifica se é o caracter "enter"
                     JE                CompENT              ;Se for "enter" pula para CompENT
                     MOV               DL,AL
                     ADD               BL, DL               ;Soma o valor ASCII do caractere em BL
                     LOOP              LerEnt               ;Loop até CX zerar
    CompENT:         
                     CMP               BL, 4                ;Compara BL com 4
                     JB                PulaParaFim          ;Se a comparação for menor que BL, pula para PulaParaFim

    DivDerminadaM:   
                     MOV               AX, BX               ;Move o valor de BX para AX
                     MOV               BL, 4                ;Define o divisor como 4
                     DIV               BL                   ;Divide AX por BL
    CompQUA:         
                     CMP               AH, 1                ;Compara o resto da divisão com 1
                     JE                QUA1                 ;Se resto=1, vai para QUA1

                     CMP               AH, 2                ;Compara o resto da divisão com 2
                     JE                QUA2                 ;Se resto=2, vai para QUA2

                     CMP               AH, 3                ;Compara o resto da divisão com 3
                     JE                QUA3                 ;Se resto=3, vai para QUA3
                      
                     CMP               AH, 0                ;Compara o resto da divisão com 0
                     JE                QUA4                 ;Se resto=4, vai para QUA4
    PulaParaFim:     
                     JMP               RetornaEnt           ;Salta para RetornaEnt
    QUA1:            
                     INFORMATRIZ       0,0,360              ;Define os limites da matriz para a área do quadrante 1     
                     SALVAMJOGO                             ;Salva o estado atual na pilha
                     JMP               RetornaEnt           ;Salta para RetornaEnt
    QUA2:            

                     INFORMATRIZ       20,0,360             ;Define os limites da matriz para a área do quadrante       
                     SALVAMJOGO                             
                     JMP               RetornaEnt
    QUA3:            

                     INFORMATRIZ       0,400,760            ;Define os limites da matriz para a área do quadrante 
                     SALVAMJOGO
                     JMP               RetornaEnt
    QUA4:            
                     INFORMATRIZ       20,400,760           ;Define os limites da matriz para a área do quadrante 1
                     SALVAMJOGO
                     JMP               RetornaEnt
    RetornaEnt:      
                     VOLTAVALOR
                     RET
INICIAR ENDP
;Interface do game
IMPRIMEINTERFACE PROC
                     SALVAMJOGO                             ;Salva o estado atual do jogo na pilha
                     LIMPA_TELA                             ;Limpa a tela 
                     Pula_linha                             ;Move o cursor para a próxima linha
                     TAB                                    ;Tabulação para posicionamneto inicial
                     TAB                                    ;Tabulação para espaçamento adicional
;Adiciona um espaço fixo na interface
ESPAÇO
                     MOV               CX, 10               ;Contador para imprimir números
                     MOV               AL, 30H              ;Inicializa AL 
                     MOV               AH, 02H
    NUMEROS1:        
ESPAÇO
ESPAÇO
ESPAÇO
                     NUMEROS                                ;Exibição do número em AL e do incrementado
                     LOOP              NUMEROS1             ;Decrementa CX e repete até que CX seja zero

    MATRIZELETRAS:   
                     PULA_LINHA
                     TAB
                     TAB
                     LEA               DI, LETRA            ;Lê o endereço do array de letras em DI
                     XOR               BX, BX
                     XOR               SI, SI
                     MOV               CX, 10               ;Define um contador para processar 10 letras
                     JMP               L1                   ;Salta para L1 para imprimir
    MUDALINHA:       
                     XOR               BX, BX               ;Zera BX ao mudar de linha
                     ADD               SI, 20               ;Avança para a próxima linha
                     MOV               CX, 10               ;Redefine o contador para 10 colunas
                     CMP               SI, 180              ;Verifica se todas as linhas foram processadas          
                     PULA_LINHA
                     JG                FIM                  ;Se SI for maior que 180, termina o proc
    L1:              
                     PULA_LINHA                             ;Move o cursor para a próxima linha
                     TAB
                     TAB
                     MOV               AH, 02H              ;Exibição
                     LETRAS
    IMPRIMELINHA:    
ESPAÇO
ESPAÇO
ESPAÇO
                     MOV               DX, MATRIZIMPRESSÃO[SI][BX]      ;Carrega um elemento da matriz para DX
                     OR                DL, 30H                          ;Converte o número para seu equivalente ASCII
                     INT               21H
                     ADD               BX, 2                            ;Avança para a próxima linha
                     LOOP              IMPRIMELINHA                     ;Decrementa CX e repete
                     JMP               MUDALINHA                        ;Após processar uma linha, alta para MUDALINHA
    FIM:             
                     VOLTAVALOR                              ;Restaura os valores originais dos regs
                     RET                                     ;Retorna ao chamador, finalizando o proc
IMPRIMEINTERFACE ENDP
END MAIN