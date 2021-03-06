/* Aktivitas pemain */

/* Fakta */
isAnimal(chicken).
isAnimal(sheep).
isAnimal(cow).

isFish(arowana_fish).
isFish(koi_fish).
isFish(carp_fish).
isFish(pomfret_fish).
isFish(catfish).

isPlant(corn).
isPlant(wheat).
isPlant(rice).

/* Basic Exp facts */
objectExp(arowana_fish,X):- targetFishingExp(Uname,Target), fishingExp(Uname, Now), X is Target - Now.
objectExp(koi_fish,12).
objectExp(carp_fish,10).
objectExp(pomfret_fish,8).
objectExp(catfish,5).
objectExp(boots,3).

objectExp(cow,6).
objectExp(sheep,4).
objectExp(chicken,2).

objectExp(wheat,4).
objectExp(corn,3).
objectExp(rice,2).

/* Basic Harvest facts */
objectProduced(corn_seed,corn).
objectProduced(wheat_seed,wheat).
objectProduced(rice_seed,rice).

objectProduced(cow,milk).
objectProduced(sheep,wool).
objectProduced(chicken,egg).

/* Time Productivity */
:- dynamic(objectTimeP/2).
objectTimeP(corn,2).
objectTimeP(wheat,4).
objectTimeP(rice,3).

:- dynamic(objectTimeA/2).
objectTimeA(sheep,3).
objectTimeA(chicken,2).
objectTimeA(cow,5).


/* Advantage from Class speciality and Speciality Level */
getRare(Ctr):- 
            probabilityPotionState(_,PBState),
            (PBState = used -> 
                random(1, 100, X), Ctr is mod(X,50),
                retract(probabilityPotionState(X,PBState)), asserta(probabilityPotionState(X,notHave))
            ).

reducePlantTime:- 
                farmingLevel(_,Lv),
                forall(objectTimeP(A,B),    
                    (NewX is round(Lv/3), NewX2 is B - NewX,
                    (NewX2 < 2 ->
                        retract(objectTimeP(A,B)), asserta(objectTimeP(A,2))
                    ;
                        retract(objectTimeP(A,B)), asserta(objectTimeP(A,NewX2))
                    ))
                    ).


reduceAnimalTime:- 
                ranchingLevel(_,Lv),
                forall(objectTimeA(A,B),    
                    (NewX is round(Lv/3), NewX2 is B - NewX,
                    (NewX2 < 2 ->
                        retract(objectTimeA(A,B)), asserta(objectTimeA(A,2))
                    ;
                        retract(objectTimeA(A,B)), asserta(objectTimeA(A,NewX2))
                    ))
                ).

getShovelAdv(X):- tool_level(shovel,TLv2), job(_,Class),
                    (Class = farmer ->
                        TLv is TLv2
                    ;
                        TLv is TLv2-1
                    ),
                    Qty1 is round(TLv/3), X is Qty1.



/* Primitif */
useStamina:-   
            currStamina(X,Y), NewStamina is Y-1,
            retract(currStamina(X,Y)), asserta(currStamina(X,NewStamina)).

isFullinv(Qty):- 
                space(X), X2 is X + Qty,
                (X2 > 100 -> 
                    write('Your inventory is full, go sell something first'), nl
                ).

/* Farming */
:- dynamic(plant/4).
:- dynamic(isSoilTaken/2).

dig :-  position(X,Y), currStamina(_,St),
        (\+ isPlaced(X,Y) -> 
            (St > 0 -> 
                diggingTile,useStamina;
                write('You don\'t have enough stamina'),nl
            )
            ;
            write('You can\'t dig here'),nl   
        ).
        

