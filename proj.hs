module Proj
  ( removeExpNull, {--removeCoefNull,--} isMemberOf, calcLiterals, expressionCleanUp, addMono, addSameMono, normalizePoly, addPoly ,mulMono, mulOnlyCoef, mulExpression, mulPoly, mylookup, derMono, derPoly, printNormalize, printAdd, printMultiply, printDerivative
  ) where

import Data.List
import Data.List.Split
type Mono = (Int, [(Char, Int)])
type Poly = [Mono]

{- ex: 2xy + 7 -> [(2, [(x, 1), (y,1)]), (7, [])]-}
-- [ (0 , [('x',2)] ) , (2, [('y',1)]) , (5, [('z', 1)]) , (1 , [('y',1)]) , (7 , [('y',2)]) ] -> (0x^2 + 2*y + 5*z , y, -7y^2)

----------------------------------------------------------------------------------------------
-- BASE FUNCTIONS TO REMOVE coeficientE NULL AND EXPOENTE NULL

removeExpNull :: (Num b, Eq b) => [(a, b)] -> [(a, b)]
removeExpNull [] = []
removeExpNull ((x,y):xs)
    | y == 0 = removeExpNull xs
    | otherwise = (x,y): removeExpNull xs

 -- REMOVES ALL MONO WHO HAVE 0 IN COEF AND CALLS EXP NULL TO SEE IF THEY ARE OK
--removeCoefNull :: Mono -> Mono
--removeCoefNull m  = []
--removeCoefNull m
-- | otherwise = ( fst m , removeExpNull (snd m) )

isMemberOf :: (Eq a)  => a -> [(a,b)] -> Bool
isMemberOf y [] = False
isMemberOf y (x:xs) = if y == fst x then True else isMemberOf y xs

calcLiterals :: (Eq a, Num b, Eq b) => [(a,b)] -> [(a,b)] -> [(a,b)]
calcLiterals m1 [] = m1
calcLiterals [] m2 = m2
calcLiterals m1 m2 = lista ++ [ (h,i) | (h,i) <- m1, isMemberOf h lista == False ] ++ [ (j,k) | (j,k) <- m2, isMemberOf j lista == False ]
  where lista = [ (a, b+d) | (a,b) <- m1, (c,d) <- m2, a == c ]

-- sorts literals alphabetically
expressionCleanUp :: Poly -> Poly
expressionCleanUp [] = []
expressionCleanUp p
  -- if finds 0 as coef, ignores it and moves on
 | fst (head p) == 0 && length p > 1 = [] ++ expressionCleanUp (tail p)
 -- if finds 0 as coef and is last element ignores it
 | fst (head p) == 0 && length p == 1 = []
 -- if mono has literals, sorts them and removes expnull
 | snd (head p) /= [] = [(fst (head p), removeExpNull ( sort ( calcLiterals ( take 1 (snd (head p)) ) (tail (snd (head p)) ) ) )  )]  ++ expressionCleanUp (tail p)
 -- if only has 1 coef, keeps it
 | otherwise = [(fst (head p), [] )] ++ expressionCleanUp (tail p)


----------------------------------------------------------------------------------------------

-- ADDS MONO AND KEEPS SAME LITERAL
addMono :: Mono -> Mono -> Mono
addMono m1 m2 = (fst m1 + fst m2, snd m1)

-- ADDS MONO USING ABOVE FUNC, THIS FUNCTION ADDS MONOS WITH SAME LITERAL EXPRESSION
addSameMono :: Mono -> Poly -> Poly
addSameMono m [] = [m]
addSameMono m (x:xs)
    | snd m == snd x = addMono m x:xs
    | otherwise = x:addSameMono m xs

----------------------------------------------------------------------------------------

-- THIS FUNCTION NORMALIZES POLY USING ABOVE FUNC OF ONLY ADDING IF SAME. CLEANING NULL COEFS AND NULL EXPON

normalizePoly :: Poly -> Poly
normalizePoly p
 | p == [] = []
 | otherwise = auxFunc ( expressionCleanUp p )
 where auxFunc p
        | p == [] = []
        | otherwise = addSameMono (head p) (auxFunc (tail p))

----------------------------------------------------------------------------------------

-- THIS FUNCTION ADDS POLYS BY CONCAT TWO INTO ONE AND THEN NORMALIZING IT, ADDING SAME EXPRESSIONS, AS EXPECTED
addPoly :: Poly -> Poly -> Poly
addPoly p1 p2
 | p1 == [] = p2
 | p2 == [] = p1
 | otherwise = normalizePoly ( p1 ++ p2)

---------------------------------------------------------------------------------------

-- multiplies same MONO literal AND increases literal (2, [('x',2), ('y',1)]) (2, [('x',2) ,('y',1)])
-- fst (head m1aux) -> literal aka x,y,z,.. ; snd (head m1aux) -> expoente aka 1,2,3,...
mulMono :: Mono -> Mono -> Mono
mulMono m1 m2 = (fst m1 * fst m2 , auxRec(snd m1))
  where auxRec m1aux
         | length m1aux == 1 = [( fst (head m1aux), snd (head m1aux) * 2)]
         | otherwise = [(fst (head m1aux), snd (head m1aux) * 2)] ++ auxRec (tail m1aux)

-- if multy with an only coef, multiply both coefs and leave non null literal
mulOnlyCoef :: Mono -> Mono -> Mono
mulOnlyCoef m1 m2 = (fst m1 * fst m2 , var) where var = if (snd m1 /= []) then snd m1 else snd m2

