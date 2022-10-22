import Test.QuickCheck (withMaxSuccess, quickCheck )
import Proj (normalizePoly, addPoly , mulPoly, derPoly, printP, sP)
import Data.List

type Mono = (Int, [(Char, Int)])
type Poly = [Mono]

-- =====================================================
-- AUX FUNCTION TO DETERMINE TEST BOOL

hasSameElements :: (Eq a) => [a] -> [a] -> Bool
hasSameElements x y = null (x \\ y) && null (y \\ x)

-- =====================================================

testAddAssociativity :: Poly -> Poly -> Bool
testAddAssociativity p1 p2 = hasSameElements (addPoly p1 p2) (addPoly p2 p1)

testAddNullElem :: Poly -> Bool
testAddNullElem p1 = hasSameElements (addPoly (normalizePoly p1) [(0,[])]) (normalizePoly p1)

testMulAssociativity :: Poly -> Poly -> Bool
testMulAssociativity p1 p2 = hasSameElements ( normalizePoly ( mulPoly p1 p2 ) ) ( normalizePoly ( mulPoly  p2 p1  ) )

testMulNeutralElem :: Poly -> Bool
testMulNeutralElem p1 = hasSameElements (normalizePoly (mulPoly p1 [(1,[])])) (normalizePoly p1)


testDerivativeNullElem :: Poly -> Bool
testDerivativeNullElem p1 = hasSameElements (normalizePoly (derPoly ( p1 ++ [(5,[])]) 'x') ) (normalizePoly (derPoly p1 'x'))

testDerivativeAdd :: Poly -> Poly -> Bool
testDerivativeAdd p1 p2 = hasSameElements (normalizePoly (derPoly (addPoly (normalizePoly p1) (normalizePoly p2)) 'x') ) ( normalizePoly (addPoly (derPoly (normalizePoly p1) 'x') (derPoly (normalizePoly p2) 'x')))