plant :- 
    position(SX,SY), currStamina(_,Y),
    (digged(SX, SY) -> 
        (\+ isSoilTaken(SX,SY) ->
            (Y > 0 -> 
            displayFarm,
            write('What seed do you want to plant?'),nl,
            write('[1] Corn seeds'),nl,
            write('[2] Wheat seeds'),nl,
            write('[3] Rice seeds'),nl,
            write('[0] to cancel'), nl,
            write('Pick an option : '), read(Option), nl,
            (Option = 1 -> 
                (stored_item(corn_seed,Qty) -> 
                    (Qty > 0 -> 
                        objectTimeP(corn,Tm),
                        delete_item(corn_seed,1),useStamina,asserta(plant(SX,SY,corn,Tm)),asserta(isSoilTaken(SX,SY)),
                        write('You just plant the seed, wait for it to grow...'),nl
                        ;
                        write('You don\'t have enough seeds to plant'),nl
                    );
                        write('You don\'t have enough seeds to plant'),nl
                    );
            Option = 2 -> 
                (stored_item(wheat_seed,Qty) ->
                    (Qty > 0 -> 
                        objectTimeP(wheat,Tm),
                        delete_item(wheat_seed,1),useStamina,asserta(plant(SX,SY,wheat,Tm)),asserta(isSoilTaken(SX,SY)),
                        write('You just plant the seed, wait for it to grow...'),nl
                        ;
                        write('You don\'t have enough seeds to plant'),nl
                    );
                        write('You don\'t have enough seeds to plant'),nl
                    );
            Option = 3 -> 
                (stored_item(rice_seed,Qty) ->
                    (Qty > 0 -> 
                        objectTimeP(rice,Tm),
                        delete_item(rice_seed,1),useStamina,asserta(plant(SX,SY,rice,Tm)),asserta(isSoilTaken(SX,SY)),
                        write('You just plant the seed, wait for it to grow...'),nl
                        ;
                        write('You don\'t have enough seeds to plant'),nl
                    );
                    write('You don\'t have enough seeds to plant'),nl
                    );
            Option = 0 ->
                write('You did\'nt plant anything, come back here again to plant'),nl
                ;
                !
            );
            write('You don\'t have enough stamina'),nl
        );
        write('You already planted here, plant somewhere else!'),nl
    );
    write('You are not in the right spot to plant')).


harvest :- 
    position(SX,SY), farmingLevel(Uname,Lv), job(_,Class),
    (digged(SX, SY) -> 
        (plant(SX,SY,_,_) -> 
            plant(SX,SY,X,Y), objectExp(X,Exp2),
            (Class = farmer ->
                Exp is (Exp2 + round(Exp2/2))
            ;
                Exp is Exp2
            ),
            (Y =< 0 -> 
                getShovelAdv(QAdd), 
                NewQty is (2 + (1 * Lv)) + QAdd, NewExp is NewQty * Exp,
                write('Yeay you just harvest your plant'),nl,
                write('......'), nl,
                (isFullinv(NewQty) -> 
                    write('Come back here later after you have some spaced'),nl
                ;
                    asserta(stored_item(X,NewQty)),addFarmingExp(Uname,NewExp), addOverallExp(Uname,NewExp),
                    retract(isSoilTaken(SX,SY)),
                    displayPlant,nl,
                    write('You got '), write(NewQty), write(' '),write(X), write(' congrats'),nl,
                    write('You gained '), write(NewExp), write(' Exp'), nl,
                    retract(plant(SX,SY,X,Y)),
                    (crop_to_harvest(Qst) -> 
                        NewQst is Qst - 1, retract(crop_to_harvest(Qst)),
                        asserta(crop_to_harvest(NewQst))
                    ),is_quest_finished
                )
            ;
            write('Your plant are not ready to be harvested'), nl
            )
        ;
        write('You did not plant anything here, the soil is empty'), nl
        )
    ;
    write('You are not in the right spot to harvest'), nl).

updatePlant:- 
    forall(plant(A,B,C,T),
        (T > 0 -> 
            NewT is T - 1, retract(plant(A,B,C,T)),asserta(plant(A,B,C,NewT))
            ;
            retract(plant(A,B,C,T)),asserta(plant(A,B,C,0))
        )
    ).


/* Fishing */

