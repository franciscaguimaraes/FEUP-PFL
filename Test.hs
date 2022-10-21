import Test.QuickCheck ( (==>), withMaxSuccess, quickCheck, Property )
import Data.List
import Proj (removeExpNull, isMemberOf, calcLiterals, expressionCleanUp, addMono, addSameMono, normalizePoly, addPoly,mulMono, mulOnlyCoef, mulExpression,mulPoly,mylookup,derMono, derPoly)

type Mono = (Int, [(Char, Int)])
type Poly = [Mono]


hasSameElements :: (Eq a) => [a] -> [a] -> Bool
hasSameElements x y = null (x \\ y) && null (y \\ x)

-- =====================================================

testAddAssociativity :: Poly -> Poly -> Bool
testAddAssociativity p1 p2 = hasSameElements (addPoly p1 p2) (addPoly p2 p1)

testAddNullElem :: Poly -> Bool
testAddNullElem p1 = hasSameElements (addPoly (normalizePoly p1) [(0,[])]) (normalizePoly p1)

testMulAssociativity :: Poly -> Poly -> Bool
testMulAssociativity p1 p2 = hasSameElements (normalizePoly ( mulPoly (normalizePoly p1) (normalizePoly p2 ) ) ) ( normalizePoly ( mulPoly (normalizePoly p2)  (normalizePoly p1 ) ) )

testMulNullElem :: Poly -> Bool
testMulNullElem p1 = hasSameElements (normalizePoly (mulPoly p1 [(1,[])])) (normalizePoly p1)

testDerivativeNullElem :: Poly -> Bool
testDerivativeNullElem p1 = hasSameElements (normalizePoly (derPoly ( p1 ++ [(5,[])]) 'x') ) (normalizePoly (derPoly p1 'x'))

testDerivativeAdd :: Poly -> Poly -> Bool
testDerivativeAdd p1 p2 = hasSameElements (normalizePoly (derPoly (addPoly (normalizePoly p1) (normalizePoly p2)) 'x') ) ( normalizePoly (addPoly (derPoly (normalizePoly p1) 'x') (derPoly (normalizePoly p2) 'x')))

-- Alguns exemplos
-- normalizePoly [(3,[]),(2,[('x',3)])]
-- multiply [ (1, [('x',1)] ) , (1, [('y',1)] ) , (-5, []) ] [(1, [('x',1)]), (1, [('y',1)]) , (5, [])]
-- printDerivative [ (3, [('t', 7)]), (-6,[('t',4)]), (8,[('t',3)]) , (-12,[('t',1)]), (18, [])] 't'
-- printDerivative [ (1, [('x', 3)]), (-1,[('x',2)]), (1,[('x',1)]) , (-1,[])] 'x'
-- printDerivative [ (3, [('x', 7)]), (5,[('x',3)]), (-11,[('x',1)])] 'x'
-- printDerivative [ (-1, [('x', 4)]), (2,[('x',4)]), (1,[]) ] 'x'
-- printDerivative [ (-3, [('x', 2)]), (-1,[('x',3)]), (-11,[]) ] 'x'
-- printMultiply [ (1, [('x', 1)]), (2,[])] [(1,[('x',1)]) , (1, []) ]
-- printMultiply [ (2, [('x', 1)]), (-1,[])] [(5,[('x',1)]) , (-6, []) ]
-- printMultiply ([ (4, [('x', 1)]) ]) (mulPoly [ (4,[('x',1)]) , (-2, []) ] [ (1,[('x',2)]), (-3,[])] )
-- printMultiply [ (1, [('x', 2)]), (2,[('x',1)]) , (-1, []) ] [ (2,[('x',2)]), (-3,[('x',1)]), (6,[]) ]

{- ex: 2xy + 7 -> [(2, [(x, 1), (y,1)]), (7, [])]-}
-- [ (0 , [('x',2)] ) , (2, [('y',1)]) , (5, [('z', 1)]) , (1 , [('y',1)]) , (7 , [('y',2)]) ] -> (0x^2 + 2*y + 5*z , y, -7y^2)

