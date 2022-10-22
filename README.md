# PFL_TP1_G10_05

### Unidade Curricular: Programação Funcional e Lógica (PFL)

Neste projeto foi nos proposto a execução de um programa que consiga manipular simbolicamente polinómios.

Para corrê-lo é anecessário instalar as seguintes bibliotecas:

```
* QuickCheck
    > cabal install QuickCheck
```
```
* Data.List.Split
    > cabal install missingh
    > cabal install split
```

---

## Representação Interna de Polinómios

### Estrutura

Para este projeto, decidimos escolher como representação interna de polinómios uma lista de tuplos. Um monómio representa um tuplo dessa lista.
O primeiro elemento do tuplo representa o coeficiente e o segundo elemento, uma lista de tuplos (a parte literal), que por sua vez, apresenta como primeiro elemento a variável e como segundo elemento o seu expoente.


```
type Mono = (Int, [(Char, Int)]) --(2, ['x',2]) = 2x^2
type Poly = [Mono] --lista de monómios
```

Exemplo:
![](https://i.imgur.com/WZ3Hov0.png)

*Fig.1: Exemplo de Estrutura Interna de um Monómio*


### Justificação

A estrutura que escolhemos para a representação interna de polinómios foi uma das sugeridas pelo professor durante uma aula teórica. 

Foi a estrutura que nos pareceu mais organizada e intuitiva, o que nos permitiu iniciar o desenvolvimento do projeto sem grandes dificuldades visto termos constatado ser relativamente simples a manipulação de polinómios utilizando esta estratégia. 

---

## Implementação

As seguintes funcionalidades representam funções no nosso programa que executam os objetivos descritos para este projeto.

### Normalizar um Polinómio

```
normalizePoly :: Poly -> Poly
```
Na função `normalizePoly` recebemos um polinómio e retornamos um polinómio.

Primeiro, verificamos se o polinómio tem as condições necessárias para ser normalizado.

* Retiramos todos os monómios que contenham como coeficiente o 0;
* Se algum dos literais tiver como expoente o 0, removemos esse literal do monómio;
* Se algum monómio tiver algum literal repetido, i.e. `2xx`, simplificamo-lo `2x^2`.

De seguida, percorremos o polinómio e verificamos se encontramos monómios com a mesma parte literal. Se sim, adicionamos os seus coeficientes e retornamos o monómio, e, por sua vez, o polinómio simplificado.


### Adicionar Polinómios

```
addPoly :: Poly -> Poly -> Poly
```
Na função `addPoly` recebemos dois polinómios e retornamos um polinómio.

Nesta função apenas concatenamos os dois polinómios recebidos e, com a ajuda do `normalizePoly`, retornamos um polinómio com o resultado da normalização.

### Multiplicar Polinómios

```
mulPoly :: Poly -> Poly -> Poly
```
Na função `mulPoly` recebemos dois polinómios e retornamos um polinómio.

Analisamos este problema por partes. Para multiplicarmos os polinómios de forma distributiva, analisamos primeiro a multiplicação do primeiro monómio do primeiro polinómio (p1) com o segundo polinómio (p2), em seguida, a multiplicação do segundo monómio de p1 com p2, e por aí em diante.

![](https://i.imgur.com/bbePtoF.png)

*Fig.2: Exemplificação da Propriedade Distributiva na Multiplicação de Polinómios*


Para isso verificamos se:
* Algum dos monómios a multiplicar não tem parte literal -> Multiplicamos o coeficiente e mantemos a parte literal não nula, se forem ambos nula, a parte literal do monómio resultante é, também, nula;
* A parte literal de ambos for igual - > Multiplicamos os coeficientes e mantemos a parte literal de qualquer um deles incrementado o expoente;
* A parte literal de ambos for diferente -> Multiplicamos os coeficientes e os seus literais tendo o cuidado de incrementar o expoente quando a variável é igual.  


### Derivar um Polinómio

```
derPoly :: Poly -> Char -> Poly
```
Na função `derPoly` recebemos um polinómio e um char, que representa a ordem a que vamos derivar o polinómio, e retornamos um polinómio.

Começamos por percorrer os monómios do polinómio (`mylookup`) com o objetivo de encontrar na parte literal do monómio a variável cuja ordem queremos derivar (fornecida pelo utilizador).
Se encontrarmos a variável, decrementamos o seu expoente, obtendo no final uma lista da parte literal com os expoentes das variáveis decrementados de forma correta.
Por último, percorremos a lista resultante (`myexponent`) e multiplicamos o coeficiente com o expoente associado a essa variável incrementado novamente (para conseguirmos obter o expoente na sua forma original).

Esta lógica é aplicada a todos os monómios do polinómio obtendo como resultado um polinómio derivado.

### Input
```
sP :: String -> Poly
```
Como desafio, foi nos proposto a possibilidade de input como uma String transformando-a na nossa representação interna.

Na função `sP` convertemos a String recebida em polinómio para podermos utilizar o polinómio resultante nas funções que o nosso programa oferece.

Primeiro, a string original do polinómio é separada pelos espaços (através da função `words`) e pelos operadores `+` e `-` (através da função criada `splitOperators`) e assim, é convertida em uma lista de String.
De seguida, a função `listOfPoly` percorre a nova lista retirando os espaços vazios e o operador `+`, e concatenando o operador `-` com o respetivo monómio.
Por último, chama-se `stringToMono` para cada elemento da lista para converter em monómio. Esta função separa o coeficiente da parte literal. A parte literal é convertida para o formato `[(Char, Int)]` pela função `stringToLiterals`.

No fim, obtém-se uma lista de monómios, isto é, um polinómio, para fazer a operação pedida pelo utilizador.

### MENU

```
menu :: IO ()
```

Para auxiliar o utilizador, foi criado um menu de instruções para esclarecer como realizar as operações base de normalização, adição, multiplicação e derivação.

![](https://i.imgur.com/m6lMSs2.png)
*Fig.3: Exemplo de como receber instruções para normalização*

### Output
```
printP:: Poly -> String
printNormalize :: String -> String
printAdd :: String -> String -> String
printMultiply :: String -> String -> String
printDerivative :: String -> Char -> String
```
Nas funções descritas em cima retornamos o nosso output representado por uma String com auxilio da função `printListToString` que percorre o polinómio e o converte em string. 

Para imprimirmos o polinómio dado tivemos em atenção alguns aspetos:

* Se for um monómio cujo coeficiente é 0, não o imprimimos;
* Se for um monómio cuja parte literal é nula, só imprimimos o coeficiente;
* Se se trata de um monómio com coeficiente e parte literal não nula, imprimimos o coeficiente e de seguida a parte literal com auxílio de `printLiteralsToString` que, por sua vez, tem em consideração o valor do expoente da variável e apenas o imprime se for superior a 1.

Para além do mencionado, antes de converter o polinómio para string, chamamos novamente a função `normalizePoly` para verificar se o polinómio resultante se encontra o mais simplificado possível.


---

## Teste de Funcionalidades

Testámos as nossas funções com dois tipos de testes:

 * Testes de propriedade utilizando o QuickCheck;
 * Testes manuais para garantir que casos mais concretos seriam tratados.

Estes testes estão no ficheiro `Test.hs` e podem ser verificados carregando o ficheiro `:l Test.hs` e correndo a função `main`.

![](https://i.imgur.com/fhkrTBq.png)
*Fig.4: Testes*

![](https://i.imgur.com/lggvVEc.png)
*Fig.5: Testes de Propriedade usando QuickCheck*

![](https://i.imgur.com/8kf9IKW.png)
*Fig.6: Alguns dos Testes Específicos Implementados*

![](https://i.imgur.com/TgHazeL.png)

*Fig.7: Resultado dos Testes*



---

## Autoras:
| Nome                | Up       | Grupo
| --------            | -------- | -----
| Bruna Marques       | 202007191| G10_05
| Francisca Guimarães | 202004229| G10_05