fish :- 
    position(SX,SY), currStamina(_,St), fishingLevel(_,Lv), job(_,Class),
    (lakeSide(SX, SY) -> 
        (St > 0 ->
            (isFullinv(1) -> 
                write('Come back here later after you have some spaced'),nl
            ;
                (stored_item(fish_bait,Y) -> 
                    (Y >= 0 -> write('You throw your rod into the lake...'),nl,displayFishing,nl,
                    delete_item(fish_bait,1),
                    (getRare(A) -> 
                        NewX is A
                    ;
                        random(1,101,NewX)
                    ),
                    tool_level(fishing_rod,TLv),
                    (
                        Class = fisherman -> TLv2 is TLv
                    ;
                         TLv2 is TLv-1
                    ),
                    New2X is mod(Lv,20), X2 is NewX - New2X, X is X2 - TLv2,
                    (X =< 1 -> 
                        write('Congrats you got a jackpot fish \'Arowana\'!'),nl,displayFish,nl,
                        store_item(arowana_fish), useStamina,objectExp(arowana_fish, Exp),
                        NewExp is Exp
                        ;
                    X =< 10 -> 
                        write('Congrats you got an unique fish \'Koi\'!'),nl,displayFish,nl,
                        store_item(koi_fish), useStamina,objectExp(koi_fish, Exp),
                        NewExp is Exp
                        ;
                    X =< 25 -> 
                        write('Congrats you got a rare fish \'Carp\'!'),nl,displayFish2,nl,
                        store_item(carp_fish), useStamina,objectExp(carp_fish, Exp),
                        NewExp is Exp
                        ;
                    X =< 50 -> 
                        write('Congrats you got a normal fish \'Pomfret\'!'),nl,displayFish1,nl,
                        store_item(pomfret_fish),useStamina,objectExp(pomfret_fish, Exp),
                        NewExp is Exp
                        ;
                    X < 80 -> 
                        write('Congrats you got a normal fish \'Catfish\'!'),nl,displayFish1,nl,
                        store_item(catfish),useStamina,objectExp(catfish, Exp),
                        NewExp is Exp
                        ;
                    X =< 90 -> 
                        write('You got a legendary item or is it.... \'Boots\'!'),nl,
                        store_item(boots), useStamina,objectExp(catfish, Exp),
                        NewExp is Exp
                        ;
                    X =< 100 -> 
                        write('You did not get anything... :('),nl,displayZonk,nl,
                        useStamina, NewExp is 5
                    ),
                    (Class = fisherman -> 
                        NewExp2 is (NewExp + round(NewExp/3))
                    ;
                        NewExp2 is NewExp
                    ),
                    (fish_to_catch(Qst) -> 
                        NewQst is Qst - 1, retract(fish_to_catch(Qst)),
                        asserta(fish_to_catch(NewQst))
                    ),
                    addFishingExp(Uname,NewExp2), addOverallExp(Uname,NewExp2),
                    write('You gained '), write(NewExp2), write(' Exp'),nl,
                    is_quest_finished
                    ;
                    write('You don\'t have bait anymore to fish'),nl
                    )
                ;
                write('You don\'t have bait anymore to fish')
                )
            )
        ;
        write('You don\'t have enough stamina'),nl
        )
        ;
    write('You are not in the right spot to fish')).

/* Ranching */

/*  Primitif */
:- dynamic(stored_animal/2).

store_animal(Animal):- 
    (stored_animal(Animal,Qty) -> 
        NewQ is Qty + 1, retract(stored_animal(Animal,Qty)), asserta(stored_animal(Animal,NewQ))
        ;
        asserta(stored_animal(Animal,1))
    ),
    write('1 '), write(Animal),write(' stored to ranch'),nl.

store_many_animal(Animal,Amnt):- 
    (stored_animal(Animal,Qty) -> 
        NewQ is Qty + Amnt, retract(stored_animal(Animal,Qty)), asserta(stored_animal(Animal,NewQ))
        ;
        asserta(stored_animal(Animal,Amnt))
    ),
    write(Amnt),write(' '), write(Animal),write(' stored to inventory'), nl.

delete_animal(Animal,Qty):- 
    (stored_animal(Animal,PrevQ) -> 
        NewQ is PrevQ - Qty, 
        (NewQ > 0 -> 
            retract(stored_animal(Animal,PrevQ)), asserta(stored_animal(Animal,NewQ))
            ;
            retract(stored_animal(Animal,PrevQ))
        ) 
    ).

:- dynamic(animalTime/2).
animalTime(cow,5).
animalTime(sheep,3).
animalTime(chicken,2).

/* Ranchin Activity */
ranch :- 
    position(SX,SY),
    (ranch(SX, SY) -> 
        displayRanch,
        (stored_animal(_,_) -> 
            write('What animal do you want to harvest, you have: '),nl,
            forall(stored_animal(Animal,Qty),
            (write(Qty), write(' '), write(Animal),nl)
            );
            write('You don\'t have any animal'),nl
        )
    ;
    write('You are not in the right spot to ranch')).


chicken:- 
    position(SX,SY), currStamina(Uname,Y), ranchingLevel(Uname,Lv), job(_,Class),
    (ranch(SX, SY) -> 
        (Y > 0 ->
            (stored_animal(chicken,_) -> 
                animalTime(chicken, Time),
                (Time =< 0 ->
                write('Yeay your chicken produced something'),nl,
                stored_animal(chicken,AnQty),
                objectProduced(chicken,Res),objectExp(chicken,Exp2),
                (Class = rancher ->
                    Exp is (Exp2 + round(Exp2/2))
                ;
                    Exp is Exp2
                ),
                NewQ is (2 + (1 * Lv)) * AnQty, NewExp is Exp * NewQ, useStamina,
                (isFullinv(NewQ) ->
                    write('Come back here later after you have some spaced'),nl
                ;
                    (product_to_produce(Qst) -> 
                        NewQst is Qst - NewQ, retract(product_to_produce(Qst)),
                        asserta(product_to_produce(NewQst))
                    ),
                    store_many_item(Res,NewQ), addRanchingExp(Uname,NewExp), addOverallExp(Uname,NewExp),
                    write('You got '), write(NewQ), write(' '), write(Res), nl,nl,
                    displayEgg,nl,nl,
                    write('You gained '), write(NewExp), write(' Exp'),nl,
                    objectTimeA(chicken,Tm),
                    retract(animalTime(chicken,_)),asserta(animalTime(chicken,Tm)),is_quest_finished
                )
                ;
                write('Your chicken did not produce anything, come back later'),nl
                )
            ;
            write('You don\'t have any chicken')
            )
            ;
            write('You don\'t have enough stamina'),nl
        )
    ;
    write('You are not in the right spot to ranch')).

