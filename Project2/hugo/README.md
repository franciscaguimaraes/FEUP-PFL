# Turma 10 - Hadron_2

## Intervenientes
- [Hugo Miguel Fernandes Gomes](up202004343@fe.up.pt) - up202004343
- [João Pedro Carvalho Moreira](up202005035@fe.up.pt) - up202005035

## Instalação e Execução
### Windows
- Executar `spwin.exe`
- `File` -> `Consult...` -> Selecionar ficheiro `hadron.pl`
- Na consola do SicStus: `play.`
### Linux
- Executar `SicStus Prolog`
- `File` -> `Consult...` -> Selecionar ficheiro `hadron.pl`
- Na consola do SicStus: `play.`
## Hadron - Descrição do Jogo

O objetivo do jogo é ser o último jogador a colocar uma peça no tabuleiro. Se nenhuma jogada estiver disponível no teu turno, tu perdes.

Hadron é um jogo de 2 jogadores jogado num tabuleiro 5x5 (ou num tabuleiro de maior dimensão desde que tenha de lado um tamanho ímpar). Os dois jogadores, Vermelho e Azul (no nosso caso, 'O' e 'X'), jogam de forma alternada, colocando uma peça no tabuleiro, começando pelo jogador **vermelho**. Se uma jogada estiver disponível, o jogador é obrigado a jogar, não sendo possível passar a sua vez. Empates não podem acontecer.
O critério para se poder colocar uma peça numa determinada casa é ter um número igual de peças adversárias e peças suas nas casas adjacentes na vertical e horizontal.

O jogo acaba quando não existem mais jogadas disponíveis, sendo o último jogador a colocar uma peça o vencedor.

## Lógica do Jogo
### Representação Interna do Estado de Jogo
#### Tabuleiro
O tabuleiro é representado a partir de array bidimensional (lista de sublistas), sendo cada sublista uma linha do tabuleiro. Cada elemento, durante o jogo, pode ter 1 de 3 valores possiveis:
- `0` representa uma posição vazia
- `1` representa uma posição com uma peça pertencente ao jogador 1 
- `-1` representa uma posição com uma peça pertencente ao jogador 2 

```prolog
Possiveis estados de jogo:

- Inicial:
[ [ 0, 0, 0, 0, 0],
  [ 0, 0, 0, 0, 0],
  [ 0, 0, 0, 0, 0],
  [ 0, 0, 0, 0, 0],
  [ 0, 0, 0, 0, 0] ]


- Intermedio:
[ [ 0, 0, 0, 1, 0],
  [ 0, 1, 0, 0, 0],
  [ 0, 0, 0, 0, -1],
  [ 0, 0, -1, 0, 0],
  [ 1, 0, 0, 0, 0] ]

- Final:
[ [ 1, 0, 0, 1, 0],
  [ 0, 1, 0, 0, 0],
  [-1,-1, 0, 0,-1],
  [ 1, 0,-1, 0, 0],
  [ 1, 0, 0,-1, 0] ]

```

#### Player
O player tem dois estados possíveis, ambos strings: `Human` e `Bot`.
Estas strings são associadas ao player 1 ou player 2 consoante a decisão do jogador através do predicado `player/2`.
```prolog
player(1, 'Human').
player(-1, 'Bot').
```
Na representação gráfica do tabuleiro, as peças do `Player 1` são `O` e as peças do `Player 2` são `X`. Esta associação é feita a partir do predicado `player_char/2`, que associa um valor de uma peça do tabuleiro a um código ASCII, usado com `put_code` para realizar a representação gráfica no terminal:
```prolog
player_char(0,32). % Empty tale
player_char(1,79). % player1 'O'
player_char(-1,88). % player2 'X'
```

#### Playing 
Neste estado final do projeto existem 2 opções para quem está a jogar:
- `Player` - Para quando for a vez de um jogador humano a decidir uma jogada
- `Bot` - Para quando for a vez do Computador de fazer uma jogada

