module Proj
  ( removeExpNull, isMemberOf, calcMultiplyLiterals, expressionCleanUp, addMono, addSameMono, normalizePoly, addPoly ,mulMono, mulOnlyCoef, mulExpression, mulPoly, mylookup, derMono, derPoly, printNormalize, printAdd, printMultiply, printDerivative
  ) where

import Data.List
import Data.List.Split
type Mono = (Int, [(Char, Int)])
type Poly = [Mono]


-- ============================================================================
-- BASE FUNCTIONS TO CLEAN UP POLYNOMIAL EXPRESSION

-- This function removes literal from monomial if literal has exponent equal to 0
removeExpNull :: (Num b, Eq b) => [(a, b)] -> [(a, b)]
removeExpNull [] = []
removeExpNull ((x,y):xs)
    | y == 0 = removeExpNull xs
    | otherwise = (x,y): removeExpNull xs

-- This function adds exponent if monomial has two or more same literals
addExp :: (Num b) => [(a,b)] -> b
addExp [] = 0
addExp m
 | length m == 1 = snd (head m)
 | otherwise = snd (head m) + addExp (tail m)

-- This function finds in the same monomial equal literals and adds their exponent
calcMonoLiterals :: (Eq a, Num b, Eq b) =>[(a,b)] -> [(a,b)]
calcMonoLiterals [] = []
calcMonoLiterals m = [ (fst(head m) , addExp (filter (\x -> (fst (head m)) == (fst x)) m))] ++ calcMonoLiterals (filter (\x -> (fst (head m)) /= (fst x)) m)

-- this function cleans polynomial expression by removing null coeficients, exponents and literal duplicates
expressionCleanUp :: Poly -> Poly
expressionCleanUp [] = []
expressionCleanUp p
  -- if finds 0 as coef, ignores it and moves on
 | fst (head p) == 0 && length p > 1 = [] ++ expressionCleanUp (tail p)
 -- if finds 0 as coef and is last element ignores it
 | fst (head p) == 0 && length p == 1 = []
 -- if mono has literals, sorts them and removes expnull
 | snd (head p) /= [] = [(fst (head p), removeExpNull ( sort ( calcMonoLiterals ( snd (head p) ))) )]  ++ expressionCleanUp (tail p)
 -- if only has 1 coef, keeps it
 | otherwise = [(fst (head p), [] )] ++ expressionCleanUp (tail p)

-- ============================================================================
-- AUXILIAR FUNCTIONS TO ADDITION AND NORMALIZATION OF POLYNOMIALS

-- This functions adds coeficients and keeps their literal part (used to add monomials with same literals)
addMono :: Mono -> Mono -> Mono
addMono m1 m2 = (fst m1 + fst m2, snd m1)

-- This function adds monomials with same literal part returning the polynomial expression with same monomials added
addSameMono :: Mono -> Poly -> Poly
addSameMono m [] = [m]
addSameMono m (x:xs)
    | snd m == snd x = addMono m x:xs
    | otherwise = x:addSameMono m xs

-- ============================================================================
-- FUNCTION TO NORMALIZE POLYNOMIAL EXPRESSION

-- This function takes a polynomial expression, removes unnecessary parts and adds same monomials
normalizePoly :: Poly -> Poly
normalizePoly p
 | p == [] = []
 | otherwise = auxFunc ( expressionCleanUp p )
 where auxFunc p
        | p == [] = []
        | otherwise = addSameMono (head p) (auxFunc (tail p))

-- ============================================================================
-- FUNCTION TO ADD TWO POLYNOMIAL EXPRESSIONS

-- This function takes two polynomials and adds them by concatenating them and normalizing the resultant expression
addPoly :: Poly -> Poly -> Poly
addPoly p1 p2
-- if one of poly is 0 keep other poly
 | p1 == [(0,[])] = p2
 | p2 == [(0,[])] = p1
 -- if one of poly is null, keep other poly
 | p1 == [] = p2
 | p2 == [] = p1
 | otherwise = normalizePoly ( p1 ++ p2)

-- ============================================================================
-- FUNCTION AND AUXILIARY FUNCTIONS TO MULTIPLY TWO POLYNOMIAL EXPRESSIONS

-- This function takes two monomials with same literal parts and multiplies their coeficients and doubles their exponent
mulMono :: Mono -> Mono -> Mono
mulMono m1 m2 = (fst m1 * fst m2 , auxRec(snd m1))
  where auxRec m1aux
         | length m1aux == 1 = [( fst (head m1aux), snd (head m1aux) * 2)]
         | otherwise = [(fst (head m1aux), snd (head m1aux) * 2)] ++ auxRec (tail m1aux)

-- This function takes two monomials (one monomial with no literal part) and multiplies their coeficient and keeps either non-null literal or null literal part (ex: 2 * 2x = 4x || 2 * 2 = 4)
mulOnlyCoef :: Mono -> Mono -> Mono
mulOnlyCoef m1 m2 = (fst m1 * fst m2 , var) where var = if (snd m1 /= []) then snd m1 else snd m2

