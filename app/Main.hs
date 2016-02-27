module Main where

import Lib
import System.Random

main :: IO ()
main = do
    putStrLn "This is RL004bolzman."
    g <- getStdGen
    let randNums = randomRs (0,1) g :: [Double]
    qs_init <- init_qs (length rewards) (length $ rewards!!0)
    let qs = episodes 0 num_of_episodes rewards qs_init randNums
    print_Qs qs
    learned_actions (num_of_episodes + 1) (num_of_episodes + 1) 0 qs
    



rewards :: [[Double]]
rewards = [[-1, 2],
           --[-1, 1],
           --[-1, 1],
           [-3, 3],
           [20, 1],
           [2, -3]]

num_of_episodes :: Int
num_of_episodes = 10000

rand_001 :: IO Double
rand_001 = getStdRandom (randomR (0, 0.01)) :: IO Double

init_qs :: Int -> Int -> IO [[Double]]
init_qs n m = do
    g <- (getStdRandom random :: IO Int)
    let qs = ll_nm n m (take (n*m) $ randomRs (0, 0.01) $ mkStdGen g :: [Double])
    return qs

print_Qs qs = do
    let loop i | i < length qs = do
            print $ (qs!!i, (qs!!i!!0 / qs!!i!!1))
            loop $ i + 1
        loop _ = return ()
    loop 0

learned_actions :: Int -> Int -> Int -> [[Double]] -> IO ()
learned_actions t t_f state qs = do
    randNum <- getStdRandom (randomR (0,1)) :: IO Double
    let action = take_action t (qs!!state) randNum
    let qs_new = update_Q state action (rewards!!state!!action) qs
    let state_new = change_state state action qs
    print $ "action = " ++ (show action) ++ ", when state = " ++ (show state)
    if t < length qs + t_f + 3
        then learned_actions (t+1) t_f state_new qs_new
        else print $ "last state = " ++ show state_new