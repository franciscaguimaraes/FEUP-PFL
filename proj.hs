{- ex: 2xy + 7 -> [(2, [(x, 1), (y,1)]), (7, [])]-}
type Mono = (Int, [(Char, Int)])
type Poly = [Mono]

-- encontra o char e diminui o seu expoente, se o expoente for 0 e quisermos
-- derivar, elimina o char direto
mylookup :: (Eq a, Num b, Ord b) => a -> [(a,b)] -> [(a,b)]
mylookup _ [] =  []
mylookup key ((x,y) : xys)
  | y == 0 = [] ++ mylookup key xys
  | (length ((x,y) : xys) == 1 && key /= x) = []
  | key == x  =  if (y > 1) then  ( ( x, (y-1) ) : xys) else (xys)
  | otherwise =  mylookup key xys

monoDer :: (Int, [(Char, Int)]) -> Char -> (Int, [(Char, Int)])
monoDer m c
 | fst m == 0 = (0, [])
 | snd m == [] = (0, [])
 | mylookup c (snd m) == [] = (0, [])
 | otherwise = (fst m * expoente , mylookup c (snd m)) where expoente = (snd (head (mylookup c (snd m))) ) + 1

polyDer :: Poly -> Char -> Poly
polyDer poly c =  map (\mono -> monoDer mono c) poly

-- TODO: finish list to string output


listToString :: Poly -> String
listToString p
-- caso inicial tá
 | length p == 0 = ""
 | fst (head p) == 0 = ""
 | snd (head p) == [] = ""
-- casos restantes
 | otherwise = show(fst (head p) ) ++ literalsToString(snd (head p))

 literalsToString :: [(a, b)] -> [Char]
 literalsToString m
  | length m == 1 && snd (head m) /= 1 = show(fst m) ++ "^" ++ show(snd m)
  | snd (head m) == 1 = show(fst m) ++ " " ++ literalsToString (drop 1 m)
  | otherwise = show(fst m) ++ "^" ++ show(snd m) ++ " " ++ literalsToString (drop 1 m)

-- main = print $ show (fst (9, [('x', 1), ('y', 2)]))  ++   show (fst (head (snd (9, [('x', 1), ('y', 2)]))) )++ "^" ++ show (snd (head (snd (9, [('x', 1), ('y', 2)])) ) ) ++ " "



{-polyCleanUp :: Poly -> Poly
polyCleanUp l
 | length l == 1 = l
 | fst (head l) == 0 = polyCleanUp (drop 1 l)
 | otherwise = polyCleanUp (l)
-}
--Se coef = 0, não se imprime





{-- type Board = [(Int, Int)]
 showTuples :: Board -> String
 showTuples [] = ""
 showTuples (x:[]) = show(fst(x)) ++ " " ++ show(snd(x))
 showTuples (x:xs) = show(fst(x)) ++ " " ++ show(snd(x)) ++ " " ++ showTuples xs

 main :: IO ()
 main = putStrLn . showTuples $ [(8, 7), (5, 6), (3, 3), (9, 4), (5, 4)] -- 8 7 5 6 3 3 9 4 5 4 --}

{--
myprint :: (Poly a, Show a) => Prelude.String -> Poly -> IO ()
myprint funcName f n = do
  putStrLn $ funcName ++ ": " ++ (show f n)

-- ++ " Polynomial = " ++ (show $ absoluteError approx)
  --where approx = f n


printComparison :: Int -> Int -> IO ()
printComparison ver n = do
  printAproximation "calcPi1" (calcPi1 ver) n
  printAproximation "calcPi2" (calcPi2 ver) n
-}