main :: IO ()
main = do


    -- Property testing
      quickCheck (withMaxSuccess 50 testAddAssociativity)
      quickCheck (withMaxSuccess 50 testAddNullElem)
      quickCheck (withMaxSuccess 50 testMulAssociativity) --mt lento mesmooo
      quickCheck (withMaxSuccess 50 testMulNullElem) --mt lento
      quickCheck (withMaxSuccess 50 testDerivativeNullElem)
      quickCheck (withMaxSuccess 50 testDerivativeAdd)

      -- problems with calcLiterals!!!


    -- Specific tests
    {--
        if not (testAddPoly 100 1) then putStrLn "Specific add test 1 failed" else putStr ""
        if not (testAddPoly 100 (-1)) then putStrLn "Specific add test 2 failed" else putStr ""
        if not (testAddPoly 1 100) then putStrLn "Specific add test 3 failed" else putStr ""
        if not (testAddPoly (-100) 1) then putStrLn "Specific add test 4 failed" else putStr ""
        if not (testAddPoly 97 25) then putStrLn "Specific add test 5 failed" else putStr ""
        if not (testAddPoly 103241 (-32)) then putStrLn "Specific add test 6 failed" else putStr ""
        if not (testAddPoly (-103241) (-32)) then putStrLn "Specific add test 7 failed" else putStr ""
        if not (testAddPoly 150 0) then putStrLn "Specific add test 8 failed" else putStr ""
        if not (testAddPoly 0 (-231)) then putStrLn "Specific add test 9 failed" else putStr ""
        if not (testAddPoly 0 0) then putStrLn "Specific add test 10 failed" else putStr ""
        if not (testAddPoly 1 (-1)) then putStrLn "Specific add test 11 failed" else putStr ""
        if not (testAddPoly 10 (-100)) then putStrLn "Specific add test 12 failed" else putStr ""

        if not (testNormalizePoly 10 (-100)) then putStrLn "Specific normalization test 1 failed" else putStr ""
        if not (testNormalizePoly 20 20) then putStrLn "Specific normalization test 2 failed" else putStr ""
        if not (testNormalizePoly 100 20) then putStrLn "Specific normalization test 3 failed" else putStr ""
        if not (testNormalizePoly (-10) (-100)) then putStrLn "Specific normalization test 4 failed" else putStr ""
        if not (testNormalizePoly 50 20) then putStrLn "Specific normalization test 5 failed" else putStr ""
        if not (testNormalizePoly 50 100) then putStrLn "Specific normalization test 6 failed" else putStr ""
        if not (testNormalizePoly 100 (-100)) then putStrLn "Specific normalization test 7 failed" else putStr ""
        if not (testNormalizePoly 24 3) then putStrLn "Specific normalization test 8 failed" else putStr ""
        if not (testNormalizePoly 7890 3450) then putStrLn "Specific normalization test 9 failed" else putStr ""
        if not (testNormalizePoly 9001 983) then putStrLn "Specific normalization test 10 failed" else putStr ""

        if not (testMultiplyPoly 24 3) then putStrLn "Specific multiplication test 1 failed" else putStr ""
        if not (testMultiplyPoly 203 24) then putStrLn "Specific multiplication test 2 failed" else putStr ""
        if not (testMultiplyPoly 2487 (-3)) then putStrLn "Specific multiplication test 3 failed" else putStr ""
        if not (testMultiplyPoly 2 598) then putStrLn "Specific multiplication test 4 failed" else putStr ""
        if not (testMultiplyPoly 19 (-54)) then putStrLn "Specific multiplication test 5 failed" else putStr ""
        if not (testMultiplyPoly 0 20) then putStrLn "Specific multiplication test 6 failed" else putStr ""
        if not (testMultiplyPoly 57 987) then putStrLn "Specific multiplication test 7 failed" else putStr ""
        if not (testMultiplyPoly 124 0) then putStrLn "Specific multiplication test 8 failed" else putStr ""
        if not (testMultiplyPoly 0 0) then putStrLn "Specific multiplication test 9 failed" else putStr ""
        if not (testMultiplyPoly (-251) (-3)) then putStrLn "Specific multiplication test 10 failed" else putStr ""
        if not (testMultiplyPoly (-24) 345) then putStrLn "Specific multiplication test 11 failed" else putStr ""

        if not (testDerivativePoly 24 345) then putStrLn "Specific derivative test 1 failed" else putStr ""
        if not (testDerivativePoly 50 5) then putStrLn "Specific derivative test 2 failed" else putStr ""
        if not (testDerivativePoly 0 4) then putStrLn "Specific derivative test 3 failed" else putStr ""
        if not (testDerivativePoly 42 3) then putStrLn "Specific derivative test 4 failed" else putStr ""
        if not (testDerivativePoly 476 25) then putStrLn "Specific derivative test 5 failed" else putStr ""
        if not (testDerivativePoly 2024 345) then putStrLn "Specific derivative test 6 failed" else putStr ""
        if not (testDerivativePoly 824 142) then putStrLn "Specific derivative test 7 failed" else putStr ""
        if not (testDerivativePoly 94 125) then putStrLn "Specific derivative test 8 failed" else putStr ""
        if not (testDerivativePoly 234 29) then putStrLn "Specific derivative test 9 failed" else putStr ""
        if not (testDerivativePoly 4 9) then putStrLn "Specific derivative test 10 failed" else putStr ""
--}