mulExpression :: Mono -> Poly-> Poly
mulExpression m [] = []
mulExpression m (x:xs)
    -- if only coef is multiplying
    | (snd m == [] || snd x == [])= [mulOnlyCoef m x] ++ mulExpression m xs
    -- if same literals
    | (snd m == snd x)  = [mulMono m x] ++ mulExpression m xs
    -- if diferent literals, use calcLiterals
    | snd m /= snd x = [(fst m * fst x, calcLiterals (snd m) (snd x) )] ++ mulExpression m xs
    | otherwise = x:mulExpression m xs

mulPoly :: Poly -> Poly -> Poly
mulPoly p1 p2
 | p1 == [] = []
 | p2 == [] = []
 | otherwise =  mulExpression (head p1) p2 ++ mulPoly (tail p1) p2

-- mulPoly [ (2, [('y',1)]), (5, [('z', 1)]) ]  [ (1 , [('y',1)]) ]

---------------------------------------------------------------------------------------

mylookup :: (Eq a, Num b, Ord b) => a -> [(a,b)] -> [(a,b)]
mylookup _ [] =  []
mylookup c ((x,y) : xys)
  -- only 1 to go and not the char we are looking for...
  | (length ((x,y) : xys) == 1 && c /= x) = []
  -- don't care if exp == 1 and turns into 0 bc normalize covers those cases
  | c == x  =  (( x, (y-1)) : mylookup c xys)
  | otherwise =  mylookup c xys

derMono :: Mono -> Char -> Mono
derMono m c
 -- if dont find... normalizes covers those cases
 | mylookup c (snd m) == [] = (0, [])
 | otherwise = (fst m * expoente , mylookup c (sort(snd m)))
                      where expoente = (snd (head (mylookup c (snd m))) ) + 1

derPoly :: Poly -> Char -> Poly
derPoly poly c = map (\mono -> derMono mono c) poly

--------------------------------------------------------------------------------------------
-- LIST TO STRING PRINT FUNCTIONS
printListToString :: Poly -> String
printListToString p
 | fst (head p) == 0 && length p /= 1 = printListToString (drop 1 p)
 | fst (head p) == 0 && length p == 1 = ""
 | length p == 1  && snd (head p) /= [] = show(fst (head p) ) ++ printLiteralsToString(snd (head p))
 | snd (head p) == [] && (length p == 1) = show(fst (head p))
 | snd (head p) == [] && (length p /= 1) = show(fst (head p)) ++ " " ++ "+" ++ " " ++ printListToString (drop 1 p)
 | otherwise = show(fst (head p) ) ++ printLiteralsToString(snd (head p)) ++ " " ++ "+" ++ " " ++ printListToString (drop 1 p)


-- PRINT LITERALS FUNCTIONS
printLiteralsToString :: (Eq b, Num b,  Show b) => [(Char, b)] -> String
printLiteralsToString m
 | (length m == 1 && snd (head m) /= 1) = [fst (head (m))] ++ "^" ++ show (snd (head m) )
 | length m == 1 && snd (head m) == 1 = [fst (head (m))]
 | snd (head m) == 1 = [fst (head m)]  ++ printLiteralsToString (drop 1 m)
 | otherwise = [fst (head m)] ++ "^" ++ show(snd(head m)) ++ printLiteralsToString (drop 1 m)

----------------------------------------------------------------------------------
-- CALLING FUNCTIONS

-- print printNormalize
printNormalize :: Poly -> String
printNormalize p = printListToString (normalizePoly p)

-- print printAdd
printAdd :: Poly -> Poly -> String
printAdd p1 p2 = printListToString (normalizePoly (addPoly (p1) (p2) ) )

printMultiply :: Poly -> Poly -> String
printMultiply p1 p2 = printListToString (normalizePoly (mulPoly (normalizePoly(p1)) (normalizePoly (p2)) ) )

-- printDerivative PRINT FUNCTION
printDerivative :: Poly -> Char -> String
printDerivative p c = printListToString  ( normalizePoly (derPoly (normalizePoly (p)) c ))


------------------------

--converter a parte literal para o formato de lista
stringToLiterals :: String -> [(Char, Int)]
stringToLiterals [] = []
stringToLiterals (x:xs)
  | x > '9' && xs == [] = [(x,1)]
  | x > '9' && (head xs) == '^' = [(x, read (takeWhile (<= '9') (drop 1 xs)) :: Int)] ++ stringToLiterals (dropWhile (<= '9') (drop 1 xs))
  | x > '9' && ((head xs) > '9') = [(x,1)] ++ stringToLiterals xs

-- conveter um mono em string para o formato Mono
stringToMono :: String -> Mono
stringToMono l = (read (takeWhile (<= '9') l) :: Int, stringToLiterals (dropWhile (<= '9') l))

--limpar a lista de monomios para tirar os +, - e vazios
listOfPoly :: [String] -> [String]
listOfPoly x
  | x == [] = []
  | head x == "" = listOfPoly (drop 1 x)
  | head x == "+" = listOfPoly (drop 1 x)
  | head x == "-" = ["-" ++ head (tail x)] ++ listOfPoly (drop 1 (tail x))
  | otherwise = [head x] ++ listOfPoly (tail x)

--recebendo uma lista resultante de words
splitOperators :: [String] -> [String]
splitOperators (x:xs)
  | length (x:xs) == 1 = split (oneOf "-+") x
  | otherwise = split (oneOf "-+") x ++ splitOperators xs


process :: Int -> IO ()
process opt
  | opt == 1 = putStrLn $ "aaaaaa"

menu :: IO ()
menu = do
  putStrLn $ "MENU"
  putStrLn $ "1 to normalize polynomial"
  putStrLn $ "2 to add polynomials"
  putStrLn $ "3 to multiply polynomials"
  putStrLn $ "4 to calcular derivada de polinomio"
  input <- getLine
  let option = read input :: Int
  if (option > 4 || option < 1) then
    menu
  else
