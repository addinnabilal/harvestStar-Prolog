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
                    asserta(gold(X,2000)),
                    asserta(time(X,0)),
                    asserta(overallExp(X,0)),
                    asserta(targetExp(X,100)),
                    asserta(fishingExp(X,0)),
                    asserta(farmingExp(X,0)),
                    asserta(ranchingExp(X,0)),
                    asserta(overallLevel(X,1)),
                    asserta(fishingLevel(X,1)),
                    asserta(farmingLevel(X,1)),
                    asserta(ranchingLevel(X,1)),
                    asserta(targetFishingExp(X,40)),
                    asserta(targetRanchingExp(X,40)),
                    asserta(targetFarmingExp(X,40)),
                    asserta(currStamina(X,3)),
                    asserta(maxStamina(X,3)),
                    asserta(probabilityPotionState(X, notHave)),
                    asserta(staminaPotionState(X, notHave)),
                    displayFarmer,
                    create_farmer_inventory.

createFisherman(X) :-  asserta(job(X, fisherman)),
                    asserta(gold(X,0)),
                    asserta(time(X,0)),
                    asserta(overallExp(X,0)),
                    asserta(targetExp(X,100)),
                    asserta(fishingExp(X,0)),
                    asserta(farmingExp(X,0)),
                    asserta(ranchingExp(X,0)),
                    asserta(overallLevel(X,1)),
                    asserta(fishingLevel(X,1)),
                    asserta(farmingLevel(X,1)),
                    asserta(ranchingLevel(X,1)),
                    asserta(targetFishingExp(X,40)),
                    asserta(targetRanchingExp(X,40)),
                    asserta(targetFarmingExp(X,40)),
                    asserta(currStamina(X,3)),
                    asserta(maxStamina(X,3)),
                    asserta(probabilityPotionState(X, notHave)),
                    asserta(staminaPotionState(X, notHave)),
                    displayFisherman,
                    create_fisherman_inventory.

createRancher(X) :-  asserta(job(X, rancher)),
                    asserta(gold(X,300)),
                    asserta(time(X,0)),
                    asserta(overallExp(X,0)),
                    asserta(targetExp(X,100)),
                    asserta(fishingExp(X,0)),
                    asserta(farmingExp(X,0)),
                    asserta(ranchingExp(X,0)),
                    asserta(overallLevel(X,1)),
                    asserta(fishingLevel(X,1)),
                    asserta(farmingLevel(X,1)),
                    asserta(ranchingLevel(X,1)),
                    asserta(targetFishingExp(X,40)),
                    asserta(targetRanchingExp(X,40)),
                    asserta(targetFarmingExp(X,40)),
                    asserta(currStamina(X,3)),
                    asserta(maxStamina(X,3)),
                    asserta(probabilityPotionState(X, notHave)),
                    asserta(staminaPotionState(X, notHave)),
                    displayRancher,
                    create_rancher_inventory.
                    
checkStatus(X) :-   displayChar, 
                    write('    Username         :')  , write(X), nl,
                    write('    Job              :')  , job(X,Job), write(Job), nl,
                    write('    Level            :')  , overallLevel(X, Level), write(Level), nl,
                    write('    Level farming    :')  , farmingLevel(X, FarmingLevel), write(FarmingLevel), nl,
                    write('    Level fishing    :')  , fishingLevel(X, FishingLevel), write(FishingLevel), nl,
                    write('    Level ranching   :')  , ranchingLevel(X, RanchingLevel), write(RanchingLevel), nl,
                    write('   ----------------------------------- '), nl,
                    write('    Exp              :')  , overallExp(X, Exp), write(Exp), targetExp(X, TargetExp), write('/'), write(TargetExp), nl,
                    write('    Exp farming      :')  , farmingExp(X, FarmingExp), write(FarmingExp), targetFarmingExp(X, TargetFarmingExp), write('/'), write(TargetFarmingExp), nl,
                    write('    Exp fishing      :')  , fishingExp(X, FishingExp), write(FishingExp), targetFishingExp(X, TargetFishingExp), write('/'), write(TargetFishingExp), nl,
                    write('    Exp ranching     :')  , ranchingExp(X, RanchingExp), write(RanchingExp), targetRanchingExp(X, TargetRanchingExp), write('/'), write(TargetRanchingExp), nl,
                    write('   ----------------------------------- '), nl,
                    write('    Gold             :')  , gold(X, Gold), write(Gold), nl,
                    write('    Stamina          :')  , currStamina(X, CurrStamina), write(CurrStamina), maxStamina(X, MaxStamina), write('/'), write(MaxStamina),nl,
                    write('    Day              :')  , time(X, Time), write(Time).


