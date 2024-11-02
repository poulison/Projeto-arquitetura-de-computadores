# Projeto arquitetura de computadores - Jogo da memória em Assembly
**Integrantes:**
- Paulo Andre de Oliveira Hirata RA: 24.123.086-1
- Victor Merker Binda RA: 24.223.086-0

## Introdução e objetivos
  Nesse projeto faremos um pequeno jogo da memoria , onde usaremos uma array com uma sequencia pré definida , onde aparecerão no Display e o usuário terá que gravar e digitar no keypad a sequencia apresentada para ele, com o tempo a sequencia vai aumentando, faremos uma sequencia de 7 números , caso o jogador erre o jogo acaba e aparecera uma mensagem que ele errou e automaticamente o jogo reiniciara. Mas caso ele acerte tudo uma mensagem aparecera dizendo que ele venceu e o jogo terminará.


## Plataforma e ferramenta usada
Para o desenvolvimento desse projeto nós utilizamos o Assembly 8051 como linguagem e o edsim51 para programarmos.

## Funcionamento do Jogo

1.  O jogo exibe um número na tela, que o jogador deve memorizar.
2.  O jogador insere a sequência de números mostrados anteriormente usando o teclado (keypad).
3.  Com cada rodada, a sequência aumenta em 1 número, até um total de 7 números.
4.  **Condições de término do jogo**:
    -   **Vitória**: Se o jogador reproduzir corretamente a sequência completa.
    -   **Derrota**: Se o jogador errar qualquer número da sequência.
## Estrutura do Código

### Mapeamento de Hardware

-   **RS**: Controle de registros, conectado ao pino `P1.3` do microcontrolador.
-   **EN**: Enable para o LCD, conectado ao pino `P1.2`.

### Inicialização

O código começa com o endereço `org 0000h` e salta para `START`, onde são configurados registradores e variáveis.

### Display LCD

O display é inicializado com a rotina `lcd_init`, configurando-o em modo de 4 bits. Existem outras rotinas de controle do display, como:

-   `sendCharacter`: Envia caracteres para o LCD.
-   `clearDisplay`: Limpa o display.
-   `posicionaCursor`: Posiciona o cursor em uma linha/coluna específica do LCD.

### Sequência de Memória

-   **Vetor de Sequência**: Os valores a serem exibidos estão armazenados em posições de memória (30h, 31h, ..., 36h).
-   **Mostrando um Número**: A função `aparecerNumero` mostra cada número na sequência no display LCD.

### Entrada do Jogador (Teclado)

A rotina `leituraTeclado` escaneia o teclado em busca de teclas pressionadas. A função `colScan` verifica colunas para identificar a tecla correta.

### Condições de Vitória e Derrota

-   **Vitória**: A função `venceu` exibe uma mensagem de sucesso no LCD e reinicia o jogo.
-   **Derrota**: A função `derrota` exibe "ERROU" e também reinicia o jogo.

## Requisitos para jogar o jogo
- ter o edsim51 instalado.
- conhecimento básico da plataforma para execução do código.

### Passos para rodar:
-   Abra o EdSim51 e carregue o código.
-   Compile e execute o código para iniciar o jogo.
-   Utilize o keypad conforme as instruções exibidas no display para jogar.
