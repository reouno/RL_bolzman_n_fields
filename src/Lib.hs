module Lib
    ( temper, calc_p, choose_action, take_action
    , change_state, replace_nm, update_Q
    , episode, episodes
    , ll_nm
    ) where


-- 定数
alpha :: Double
alpha = 0.1

gamma :: Double
gamma = 0.9


-- 関数
temper :: Int -> Double
temper t = 1 / log(0.0001 * ((fromIntegral t) :: Double) + 1.1)
-- 温度（temperture）の関数、と言ってもここでは、十分な時間が経過すると0に収束する関数として1/logxを使った

calc_p :: Floating b => [b] -> b -> [b]
calc_p qs temp = map (/ denom) numer
    where
        numer = (map exp) . (map (/temp)) $ qs
        denom = sum numer

-- 再帰関数内で最初の値を保持する方法がわかれば、引数にnを入れる必要はなくなる
choose_action :: (Num a, Ord a) => [a] -> Int -> a -> Int
choose_action ps@(x0:_) len_ps randNum
    | randNum <= x0 = len_ps - length ps
    | randNum >  1  = error "randNum must be 1 or less."
    | otherwise     = choose_action ps_next len_ps randNum
    where
        ps_next = sum_reduce ps
        sum_reduce [] = []
        sum_reduce [x] = [x]
        sum_reduce (x0:x1:xs) = (x0 + x1) : xs

take_action :: Int -> [Double] -> Double -> Int
take_action t qs randNum = choose_action (calc_p qs $ temper t) (length qs) randNum

change_state :: Int -> Int -> [[Double]] -> Int
change_state state action qs = case action of
                                0| state <  length qs - 1 -> state + 1
                                 | state == length qs - 1 -> state
                                1| state >  0 -> state - 1
                                 | state == 0 -> state

replace_nm :: Int -> Int -> t -> [[t]] -> [[t]]
replace_nm n m new_value xs = replace_n n (replace_n m new_value $ xs!!n) xs
    where
        replace_n _ _ [] = []
        replace_n 0 new_value (x:xs) = new_value:xs
        replace_n n new_value (x:xs) = x:replace_n (n - 1) new_value xs

--update_Q :: Int -> Int -> Double -> [[Double]] -> [[Double]]
--update_Q state action reward qs = replace_nm state action q_new qs
--    where
--        q_new = q_prev + alpha * (reward + gamma * (maximum $ qs!!state_next) - q_prev)
--        q_prev = qs!!state!!action
--        state_next = change_state state action qs
update_Q :: Int -> Int -> Double -> [[Double]] -> [[Double]]
update_Q state action reward qs =
    let
        q_new = q_prev + alpha * (reward + gamma * (maximum $ qs!!state_next) - q_prev)
        q_prev = qs!!state!!action
        state_next = change_state state action qs
    in
        replace_nm state action q_new qs



episode :: Int -> Int -> Int -> Int -> [[Double]] -> [[Double]] -> [Double] -> ([[Double]], Int)
episode t_s t_f state action rewards qs (randNum:randNums) =
    if t_s < t_f
        then
            let
                qs' = update_Q state action (rewards!!state!!action) qs
                state' = change_state state action qs
                action' = take_action t_s (qs!!state) randNum
            in
                episode (t_s+1) t_f state' action' rewards qs' randNums
        else
            (qs, state)

episodes :: Int -> Int -> [[Double]] -> [[Double]] -> [Double] -> [[Double]]
episodes t_s t_f rewards qs (randNum:randNums) =
    if t_s < t_f
        then
            let
                qs' = fst $ episode t_s (t_s+length qs+5) 0 (take_action t_s (qs!!0) randNum) rewards qs randNums
                randNums' = drop (length qs) randNums
            in
                episodes (t_s+1) t_f rewards qs' randNums'
        else
            qs

ll_nm _ _ [] = []
ll_nm n m xs = take n $ xs_fst : ll_nm (n-1) m xs_snd
    where (xs_fst, xs_snd) = splitAt m xs
-- これはMain.hsのinit_qs内で使う