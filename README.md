# PFL_TP1_G05_10

### Unidade Curricular: Programação Funcional e Lógica (PFL)

Para este projeto foi nos proposto a execução de um programa que consiga manipular simbólicamente polinómios.

Para corre-lo é necessário instalar as seguintes bibliotecas:

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

Para este projeto, decidimos escolher como representação interna de polinómios uma lista de túpulos. Um monómio representa um túpulo dessa lista.
O primeiro elemento do túpulo representa o coeficiente e o segundo elemento, uma lista de túpulos (a parte literal), que por sua vez, apresenta como primeiro elemento a variável e como segundo elemento o seu expoente.

```
type Mono = (Int, [(Char, Int)]) --(2, ['x',2]) = 2x^2
type Poly = [Mono] --lista de monómios
```

Exemplo:
![](https://i.imgur.com/WZ3Hov0.png)


### Justificação

Decidimos utilizar para representação do polinómio a lista de túpulos porque conseguimos nos pareceu a mais fácil lol



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
* Se algum monómio tiver algum literal repetido, i.e `2xx`, simplificamo-lo `2x^2`.

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


Para isso verificamos se:
* Algum dos monómios a multiplicar não tem parte literal -> Multiplicamos o coeficiente e mantemos a parte literal não nula, se forem ambos nula, a parte literal do monómio resultante é, também, nula;
* A parte literal de ambos for igual - > Multiplicamos os coeficientes e mantemos a parte literal de qualquer um deles incrementado o expoente;
* A parte literal de ambos for diferente -> Multiplicamos os coeficientes e os seus literais tendo o cuidado de incrementar o expoente quando a variável é igual.  


### Derivar um Polinómio

```
derPoly :: Poly -> Char -> Poly
```
Na função `derPoly` recebemos um polinómio e um char, que representa a ordem a que vamos derivar o polinómio e retornamos um polinómio.

Se encontrarmos na parte literal como variável o Char de input, multiplicamos o coeficiente com o expoente da parte literal e em seguida decrementamo-lo.

Aplicamos esta lógica a todos os monómios do polinómio.

### Output

```
printP:: Poly -> String

```
Nesta função retornamos o nosso output representado por uma String com auxilio da função `printListToString` que percorre o polinómio e o converte em string.

Nesta função, antes de a converter para string, chamamos a função `normalizePoly` mais uma vez para verificar se o polinómio resultante está simplificado e retornamo-lo.

### Input
```
sP :: String -> Poly
```
Como desafio, foi nos proposto a possibilidade de input como uma string tranformando-a na nossa representação interna.

Na função `sP` convertemos a String recebida em polinómio para podermos utilizar o polinómio resultante nas funções que o nosso programa oferece.

passos para chegar lá??? bruna


---

## Teste de Funcionalidades

Testámos as nossas funções com dois tipos de testes:

 * Testes de propriedade utilizando o QuickCheck;
 * Testes manuais para garantir que casos mais concretos seriam tratados.

Estes testes estão no ficheiro `Test.hs` e podem ser verificados carregando o ficheiro `:l Test.hs` e correndo a função `main`.

![](https://i.imgur.com/hPSDEtb.png)
*Fig.1: Testes*

![](https://i.imgur.com/lggvVEc.png)
*Fig.2: Testes de Propriedade usando QuickCheck*

foto
*Fig.3: Testes Especificos*

![](https://i.imgur.com/TgHazeL.png)
*Fig.4: Resultado dos Testes*



---

## Autoras:
| Nome                | Up       | Group
| --------            | -------- | -----
| Bruna Marques       | 202007191| G05_10
| Francisca Guimarães | 202004229| G05_10
