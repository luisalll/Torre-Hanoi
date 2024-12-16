section .data                         ; Seção para armazenar variáveis e strings iniciais usadas no programa

    ; Definindo as mensagens para exibição no terminal
    move db " Mova o disco ", 0
    tam_move equ $-move
    
    disc db " ",0
    
    torre_inicial db " da torre ", 0
    tam_inicial equ $-torre_inicial
    
    torre_um db " ", 0
    
    torre_final db " para a torre ", 0
    tam_final equ $-torre_final
    
    torre_dois db " "
    
    tam_um_dig equ 1
    
    nova_linha db 0x0A           ; Caractere de nova linha para formatar a saída
    
    torre_origem db "A", 0       ; Torre de origem (A)
    torre_destino db "C", 0      ; Torre de destino (C)
    torre_auxiliar db "B", 0     ; Torre auxiliar (B)

section .text                         ; Seção contendo o código executável do programa

    global _start                     ; Definição do ponto de entrada do programa

    _start:                           ; Início do código
        push ebp                      ; Salva o valor de ebp na pilha para gerenciar o contexto da pilha
        mov ebp, esp                  ; Define o ponteiro da pilha (esp) como base para o rastreamento

        mov eax, 2                    ; Define o número de discos a serem movidos (2 discos)
        
        push dword torre_auxiliar     ; Empilha o endereço da torre auxiliar
        push dword torre_destino      ; Empilha o endereço da torre de destino
        push dword torre_origem       ; Empilha o endereço da torre de origem
        
        push eax                      ; Empilha o número de discos
        call torre_de_hanoi                    ; Chama a função hanoi para começar o processo

        call fim                      ; Chama a função fim para finalizar o programa

; Funções usadas para resolver o problema da Torre de Hanói
    torre_de_hanoi:
        push ebp                      ; Salva o valor de ebp para preservar o contexto da pilha
        mov ebp, esp                  ; Define esp como base da pilha para acesso aos parâmetros

        mov eax, [ebp+8]              ; Carrega o número de discos (primeiro parâmetro) em eax
        cmp eax, 1                    ; Verifica se há apenas um disco
        jne mais_discos               ; Se não for o caso, chama a função para mover mais discos

    ; Caso base: mover um único disco
        push dword [ebp+16]           ; Empilha a torre de destino
        push dword [ebp+12]           ; Empilha a torre de origem
        push dword [ebp+8]            ; Empilha o disco a ser movido (1 disco)

        call movimento                  ; Chama a função de impressão para exibir o movimento
        
        add esp, 12                   ; Limpa a pilha após a chamada

        jmp desempilhar               ; Pula para o fim da função, sem recursão

    mais_discos:
        ; Primeira recursão: move os n-1 discos para a torre auxiliar
        push dword [ebp+16]           ; Empilha a torre auxiliar
        push dword [ebp+20]           ; Empilha a torre de destino
        push dword [ebp+12]           ; Empilha a torre de origem

        dec eax                       ; Decrementa o número de discos
        push dword eax                ; Empilha o número de discos restantes
        call torre_de_hanoi                    ; Chama a função torre_de_hanoi recursivamente

        add esp, 16                   ; Limpa a pilha após a chamada recursiva

        ; Mover o maior disco
        push dword [ebp+16]           ; Empilha a torre de destino
        push dword [ebp+12]           ; Empilha a torre de origem
        push dword [ebp+8]            ; Empilha o maior disco a ser movido

        call movimento                  ; Chama a função para imprimir o movimento
        
        add esp, 12                   ; Limpa a pilha após a impressão

        ; Segunda recursão: move os n-1 discos da torre auxiliar para a torre de destino
        push dword [ebp+12]           ; Empilha a torre de origem
        push dword [ebp+16]           ; Empilha a torre auxiliar
        push dword [ebp+20]           ; Empilha a torre de destino

        mov eax, [ebp+8]              ; Carrega o número de discos novamente
        dec eax                       ; Decrementa o número de discos
        push dword eax                ; Empilha o número de discos restantes

        call torre_de_hanoi                    ; Chama a função hanoi recursivamente
        add esp, 16                   ; Limpa a pilha após a chamada recursiva

    desempilhar:
        mov esp, ebp                  ; Restaura o ponteiro da pilha para o estado anterior
        pop ebp                       ; Restaura o valor de ebp
        ret                           ; Retorna da função hanoi