cow:- 
    position(SX,SY), currStamina(Uname,Y), ranchingLevel(Uname,Lv),job(_,Class),
    (ranch(SX, SY) -> 
        (Y > 0 -> 
            (stored_animal(cow,_) ->
                animalTime(cow, Time),
                (Time =< 0 ->
                write('Yeay your cow produced something'),nl,
                stored_animal(cow,AnQty),
                objectProduced(cow,Res),objectExp(cow,Exp2),
                (Class = rancher ->
                    Exp is (Exp2 + round(Exp2/2))
                ;
                    Exp is Exp2
                ),
                NewQ is (1 + (1 * Lv)) * AnQty, NewExp is Exp * NewQ, useStamina,
                (isFullinv(NewQ)->
                    write('Come back here later after you have some spaced'),nl
                ;
                    (product_to_produce(Qst) -> 
                        NewQst is Qst - NewQ, retract(product_to_produce(Qst)),
                        asserta(product_to_produce(NewQst))
                    ),
                    store_many_item(Res,NewQ), addRanchingExp(Uname,NewExp),
                    write('You got '), write(NewQ), write(' '), write(Res), nl,nl,
                    displayMilk,nl,nl,
                    write('You gained '), write(NewExp), write(' Exp'),nl,
                    objectTimeA(cow,Tm),
                    retract(animalTime(cow,_)), asserta(animalTime(cow,Tm)),is_quest_finished
                )
                ;
                write('Your cow did not produce anything, come back later'),nl
                )
            ;
            write('You don\'t have any cow')
            )
        )
        ;
        write('You don\'t have enough stamina'),nl
    ;
    write('You are not in the right spot to ranch')).

sheep:- 
    position(SX,SY), currStamina(Uname,Y), ranchingLevel(Uname,Lv),job(_,Class),
    (ranch(SX, SY) -> 
        (Y > 0 ->
            (stored_animal(sheep,_) ->
                animalTime(sheep, Time),
                (Time =< 0 ->
                    write('Yeay your sheep produced something'),nl,
                    stored_animal(sheep,AnQty),
                    objectProduced(sheep,Res),objectExp(sheep,Exp2),
                    (Class = rancher ->
                        Exp is (Exp2 + round(Exp2/2))
                    ;
                        Exp is Exp2
                    ),
                    NewQ is (2 + (1 * Lv)) * AnQty, NewExp is Exp * NewQ, useStamina,
                    (isFullinv(NewQ) ->
                        write('Come back here later after you have some spaced'),nl
                    ;
                        (product_to_produce(Qst) -> 
                            NewQst is Qst - NewQ, retract(product_to_produce(Qst)),
                            asserta(product_to_produce(NewQst))
                        ),
                        store_many_item(Res,NewQ), addRanchingExp(Uname,NewExp),
                        write('You got '), write(NewQ), write(' '), write(Res), nl,nl,
                        displayWool,nl,nl,
                        write('You gained '), write(NewExp), write(' Exp'),nl,
                        objectTimeA(sheep,Tm),
                        retract(animalTime(sheep,_)), asserta(animalTime(sheep,Tm)),is_quest_finished
                    )
                ;
                write('Your sheep did not produce anything, come back later'),nl
                )
            ;
            write('You don\'t have any sheep'),nl
            )   
        ;
        write('You don\'t have enough stamina'),nl
        )
    ;
    write('You are not in the right spot to ranch')).

updateAnimalTime:- 
    forall(stored_animal(Type,_), 
        (animalTime(Type,Time), NewT is Time-1,
            (NewT > 0 -> 
                retract(animalTime(Type,Time)), asserta(animalTime(Type,NewT))
                ;
                retract(animalTime(Type,Time)), asserta(animalTime(Type,0))
            )
        )  
    ).
