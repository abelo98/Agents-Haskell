module Tester

where
import App (main)


run _  4 = []
run 10  agent = run 0 (agent+1)
run envInd agent =
    let envs = [(6,6),(6,6),(10,14),(10,14),(13,12),(13,12),(12,12),(12,12),(14,9),(14,9)]
        rbts = [2,2,3,3,4,4,2,3,2,4]
        start_obst = [1,2,5,5,5,3,5,12,3,10]
        start_kids = [1,3,4,4,4,2,5,5,3,3]
        start_dirt = [0,1,3,4,5,1,4,10,2,6]
        t = [2,4,5,10,14,7,18,10,4,12]
        noSim = 30
        
        r = uncurry (main (t!!envInd)) (envs!!envInd) (start_kids!!envInd) (rbts!!envInd) (start_obst!!envInd) (start_dirt!!envInd) agent [] 0 0 noSim
        in (r,agent):run (envInd + 1) agent

runSingle _ 4 = []
runSingle 1 agent = runSingle 0  (agent+1)
runSingle envInd agent =
    let envs = [(5,5)]
        rbts = [1]
        start_obst = [1]
        start_kids = [1]
        start_dirt = [0]
        t = [2]
        noSim = 4
        r = uncurry (main (t!!envInd)) (envs!!envInd) (start_kids!!envInd) (rbts!!envInd) (start_obst!!envInd) (start_dirt!!envInd) agent [] 0 0 noSim
       in (r,agent):runSingle (envInd + 1) agent