displayChar:-       nl,
                    write('               ,,,     ,,,                     '),nl,
                    write('             ,,,,,,,,,,,,,,,                   '),nl,
                    write('           ,,,,,,,,,,,,,,,,,,,                 '),nl,
                    write('          ,,,,*************,,,,                '),nl,
                    write('          *********************                '),nl,
                    write('      /////////////***/////////////            '),nl,
                    write('  ////////%%,,,,,,,,,,,,,,,,,%%////////        '),nl,
                    write('  ///////**%,,,##,,,,,,,##,,,%**///////        '),nl,
                    write('      ////*,,,,,,,,,,,,,,,,,,,*////            '),nl,
                    write('           ,,,,,,,,,,,,,,,,,,,                 '),nl,
                    write('             ,,,,,,,,,,,,,,,                   '),nl,
                    write('               ,,,,,,,,,,,                     '),nl,                    
                    write('               ***********                     '),nl,
                    write('           ///##*********##///                 '),nl,
                    write('       ###////####*****####////###             '),nl,
                    write('     #####////######*######////#####           '),nl,
                    write('    ######////#############////######          '),nl,
                    write('   #######/%%///////////////%%/#######         '),nl,
                    write('   #######/////////////////////#######         '),nl,
                    nl.

displayFisherman :-
    nl,
    nl,
    write('                                                           /----..  '), nl,
    write('                                                         .--...` .. '), nl,
    write('                                                       .-.--`    `- '), nl,
    write('                                                    `.---.`      :  '), nl,
    write('                                                 `.---.`        -`  '), nl,
    write('                                              `.----.          .-   '), nl,
    write('                                           ``..--.`            :    '), nl,
    write('                                        `....--.               :    '), nl,
    write('                                      `....--`                 :    '), nl,
    write('                                   ---.`.-.`                  `-    '), nl,
    write('                                  `:-.-:.                     :     '), nl,
    write('                                `-.-:-`                      ..     '), nl,
    write('                               .----`                       `:      '), nl,
    write('                             .--:-`                         :       '), nl,
    write('                           .-::-`                          `:       '), nl,
    write('                         .-::-`                            --       '), nl,
    write('                      `---::.                              :        '), nl,
    write('                    --..::.                                :        '), nl,
    write('                 `//`.::-`                                 :        '), nl,
    write('                -- -/o:.                                   :        '), nl,
    write('              `::-:yh/                                     -`       '), nl,
    write('            .ohhhhhh/                                      -/       '), nl,
    write('           `yhhhddhdh:                                      :`.     '), nl,
    write('           .hhhddhhhhs                                      -.      '), nl,
    write('            osshhhhhd+                                              '), nl,
    write('           -/::shhhy/                                               '), nl,
    write('          ::/.``...`                                                '), nl,
    write('         :::`                                                       '), nl,
    write('       `//:`                                                        '), nl,
    write('      `sh+`                                                         '), nl,
    write('     .yhs`                                                          '), nl,
    write('    .yhs`                                                           '), nl,
    write('   -hhs`                                                            '), nl,
    write('  :hhy`                                                             '), nl,
    write(' +hhh`                                                              '), nl,
    write('-syh-                                                               '), nl,
    write('  `.                                                                '), nl,
    nl.