-- This function returns true if char value is member of list of literals
isMemberOf :: (Eq a)  => a -> [(a,b)] -> Bool
isMemberOf y [] = False
isMemberOf y (x:xs) = if y == fst x then True else isMemberOf y xs

-- This function takes two literal lists, multiplies them, by adding exponents if same literal, and concatenating rest of literals
calcMultiplyLiterals :: (Eq a, Num b, Eq b) => [(a,b)] -> [(a,b)] -> [(a,b)]
calcMultiplyLiterals m1 [] = m1
calcMultiplyLiterals [] m2 = m2
calcMultiplyLiterals m1 m2 = lista ++ [ (h,i) | (h,i) <- m1, isMemberOf h lista == False ] ++ [ (j,k) | (j,k) <- m2, isMemberOf j lista == False ]
  where lista = [ (a, b+d) | (a,b) <- m1, (c,d) <- m2, a == c ]

-- This function takes a monomial and a polynomial expression and multiplies the monomial with each of the polynomial expression's monomial
mulExpression :: Mono -> Poly-> Poly
mulExpression m [] = []
mulExpression m (x:xs)
    -- if monomial is null
    | null m = []
    -- if either 1st mono or 2nd mono have no literal parts, call mulOnlyCoef
    | (snd m == [] || snd x == []) = [mulOnlyCoef m x] ++ mulExpression m xs
    -- if have same literal parts
    | (snd m == snd x)  = [mulMono m x] ++ mulExpression m xs
    -- if diferent literals, use calcLiterals
    | snd m /= snd x = [(fst m * fst x, calcMultiplyLiterals (snd m) (snd x) )] ++ mulExpression m xs
    | otherwise = x:mulExpression m xs

-- This function takes two polynomials and multiplies them
mulPoly :: Poly -> Poly -> Poly
mulPoly p1 p2
-- if one of polynomials is 0, keep result as 0
 | p1 == [(0,[])] = p1
 | p2 == [(0,[])] = p2
 -- if one polynomial is 1, keep result as second polynomial
 | p1 == [(1,[])] = p2
 | p2 == [(1,[])] = p1
 -- if one polynomial is null, keep result as second polynomial
 | p1 == [] = p2
 | p2 == [] = p1
 | length p1 /= 1 =  mulExpression (head p1) p2 ++ mulPoly (tail p1) p2
 -- if length == 1, stop recursive call because if p2 == [], it would have concatenated resultant poly with p1...
 | otherwise = mulExpression (head p1) p2

-- ============================================================================
-- FUNCTION AND AUXILIARY FUNCTIONS TO DERIVATE ONE POLYOMIAL EXPRESSION
-- SPECIFYING THE VARIABLE WITH RESPECT TO WHICH TO DERIVATE

-- This function looks up char variable in literal list and if it finds, decrements exponent
mylookup :: (Eq a, Num b, Ord b) => a -> [(a,b)] -> [(a,b)]
mylookup _ [] =  []
mylookup c ((x,y) : xys)
  -- if only one element to verify and not the var we are looking for...
  | (length ((x,y) : xys) == 1 && c /= x) = []
  -- if found, decrement exponent and keep going
  | c == x  =  (( x, (y-1)) : mylookup c xys)
  | otherwise =  mylookup c xys