A cada Computador está ainda associada uma de 2 dificuldades disponíveis:
-  `Easy` - Jogada aleatória por parte do computador
- `Greedy` - Jogada de forma a minimizar o número de jogadas do jogador a seguir

Além disso, ainda temos o predicado `turn/1` que define quem é o próximo jogador a jogar.

- `1` - player 1 é o próximo jogador
- `-1`- player 2 é o próximo jogador 
  
Todos estes valores são obtidos a partir das escolhas selecionadas nos menus.

### Visualização do Estado do Jogo

Após iniciar o jogo com o predicado `play.` o jogador tem ao seu dispor um menu inicial com as opções principais do jogo:

![main menu](./README_files/main_menu.png)

Para realizar a escolha de uma opção o jogador apenas escreve o número relativo à opção que quer e prime `Enter`. Estando em qualquer ecrã de menu e escolhendo a opção `0`, o ecrã é limpo e o menu principal é exibido.

A opção `4 - Game Instructions` contem apenas texto sobre as regras e informações sobre o jogo.

As primeiras 3 opções correspondem a tipos de jogo disponíveis:
```
1 - Player vs Player
2 - Player vs Computer
3 - Computer vs Computer
```
Após selecionar qualquer uma destas é apresentado um ecrã para escolher o tamanho do tabuleiro, tendo 3 tamanhos para escolha. Por norma, quanto maior for o tabuleiro, mais tempo demorará o jogo.

Para a primeira opção, após selecionar o tamanho do tabuleiro, o jogo inicia, sendo a vez do `Player 1` a jogar.

Para a segunda opção, para além do tamanho do tabuleiro,  é também necessário escolher a **dificuldade** do computador, juntamente com qual `Player` é que o jogador quer ser, tendo as opções de ser o `Player 1` ou o `Player 2`.

Para a terceira opção, para além do tamanho do tabuleiro, é possível escolher as dificuldades de ambos os computadores.

No que toca à criação do tabuleiro, este é criado de forma dinâmica, sendo logo guardado na base de dados e , devido a isto, a função `initial_state/2` não devolve o estado de jogo inicial. Optou-se por não permitir tabuleiros superiores a 9x9 devido ao tempo que a solução greedy levaria a calcular a melhor jogada.

Assim que um jogo é iniciado é apresentado o tabuleiro (neste caso, um tabuleiro 5x5):
```
   | 0 | 1 | 2 | 3 | 4 |
---+---+---+---+---+---|
 A |   |   |   |   |   | 
---| - + - + - + - + - |
 B |   |   |   |   |   | 
---| - + - + - + - + - |
 C |   |   |   |   |   | 
---| - + - + - + - + - |
 D |   |   |   |   |   | 
---| - + - + - + - + - |
 E |   |   |   |   |   | 
---| - + - + - + - + - |
```

E, dependendo se é a vez do jogador ou do computador, apresenta um mensagem a pedir input (Coluna e depois Linha) ou um diálogo com o jogada que o computador efetuará. No caso de pedir um input ao jogador, caso o input não seja válido, é apresentada uma mensagem de erro e é pedido o input outra vez.


### Execução de jogadas

Para se realizar uma jogada é preciso respeitar duas condições: 

Em primeiro lugar é verificado se a coluna e linha inserida está dentro dos limites do tabuleiro. 

Em segundo lugar, para validar a jogada, é utilizado o predicado `move/4` que recebe o tabuleiro atual, o próximo jogador e o tipo do mesmo e devolve o novo tabuleiro atualizado. A validação da jogada é feita com o predicado `check_move/3` que verifica se o número de peças adversárias e do jogador é o mesmo nas casas adjacentes e se a casa selecionada está vazia, pois, caso contrário, não é uma casa válida.

Depois de se terem verificado as condições previamente apresentadas, é invocado o predicado `change_element/5` que devolve um novo tabuleiro já atualizado com a nova peça na respetiva casa.

### Lista de Jogadas Válidas

Uma jogada é constituida por 2 componentes: uma coluna e uma linha. A posição no tabuleiro é composta por um valor correspondente a uma coluna (Inteiro) e um valor correspondente a uma linha (Caráter). 