displayFarmer :-
    nl,
    nl,
    write('                            ydddddhh-    '),nl,
    write('                            s++++++o:    '),nl,
    write('                            +      :.    '),nl,
    write('                            -+`   :+     '),nl,
    write('                             -h/:y/      '),nl,
    write('                              :mms       '),nl,
    write('                              -md+       '),nl,
    write('                              .oo:       '),nl,
    write('                               ..`       '),nl,
    write('                               ..`       '),nl,
    write('                               ..`       '),nl,
    write('                               .-.       '),nl,
    write('                               -/.       '),nl,
    write('                               -/.       '),nl,
    write('                               -/.       '),nl,
    write('                               -:.       '),nl,
    write('                               .-.       '),nl,
    write('                               .-.       '),nl,
    write('                               --.       '),nl,
    write('                               --.       '),nl,
    write('                              `so:       '),nl,
    write('                              `hs:       '),nl,
    write('                              `hs:       '),nl,
    write('                              `hy-       '),nl,
    write('                               hy.       '),nl,
    write('                               hy.       '),nl,
    write('                               yy`       '),nl,
    write('                               hh`       '),nl,
    write('                        `---..+dho.`---` '),nl,
    write('                        :soooymdddsosyy/ '),nl,
    write('                        /oo++shdhyosssy: '),nl,
    write('                        +soo++shso+sssy: '),nl,
    write('                        +soo+/+so/+sssy: '),nl,
    write('                        /soo+//o+/+ssss- '),nl,
    write('                        -oo+++:++:oooso` '),nl,
    write('                         /o+//:///++oo-  '),nl,
    write('                          :/::://:///.   '),nl,
    write('                           `.-///::-`    '),nl,
    write('                             `.:-`       '),nl,
    nl.
                               
displayRancher :-
    nl,
    nl,
    write('                              .:+syyyyhhhhyyyyo/-                               '), nl,
    write('                           :ss+:.`    -    `  --:oo-                            '), nl,
    write('        .:/ossss+:.     `+dy-:+ `+ .  o`   / `-o s/yh+.      .:+osoo+:-`        '), nl,
    write('   .:+ydddddddddddddyoosdmmsdmo.y++o :o+o /oo+:m/ydmmmmhsosyddddddddddddhs+:`   '), nl,
    write('.odmmmmmmmmmmmmmmmdhhhddmmmmh-yoohyy+yyhysdyhshy+s/:dmmmmddhhddmmmmmmmmmmmmmmdo.'), nl,
    write('hmmmmmmmmmmmmmmmmmmmmmmmmmmmms` `- `-``. ``.: .. `:smmmmmmmmmmmmmmmmmmmmmmmmmmmh'), nl,
    write('.+hmmmmmmmmmmmmmmmmmmmmmmmmmmm+                 +dmmmmmmmmmmmmmmmmmmmmmmmmmmmdo.'), nl,
    write('  `:sdmmmmmmmmmmmmmmmmmmmmmmmmd.               /mmmmmmmmmmmmmmmmmmmmmmmmmmmy/`  '), nl,
    write('     `/sdmmmmmmmmmmmdyoodmmmmmmh`              dmmmmmmmmoosdmmmmmmmmmmmmy+.     '), nl,
    write('        `:oydmmmdhs:.`  ommmmmmmh`            /mmmmmmmmh   `-oydmmmmhs/.`       '), nl,
    write('           ``...``      ymmmmmmmmy`          `dmmmmmmmmd      ``.-..`           '), nl,
    write('                       `mmmmmmmmmm+          /mmmmmmmmmm`                       '), nl,
    write('                       .dhmmmmmmmmy          ommmmmmmmmy.                       '), nl,
    write('                       `ydmhhmmmmmd          hmmmmmmymms.                       '), nl,
    write('                        -dmyhmmmmmm.        -mmmmmmmsmm:                        '), nl,
    write('                         ommmmmmmmmy        hmmmmmmmmmy                         '), nl,
    write('                         :mmmmmmmmmm-      :mmmmmmmmmm+                         '), nl,
    write('                         `dmmmmmmmmm/      ommmmmmmmmm.                         '), nl,
    write('                          /mmmmmmmmm:      ommmmmmmmmo                          '), nl,
    write('                           ymmmmmmmd`      -mmmmmmmmh`                          '), nl,
    write('                           .mmmmmmm:        odmmmmmm-                           '), nl,
    write('                            +mmmmms         `.smmmmo                            '), nl,
    write('                            `mmmmy`         - `mmmm.                            '), nl,
    write('                             mmd+`          /` smmm`                            '), nl,
    write('                            `ms`  `         -/ `/dm.                            '), nl,
    write('                            .m:   :         `h   /m-                            '), nl,
    write('                            -m:   y          d:  :m:                            '), nl,
    write('                            :m-`-om`         hd+./m/                            '), nl,
    write('                            -mshhyhh:``````.omhyhmm:                            '), nl,
    write('                             dmy-hh/shhhhddhs/hy-hm`                            '), nl,
    write('                             +mh:hmo:---:---:omy:ho                             '), nl,
    write('                              +mdoos+-------+soods                              '), nl,
    write('                               `:osyyhhhhhhyyys/.                               '), nl,
    nl.
