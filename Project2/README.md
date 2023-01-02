# Hadron - G10_04

## Membros do grupo 
| Nome                | Up       | Contribuição |
| --------            | -------- | ---          |
| Bruna Brasil Leão Marques | 202007191| 50%    |
| Francisca Horta Guimarães | 202004229| 50%    |

## Instalação e execução

Depois de abrir o programa SICStus Prolog:

`File` -> `Consult...` -> selecionar ficheiro `hadron.pl`

Na consola do SICStus: `play.`

## Descrição do jogo

Hadron é um jogo para dois jogadores. O tabuleiro é um quadrado em que os lados têm comprimento 5 (ou algum número ímpar maior) e inicialmente está vazio. Os jogadores revezam para jogar e a cada jogada, um jogador coloca uma peça sua num lugar do tabuleiro, sendo as peças do Player 1 identificadas pelo símbolo <kbd>x</kbd> e a peças do Player 2 pelo símbolo <kbd>Ø</kbd>. Para poder colocar uma peça numa determinada posição, é preciso que nas posições adjacentes, isto é, acima, em baixo, à esquerda e à direita, o número de peças de um jogador seja igual ao número de peças do adversário. O primeiro jogador incapaz de colocar a sua peça perde o jogo. Deste modo, o jogador anterior ganha o jogo e empates nunca acontecem.

## Lógica do jogo

### Representação interna do estado do jogo


O tabuleiro do jogo é representado por uma lista de listas. Cada lista representa uma linha e cada elemento dentro desta lista representa uma casa do tabuleiro. Cada casa pode estar vazia ou ocupada por uma peça de um dos jogadores:

- `0` indica que a casa está vazia;
- `1` indica que está ocupada por uma peça do jogador 1;
- `2` indica que está ocupada por uma peça do jogador 2.

```prolog
% piece(+Number, -Code)
% Codes for board pieces
piece(0, 32).   % space
piece(1, 215).  % × - Player 1
piece(2, 216).  % Ø - Player 2
```

**Possíveis estados de jogo:**

```prolog
Tabuleiro 5x5:

Inicial:
[[0, 0, 0, 0, 0], 
 [0, 0, 0, 0, 0], 
 [0, 0, 0, 0, 0], 
 [0, 0, 0, 0, 0], 
 [0, 0, 0, 0, 0]]
 
 Intermedio:
 [[0, 1, 0, 0, 1], 
  [1, 0, 0, 2, 0], 
  [0, 0, 0, 0, 0], 
  [0, 0, 0, 2, 0], 
  [0, 0, 2, 0, 0]]
 
 Final:
 [[0, 1, 0, 1, 1], 
  [1, 0, 0, 2, 0], 
  [0, 1, 0, 0, 2], 
  [1, 0, 0, 2, 0], 
  [0, 0, 2, 0, 2]]

```

Com o predicado `alternatePlayer/2`, definimos a vez do próximo jogador.

### Visualização do estado de jogo

Após o jogo ser inicializado, o jogador é confrontado com um menu inicial com as seguintes opções:

