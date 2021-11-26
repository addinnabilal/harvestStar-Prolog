:- dynamic(gold/2).
:- dynamic(time/2).
:- dynamic(overallExp/2).
:- dynamic(fishingExp/2).
:- dynamic(farmingExp/2).
:- dynamic(ranchingExp/2).
:- dynamic(overallLevel/2).
:- dynamic(fishingLevel/2).
:- dynamic(farmingLevel/2).
:- dynamic(ranchingLevel/2).
:- dynamic(tagetOverallExp/2).
:- dynamic(targetFishingExp/2).
:- dynamic(targetFarmingExp/2).
:- dynamic(targetRanchingExp/2).
:- dynamic(currStamina/2).
:- dynamic(maxStamina/2).



createFarmer(X) :-  asserta(job(X, farmer)),
                    asserta(gold(X,300)),
                    asserta(time(X,0)),
                    asserta(overallExp(X,0)),
                    asserta(targetExp(X,100)),
                    asserta(fishingExp(X,0)),
                    asserta(farmingExp(X,0)),
                    asserta(ranchingExp(X,0)),
                    asserta(overallLevel(X,0)),
                    asserta(fishingLevel(X,0)),
                    asserta(farmingLevel(X,0)),
                    asserta(ranchingLevel(X,0)),
                    asserta(targetFishingExp(X,40)),
                    asserta(targetRanchingExp(X,40)),
                    asserta(targetFarmingExp(X,40)),
                    asserta(currStamina(X,3)),
                    asserta(maxStamina(X,3)),
                    asserta(time(X,0)),
                    displayChar,
                    create_farmer_inventory.

:- dynamic(createFisherman/1).
createFisherman(X) :-  asserta(job(X, fisherman)),
                    asserta(gold(X,300)),
                    asserta(time(X,0)),
                    asserta(overallExp(X,0)),
                    asserta(targetExp(X,100)),
                    asserta(fishingExp(X,0)),
                    asserta(farmingExp(X,0)),
                    asserta(ranchingExp(X,0)),
                    asserta(overallLevel(X,0)),
                    asserta(fishingLevel(X,0)),
                    asserta(farmingLevel(X,0)),
                    asserta(ranchingLevel(X,0)),
                    asserta(targetFishingExp(X,40)),
                    asserta(targetRanchingExp(X,40)),
                    asserta(targetFarmingExp(X,40)),
                    asserta(currStamina(X,3)),
                    asserta(maxStamina(X,3)),
                    asserta(time(X,0)),
                    displayChar,
                    create_fisherman_inventory.

:- dynamic(createRancher/1).
createRancher(X) :-  asserta(job(X, rancher)),
                    asserta(gold(X,300)),
                    asserta(time(X,0)),
                    asserta(overallExp(X,0)),
                    asserta(targetExp(X,100)),
                    asserta(fishingExp(X,0)),
                    asserta(farmingExp(X,0)),
                    asserta(ranchingExp(X,0)),
                    asserta(overallLevel(X,0)),
                    asserta(fishingLevel(X,0)),
                    asserta(farmingLevel(X,0)),
                    asserta(ranchingLevel(X,0)),
                    asserta(targetFishingExp(X,40)),
                    asserta(targetRanchingExp(X,40)),
                    asserta(targetFarmingExp(X,40)),
                    asserta(currStamina(X,3)),
                    asserta(maxStamina(X,3)),
                    asserta(time(X,0)),
                    displayChar,
                    create_rancher_inventory.
                    
checkStatus(X) :-   write('Username         :')  , write(X), nl,
                    write('Job              :')  , job(X,Job), write(Job), nl,
                    write('Level            :')  , overallLevel(X, Level), write(Level), nl,
                    write('Level farming    :')  , farmingLevel(X, FarmingLevel), write(FarmingLevel), nl,
                    write('Level fishing    :')  , fishingLevel(X, FishingLevel), write(FishingLevel), nl,
                    write('Level ranching   :')  , ranchingLevel(X, RanchingLevel), write(RanchingLevel), nl,
                    write('Exp              :')  , overallExp(X, Exp), write(Exp), targetExp(X, TargetExp), write('/'), write(TargetExp), nl,
                    write('Exp farming      :')  , farmingExp(X, FarmingExp), write(FarmingExp), targetFarmingExp(X, TargetFarmingExp), write('/'), write(TargetFarmingExp), nl,
                    write('Exp fishing      :')  , fishingExp(X, FishingExp), write(FishingExp), targetFishingExp(X, TargetFishingExp), write('/'), write(TargetFishingExp), nl,
                    write('Exp ranching     :')  , ranchingExp(X, RanchingExp), write(RanchingExp), targetRanchingExp(X, TargetRanchingExp), write('/'), write(TargetRanchingExp), nl,
                    write('Gold             :')  , gold(X, Gold), write(Gold), nl,
                    write('Stamina          :')  , currStamina(X, CurrStamina), write(CurrStamina), maxStamina(X, MaxStamina), write('/'), write(MaxStamina),nl,
                    write('Day              :')  , time(X, Time), write(Time).

displayChar:-    write('               ,,,     ,,,                  '),nl,
                    write('             ,,,,,,,,,,,,,,,                                    '),nl,
                    write('           ,,,,,,,,,,,,,,,,,,,                                  '),nl,
                    write('          ,,,,*************,,,,                                 '),nl,
                    write('          *********************                                 '),nl,
                    write('      /////////////***/////////////                             '),nl,
                    write('  ////////%%,,,,,,,,,,,,,,,,,%%////////                         '),nl,
                    write('  ///////**%,,,##,,,,,,,##,,,%**///////                         '),nl,
                    write('      ////*,,,,,,,,,,,,,,,,,,,*////                             '),nl,
                    write('           ,,,,,,,,,,,,,,,,,,,                                  '),nl,
                    write('             ,,,,,,,,,,,,,,,                                    '),nl,
                    write('               ,,,,,,,,,,,                                      '),nl,                    
                    write('               ***********                                      '),nl,
                    write('           ///##*********##///                                  '),nl,
                    write('       ###////####*****####////###                              '),nl,
                    write('     #####////######*######////#####                            '),nl,
                    write('    ######////#############////######                           '),nl,
                    write('   #######/%%///////////////%%/#######                          '),nl,
                    write('   #######/////////////////////#######                          '),nl.