O predicado `valid_moves(+GameState, -ListOfMoves)` usa o predicado `check_move(+Col, +Row, +Board)` para verificar, posição a posição, começando na posição (0,0) do tabuleiro (canto superior esquerdo), até á posição (`Size-1`, `Size-1`) do tabuleiro (Canto inferior direito), sendo `Size` o número de linhas e colunas do tabuleiro, se aquela casa respeita as condições para se colocar lá uma peça. Além disso, optou-se por não passar ao predicado `valid_moves` o próximo jogador, visto que as próximas jogadas válidas são independentes do turno do jogador.

### Final do Jogo

Visto que o Hadron não permite empates, o predicado para determinar se o jogo acabou é bastante simples. Para tal, basta invocar o predicado `game_over/1` que chama o predicado `valid_moves/2`. Desta forma, basta verificar o tamanho da lista devolvida com todas as jogadas possíveis. Se o tamanho da lista for 0, significa que o jogo acabou e que não há mais nenhuma jogada disponível para nenhum dos jogadores, sendo o último jogador a colocar uma peça o vencedor. Caso o tamanho da lista não seja 0, significa que ainda há jogadas disponíveis por isso o loop do jogo continua.
```prolog
% game_over(+GameState)
% predicate that checks if the game is over
game_over(GameState) :-
	valid_moves(GameState, AvailableMoves),
	length(AvailableMoves, X),
	X == 0.
```

### Avaliação do Tabuleiro
---------------------
POR FAZERRRRRRRRR
----------------


### Jogada do Computador

Neste Projeto criamos 2 dificuldades possíveis para o Computador: `Easy` e `Normal`.

Se a dificuldade for `Easy`, então o Computador, com o auxílio do predicado `valid_moves/2`, tem à sua disposição uma lista de movimentos possiveis de executar e escolherá, aleatoriamente, um destes movimentos da lista, usando o predicado `random/3` da biblioteca `random`, que recebe um intervalo [Lower, Upper] e devolve um inteiro neste intervalo que corresponde ao index da jogada selecionada. 

Se a dificuldade for `Normal (Greedy)`, após obter a lista dos movimentos possíveis, é usado o predicado `number_moves_opponent(+AvailableMoves, +GameState, +PlayerTurn, -Solution)` para gerar uma lista de de listas de elementos na forma `[Size, Col, Row]`:
- `Size` - número de jogadas disponíveis para o próximo jogador
- `Col` - Coluna escolhida
- `Row` - Linha escolhida

A lista resultante está ordenada pelo `Size` de forma crescente, sendo assim preciso efetuar um `samsort(Solution, OrderedSolution)` para que a Lista fique ordenada por ordem crescente de `Size`. Assim, apenas é necessário retirar o elemento no Index 0 que corresponde à solução ótima e atualizar o tabuleiro.

## Conclusões
Uma das dificuldades apresentadas no inicio do trabalho consistiu na forma como seria implementado a jogada greedy por parte do computador. Visto que não há casas mais importantes que outras e que não há pontos associados a cada jogada, foi complicado perceber como implementar um critério que fizesse sentido para distinguir os tipos de jogada. Isto poderia ter sido melhorado se todos os jogos apresentados, embora diferentes, apresentassem todos a mesma filosofia. Além desta, a outra principal dificuldade consistiu em como voltar a pedir os inputs ao utilizador no caso em que estes excediam os limites do tabuleiro, pois, devido ao backtracking de prolog, estes entravam em recursão infinita.
Por fim, uma possível melhoria seria os alunos terem acesso aos critérios de avaliação para melhor perceber quais são as partes mais importantes do trabalho e, consequentemente, dedicarem mais esforço e tempo às mesmas.


## Bibliografia
- [Documentação SicStus 4.7.1](https://sicstus.sics.se/sicstus/docs/latest4/html/sicstus.html/index.html)
- [Board Game Geek - Hadron Official Rules](https://boardgamegeek.com/filepage/244502/official-rules)
