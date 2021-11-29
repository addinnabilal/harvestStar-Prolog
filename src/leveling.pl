addOverallExp(X, Value) :-  overallExp(X,Prev), retract(overallExp(X,Prev)),
                            New is Prev+Value, asserta(overallExp(X,New)),
                            levelUp(X).

levelUp(X) :-   overallLevel(X, CurrLevel),
                overallExp(X, CurrExp),
                targetExp(X, CurrTargetExp),

                (CurrExp>=CurrTargetExp -> 
                retract(overallLevel(X,CurrLevel)),
                NewLevel is CurrLevel+1,
                asserta(overallLevel(X,NewLevel)),

                retract(overallExp(X,CurrExp)),
                NewExp is CurrExp-(CurrTargetExp),
                asserta(overallExp(X,NewExp)),

                retract(targetExp(X, CurrTargetExp)),
                NewTargetExp is CurrTargetExp+100,
                asserta(targetExp(X, NewTargetExp)),

                maxStamina(X, MaxStamina), retract(maxStamina(X, MaxStamina)),
                NewMaxStamina is MaxStamina + 3,
                asserta(maxStamina(X, NewMaxStamina)),

                update_item_price_per_char_level(arowana_fish, NewLevel),
                update_item_price_per_char_level(koi_fish, NewLevel),
                update_item_price_per_char_level(carp_fish, NewLevel),
                update_item_price_per_char_level(pomfret_fish, NewLevel),
                update_item_price_per_char_level(catfish, NewLevel),
                update_item_price_per_char_level(boots, NewLevel),
                update_item_price_per_char_level(milk, NewLevel),
                update_item_price_per_char_level(wool, NewLevel),
                update_item_price_per_char_level(egg, NewLevel),
                update_item_price_per_char_level(wheat, NewLevel),
                update_item_price_per_char_level(rice, NewLevel),
                update_item_price_per_char_level(corn, NewLevel);
                !
                ).


addRanchingExp(X, Value):-  ranchingExp(X,Prev), retract(ranchingExp(X,Prev)),
                            New is Prev+Value, asserta(ranchingExp(X,New)),
                            ranchingLevelUp(X).

ranchingLevelUp(X) :-   ranchingLevel(X, CurrLevel),
                        ranchingExp(X, CurrExp),
                        targetRanchingExp(X, CurrTargetExp),
                        (CurrExp>=CurrTargetExp -> 
                        retract(ranchingLevel(X,CurrLevel)),
                        NewLevel is CurrLevel+1,
                        asserta(ranchingLevel(X,NewLevel)),
                        reduceAnimalTime,

                        retract(ranchingExp(X,CurrExp)),
                        NewExp is CurrExp-(CurrTargetExp),
                        asserta(ranchingExp(X,NewExp)),

                        retract(targetRanchingExp(X, CurrTargetExp)),
                        NewTargetExp is CurrTargetExp+20,
                        asserta(targetRanchingExp(X, NewTargetExp));
                        !
                    ).

addFarmingExp(X, Value):-   farmingExp(X,Prev), retract(farmingExp(X,Prev)),
                            New is Prev+Value, asserta(farmingExp(X,New)),
                            farmingLevelUp(X).


farmingLevelUp(X) :-    farmingLevel(X, CurrLevel),
                        farmingExp(X, CurrExp),
                        targetFarmingExp(X, CurrTargetExp),
                        (CurrExp>=CurrTargetExp -> 
                        retract(farmingLevel(X,CurrLevel)),
                        NewLevel is CurrLevel+1,
                        asserta(farmingLevel(X,NewLevel)),
                        reducePlantTime,

                        retract(farmingExp(X,CurrExp)),
                        NewExp is CurrExp-(CurrTargetExp),
                        asserta(farmingExp(X,NewExp)),

                        retract(targetFarmingExp(X, CurrTargetExp)),
                        NewTargetExp is CurrTargetExp+20,
                        asserta(targetFarmingExp(X, NewTargetExp));
                        !
                    ).

addFishingExp(X, Value):-   fishingExp(X,Prev), retract(fishingExp(X,Prev)),
                            New is Prev+Value, asserta(fishingExp(X,New)),
                            fishingLevelUp(X).


fishingLevelUp(X) :-    fishingLevel(X, CurrLevel),
                        fishingExp(X, CurrExp),
                        targetFishingExp(X, CurrTargetExp),
                        (CurrExp>=CurrTargetExp -> 
                        retract(fishingLevel(X,CurrLevel)),
                        NewLevel is CurrLevel+1,
                        asserta(fishingLevel(X,NewLevel)),

                        retract(fishingExp(X,CurrExp)),
                        NewExp is CurrExp-(CurrTargetExp),
                        asserta(fishingExp(X,NewExp)),

                        retract(targetFishingExp(X, CurrTargetExp)),
                        NewTargetExp is CurrTargetExp+20,
                        asserta(targetFishingExp(X, NewTargetExp));
                        !
                        ).