-- This function takes one monomial and one char variable to look within monomial literals list and decrease exponent if found char variable
-- or return (0, []) if not found
derMono :: Mono -> Char -> Mono
derMono m c
  -- if mylookup doesn't find char variable at all, return (0,[])
 | mylookup c (snd m) == [] = (0, [])
 -- mylookup returns a list of one literal because for each monomial there won't be repitable chars
 --      (ex: 2xyx won't happen because normalizing will result in 2x^2y and deriving with 'x' will get a list of literals as [('x',1)])
 --           because of this, myexponent is the exponent of the resulting list +1
 | otherwise = (fst m * myexponent , mylookup c (sort(snd m)))
                      where myexponent = (snd (head (mylookup c (snd m))) ) + 1

-- This function takes a polynomial expression and one char variable and applies monomial derivative to each element
derPoly :: Poly -> Char -> Poly
derPoly poly c = map (\mono -> derMono mono c) poly

-- ============================================================================
-- FUNCTIONS TO PRINT POLYNOMIAL

-- This function takes a polynomial expression and prints a string
printListToString :: Poly -> String
printListToString p
 | fst (head p) == 0 && length p /= 1 = printListToString (drop 1 p)
 | fst (head p) == 0 && length p == 1 = ""
 | length p == 1  && snd (head p) /= [] = show(fst (head p) ) ++ printLiteralsToString(snd (head p))
 | snd (head p) == [] && (length p == 1) = show(fst (head p))
 | snd (head p) == [] && (length p /= 1) = show(fst (head p)) ++ " " ++ "+" ++ " " ++ printListToString (drop 1 p)
 | otherwise = show(fst (head p) ) ++ printLiteralsToString(snd (head p)) ++ " " ++ "+" ++ " " ++ printListToString (drop 1 p)


-- This function takes a literal list and prints a string
printLiteralsToString :: (Eq b, Num b,  Show b) => [(Char, b)] -> String
printLiteralsToString m
 | (length m == 1 && snd (head m) /= 1) = [fst (head (m))] ++ "^" ++ show (snd (head m) )
 | length m == 1 && snd (head m) == 1 = [fst (head (m))]
 | snd (head m) == 1 = [fst (head m)]  ++ printLiteralsToString (drop 1 m)
 | otherwise = [fst (head m)] ++ "^" ++ show(snd(head m)) ++ printLiteralsToString (drop 1 m)

 -- ============================================================================
-- FUNCTIONS TO PRINT ON THE SCREEN THE RESULTANT POLYNOMIAL CONVERTED TO STRING

-- print Normalize
printNormalize :: Poly -> String
printNormalize p = printListToString (normalizePoly p)

-- print Add
printAdd :: Poly -> Poly -> String
printAdd p1 p2 = printListToString (normalizePoly (addPoly (p1) (p2) ) )

-- print Multiply
printMultiply :: Poly -> Poly -> String
printMultiply p1 p2 = printListToString (normalizePoly (mulPoly (normalizePoly(p1)) (normalizePoly (p2)) ) )

-- print Derivative
printDerivative :: Poly -> Char -> String
printDerivative p c = printListToString  ( normalizePoly (derPoly (normalizePoly (p)) c ))


-- ============================================================================
-- FUNCTIONS TO TAKE STRING AS INPUT AND CONVERT TO POLYNOMIAL TYPE

--This function converts string literal part to working type
stringToLiterals :: String -> [(Char, Int)]
stringToLiterals [] = []
stringToLiterals (x:xs)
  | x > '9' && xs == [] = [(x,1)]
  | x > '9' && (head xs) == '^' = [(x, read (takeWhile (<= '9') (drop 1 xs)) :: Int)] ++ stringToLiterals (dropWhile (<= '9') (drop 1 xs))
  | x > '9' && ((head xs) > '9') = [(x,1)] ++ stringToLiterals xs

-- This function converts string monomial part to working type
stringToMono :: String -> Mono
stringToMono l = (if (takeWhile (<= '9') l) == "" then 1 else if (takeWhile (<= '9') l) == "-" then -1 else read (takeWhile (<= '9') l) :: Int, stringToLiterals (dropWhile (<= '9') l))

-- This function cleans string and eliminates +, -, ""
listOfPoly :: [String] -> [String]
listOfPoly x
  | x == [] = []
  | head x == "" = listOfPoly (drop 1 x)
  | head x == "+" = listOfPoly (drop 1 x)
  | head x == "-" = ["-" ++ head (tail x)] ++ listOfPoly (drop 1 (tail x))
  | otherwise = [head x] ++ listOfPoly (tail x)

-- This function takes as input a list of chars resultant of words and splits it by - and +
splitOperators :: [String] -> [String]
splitOperators  (x:xs)
  | length (x:xs) == 1 = split (oneOf "-+") x
  | otherwise = split (oneOf "-+") x ++ splitOperators xs

-- TODO fix this recursion
-- This function converts string into list of chars split into monomials
getListOfPoly :: String -> [String]
getListOfPoly "" = []
getListOfPoly s = listOfPoly(listOfPoly(splitOperators (words (s))))

-- This function converts list of chars split into monomials into polynomial expressions
auxStringParser :: [String] -> Poly
auxStringParser [] = []
auxStringParser s = [stringToMono( head s)] ++ auxStringParser (tail s)

-- This function converts string into polynomial
stringParser :: String -> Poly
stringParser [] = []
stringParser s = auxStringParser (getListOfPoly s)

-- ============================================================================
-- MENU

-- This function outputs instructions on how to use our program
process :: Int -> IO ()
process opt
  | opt == 1 = putStrLn $ "To normalize one polynomial "
  | opt == 2 = putStrLn $ "To add two polynomials"
  | opt == 3 = putStrLn $ "To multiply two polynomials"
  | opt == 4 = putStrLn $ "To calculate one polynomial derivative "

-- This functions outputs a menu
menu :: IO ()
menu = do
  putStrLn $ "MENU"
  putStrLn $ "1 to normalize polynomial"
  putStrLn $ "2 to add polynomials"
  putStrLn $ "3 to multiply polynomials"
  putStrLn $ "4 to calculate one polynomial derivative"
  input <- getLine
  let option = read input :: Int
  if (option > 4 || option < 1) then
    menu
  else
    process option