main :: IO ()
main = do

    -- Property testing
    quickCheck (withMaxSuccess 25 testAddAssociativity)
    quickCheck (withMaxSuccess 25 testAddNullElem)
    quickCheck (withMaxSuccess 25 testMulAssociativity)
    quickCheck (withMaxSuccess 25 testMulNeutralElem)
    quickCheck (withMaxSuccess 25 testDerivativeNullElem)
    quickCheck (withMaxSuccess 25 testDerivativeAdd)

    -- Specific tests
    if not (testAddAssociativity [(1, [('x',1)])] [(1, [('x',1)])] ) then putStrLn "Specific add associativity test 1 failed" else putStr ""
    if not (testAddAssociativity [(3,[])] [(2,[('x',3)])] ) then putStrLn "Specific add associativity test 2 failed" else putStr ""
    if not (testAddAssociativity [(3, [('y',1)])] [(5, [])]) then putStrLn "Specific add associativity test 3 failed" else putStr ""
    if not (testAddAssociativity [ (3, [('t', 7)]), (-6,[('t',4)])] [(8,[('t',3)]) , (-12,[('t',1)]), (18, [])]  ) then putStrLn "Specific add associativity test 4 failed" else putStr ""
    if not (testAddAssociativity [(1, [('x',1)])] [(3,[]),(2,[('x',3)])]) then putStrLn "Specific add associativity test 5 failed" else putStr ""


    if not (testAddNullElem [(1, [('x',1)])]) then putStrLn "Specific add null element test 1 failed" else putStr ""
    if not (testAddNullElem [(2, [('x',3)]), (-1, [('x',2)]), (1, [('x',1)]), (1, [])]) then putStrLn "Specific add null element test 2 failed" else putStr ""
    if not (testAddNullElem [(-15, [('x',3)]), (7, [('x',2)]), (1, [('x',1)]), (-1, [])]) then putStrLn "Specific add null element test 3 failed" else putStr ""
    if not (testAddNullElem [(1, [('x',8)]), (-3, [('x', 7)]), (-1, [('x',5),('x',1)])]) then putStrLn "Specific add null element test 4 failed" else putStr ""
    if not (testAddNullElem [(4, [('x',5)]), (-1 , [('x', 4)])]) then putStrLn "Specific add null element test 5 failed" else putStr ""


    if not (testMulAssociativity [ (1, [('x', 2)]), (2,[('x',1)]) , (-1, []) ] [ (2,[('x',2)]), (-3,[('x',1)]), (6,[]) ]) then putStrLn "Specific derivative add associativity test 1 failed" else putStr ""
    if not (testMulAssociativity [ (4,[('x',1)]) , (-2, []) ] [ (1,[('x',2)]), (-3,[])]) then putStrLn "Specific derivative add associativity test 2 failed" else putStr ""
    if not (testMulAssociativity [ (1, [('x', 1)]), (2,[])] [(1,[('x',1)]) , (1, []) ]) then putStrLn "Specific derivative add associativity test 3 failed" else putStr ""
    if not (testMulAssociativity [ (1, [('x',1)] ) , (1, [('y',1)] ) , (-5, []) ] [(1, [('x',1)]), (1, [('y',1)]) , (5, [])]) then putStrLn "Specific derivative add associativity test 4 failed" else putStr ""
    if not (testMulAssociativity [(1, [('x',1)])] [(1, [('x',1)])]) then putStrLn "Specific derivative add associativity test 5 failed" else putStr ""


    if not (testMulNeutralElem [(1, [('x',1)])]) then putStrLn "Specific multiply neutral element test 1 failed" else putStr ""
    if not (testMulNeutralElem [(-600, [('x',10)])]) then putStrLn "Specific multiply neutral element test 2 failed" else putStr ""
    if not (testMulNeutralElem [(1, [('x',1)]), (-600, [('x',10)]) ]) then putStrLn "Specific multiply neutral element test 3 failed" else putStr ""
    if not (testMulNeutralElem [(-15, [('x',3)]), (7, [('x',2)]), (1, [('x',1)]), (-1, [])]) then putStrLn "Specific multiply neutral element test 4 failed" else putStr ""
    if not (testMulNeutralElem [(2, [('x',3)]), (-1, [('x',2)]), (1, [('x',1)]), (1, [])]) then putStrLn "Specific multiply neutral element test 5 failed" else putStr ""


    if not (testDerivativeNullElem [ (3, [('x', 7)]), (-6,[('x',4)]), (8,[('x',3)]) , (-12,[('x',1)]), (18, [])]) then putStrLn "Specific drivative null element test 1 failed" else putStr ""
    if not (testDerivativeNullElem [ (1, [('x', 3)]), (-1,[('x',2)]), (1,[('x',1)]) , (-1,[])]) then putStrLn "Specific drivative null element test 2 failed" else putStr ""
    if not (testDerivativeNullElem [ (3, [('x', 7)]), (5,[('x',3)]), (-11,[('x',1)])] ) then putStrLn "Specific drivative null element test 3 failed" else putStr ""
    if not (testDerivativeNullElem [ (-1, [('x', 4)]), (2,[('x',4)]), (1,[]) ]) then putStrLn "Specific drivative null element test 4 failed" else putStr ""
    if not (testDerivativeNullElem [ (-3, [('x', 2)]), (-1,[('x',3)]), (-11,[]) ]) then putStrLn "Specific drivative null element test 5 failed" else putStr ""


    if not (testDerivativeAdd [(1, [('x',8)]), (-3, [('x', 7)]), (-1, [('x',5),('x',1)])] [(1, [('x',1)])]) then putStrLn "Specific derivative add test 1 failed" else putStr ""
    if not (testDerivativeAdd [(2, [('x',3)]), (-1, [('x',2)]), (1, [('x',1)]), (1, [])] [ (1, [('x', 1)]), (2,[]), (1,[('x',1)]) , (1, []) ]) then putStrLn "Specific derivative add test 2 failed" else putStr ""
    if not (testDerivativeAdd [ (1, [('x',1)] ) , (1, [('y',1)] ) , (-5, []) ] [(1, [('x',1)]), (1, [('y',1)]) , (5, [])]) then putStrLn "Specific derivative add test 3 failed" else putStr ""
    if not (testDerivativeAdd  [ (1, [('x', 2)]), (2,[('x',1)]) , (-1, []) ] [ (2,[('x',2)]), (-3,[('x',1)]), (6,[]) ]) then putStrLn "Specific derivative add test 4 failed" else putStr ""
    if not (testDerivativeAdd [(-3, [('x', 2)]), (-1,[('x',3)]), (-11,[]) ]  [ (-1, [('x', 4)]), (2,[('x',4)]), (1,[])] ) then putStrLn "Specific derivative add test 5 failed" else putStr ""

    -- The string parser tests below do not take in account normalization
    if ( (sP "2x + 7 -4 +5x^2y") /= [(2,[('x',1)]),(7,[]),(-4,[]),(5,[('x',2),('y',1)])]) then putStrLn "Specific string parser test 1 failed" else putStr ""
    if ( (sP "-xy^2 + xxx -4") /= [(-1,[('x',1),('y',2)]),(1,[('x',1),('x',1),('x',1)]),(-4,[])]) then putStrLn "Specific string parser test 2 failed" else putStr ""
    if ( (sP "-y + y -4y +2y") /= [(-1,[('y',1)]),(1,[('y',1)]),(-4,[('y',1)]),(2,[('y',1)])]) then putStrLn "Specific string parser test 3 failed" else putStr ""
    if ( (sP "7 + x    -y -x + y") /= [(7,[]),(1,[('x',1)]),(-1,[('y',1)]),(-1,[('x',1)]),(1,[('y',1)])]) then putStrLn "Specific string parser test 4 failed" else putStr ""
    if ( (sP "5y^2x^100z^3 + 6 + 7") /= [(5,[('y',2),('x',100),('z',3)]),(6,[]),(7,[])]) then putStrLn "Specific string parser test 5 failed" else putStr ""

    -- The print polynomial tests below do take in account notmalization
    if ( printP [(2,[('x',1)]),(7,[]),(-4,[]),(5,[('x',2),('y',1)])] /= "5x^2y + 3 + 2x") then putStrLn "Specific print polynomial test 1 failed" else putStr ""
    if ( printP [(-1,[('x',1),('y',2)]),(1,[('x',1),('x',1),('x',1)]),(-4,[])] /= "-4 + 1x^3 + -1xy^2") then putStrLn "Specific  print polynomial test 2 failed" else putStr ""
    if ( printP [(-1,[('y',1)]),(1,[('y',1)]),(-4,[('y',1)]),(2,[('y',1)])] /= "-2y") then putStrLn "Specific print polynomial test 3 failed" else putStr ""
    if ( printP [(7,[]),(1,[('x',1)]),(-1,[('y',1)]),(-1,[('x',1)]),(1,[('y',1)])] /= "7") then putStrLn "Specific print polynomial test 4 failed" else putStr ""
    if ( printP [(5,[('y',2),('x',100),('z',3)]),(6,[]),(7,[])] /= "13 + 5x^100y^2z^3") then putStrLn "Specific  print polynomial test 5 failed" else putStr ""