![](https://i.imgur.com/gakiLQk.png)

Para escolher uma opção basta escrever o número da opção desejada e primir a tecla "Enter" de seguida. 

As primeiras 3 opções correspondem aos três modos de jogo possíveis:

```
1 - Player vs Player
2 - Player vs Computer
3 - Computer vs Computer
```

Selecionando qualquer uma das opções, é apresentado ao utilizador um menu cujo objetivo é escolher o tamanho do tabuleiro a ser jogado. Consoante o tamanho do tabuleiro, mais tempo demorará o jogo a ser concluído.

![](https://i.imgur.com/04sdDmt.png)

* Para a primeira opção, após a escolha do tabuleiro, o jogo é inicializado e o `Player 1` é o primeiro fazer a sua jogada.
* Para a segunda opção, depois da escolha do tabuleiro, é dada a oportunidade ao jogador de escolher em que posição quer jogar, `Player 1` - começa primeiro - ou `Player 2`. De seguida é necessário escolher a dificuldade a ser atribuída ao seu oponente, o computador.
* Já para a terceira opção, após a escolha do tabuleiro, é apenas necessário atribuir a dificuldade aos dois jogadores, os computadores.

![](https://i.imgur.com/chXCk3A.png)

![](https://i.imgur.com/SLTI8pL.png)


Quanto à criação do tabuleiro é utilizada a função `initial_state/2` que devolve o estado de jogo inicial. 

Assim, quando o jogo começa é apresentado o tabuleiro (exemplo de um tabuleiro 5x5):

![](https://i.imgur.com/m69en2g.png)

Que pede ao utilizador como input a coluna, e de seguida linha, onde quer colocar a sua peça. Caso estejemos a jogar contra um computador aparcerá uma mensagem informando em que casa foi colocada a peça. 

Se o input for inválido, uma mensagem de erro é apresentada pedindo input novamente ao utilizador.

### Execução de Jogadas

As jogadas realizadas pelo utilizador são executadas por `move_human/6`, função que recebe input do utilizador verificando se esse input se traduz numa posição válida com a função `check_move/6` e colocando a peça no tabuleiro com a função `replace/6`. 

Já para as jogadas realizadas pelo computador, é utilizada a função `move_computer/6` que, conforme a dificuldade escolhida previamente pelo utilizador, escolhe um movimento válido colocando a peça no tabuleiro novamente com a função `replace/6`.

### Lista de Jogadas Válidas

Para determinar todas as posições em que é válido colocar uma peça, o predicado `valid_moves/2` chama o `findall` para percorrer cada posição do GameState e com o `check_position/3`, verifica se a posição é válida para colocar uma peça. Se for, é adicionada a ListOfMoves.

```prolog
% valid_moves(+GameState, -ListOfMoves)
% returns in ListOfMoves all possible moves for GameState
valid_moves(GameState, ListOfMoves):-
    findall(X-Y, check_position(GameState, X, Y), ListOfMoves).
```

No `check_position/3`, em primeiro lugar, é verificado se aquela posição se encontra vazia. De seguida, é chamado o predicado `can_place/4` que vai percorrer cada posição à volta da casa escolhida (em cima, em baixo, à esquerda e à direita) e altera um contador conforme o que estiver a ocupá-la. Desta forma, se a casa estiver vazia, o contador permanece igual, se encontrar uma peça do jogador 1, incrementa 1 ao contador e se encontrar uma peça do jogador 2, subtrai 1 ao contador. Por fim, verifica se o contador é igual a 0, isto é, uma posição válida a colocar uma peça. 

### Final do Jogo

Para determinar o fim do jogo, o predicado `game_over/1` chama o predicado `valid_moves/2` para obter a lista de posições em que é válido colocar uma peça e verifica se este tem comprimento 0. Isto é, se não há mais jogadas permitidas, é fim de jogo.

```prolog
% game_over(+GameState)
% checks if there is no valid moves left (game over)
game_over(GameState):-
  valid_moves(GameState, ListOfMoves),
  length(ListOfMoves, 0).
```
Como o jogo Hadron não permite empates, o último jogador a conseguir colocar a peça é o vencedor.

### Avaliação do Tabuleiro

Para o jogo Hadron não faz sentido haver uma avaliação contínua sobre o estado do jogo, uma vez que não existem pontos atribuidos às peças não havendo forma de saber quem está em vantagem a meio do jogo.

### Jogada do Computador

Sobre as jogadas do computador, existem dois níveis de dificuldade, `Level 1 (Random Strategy)` e `Level 2 (Greedy Strategy)`.

Nos dois casos, o predicado `choose_move_computer(+GameState, +Player, +Level, -Row, -Col)`, utiliza o `valid_moves/2` para obter a lista de movimentos válidos, mas de seguida abordam diferentes estratégias:
 
* Para o `Level 1`, é escolhida uma posição aleatória da lista de jogadas válidas com o auxílio do predicado `random/3`.

* Para o `Level 2`, procura-se a melhor jogada possível, isto é, a jogada em que ao colocar a peça, o jogador seguinte tenha o menor número de casas válidas para jogar. Para evitar que os jogos fossem sempre iguais (devido à estratégia greedy), optamos que a posição escolhida fosse aleatória entre as três melhores posições. No caso de não haver mais do que duas posições válidas, a melhor é selecionada.

### Conclusões

Numa primeira fase, sentimos dificuldade em perceber qual seria a melhor forma para efetuar o loop principal do nosso jogo. Conseguimos encontrar uma solução favorável mas achamos que não será a mais eficiente.
De seguida, a verificação das posições à volta da casa escolhida também foi um desafio. Por último, a construção das estratégias implementadas para os computadores, especialmente a estratégia greedy, tornou-se um contratempo para o desenvolvimento do resto do jogo.
Assim, consideramos que estamos satisfeitas com o resultado final apesar de que a eficiência podia estar melhor numa certa parte do codigo.


