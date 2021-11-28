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

/* Primitif */
useStamina:-   
            currStamina(X,Y), NewStamina is Y-1,
            retract(currStamina(X,Y)), asserta(currStamina(X,NewStamina)).

/* Farming */
:- dynamic(plant/4).
:- dynamic(isSoilTaken/2).

dig :-  player(X,Y), currStamina(Uname,St),
        (\+ isTaken(X,Y) -> 
            (St > 0 -> 
                diggingTile,useStamina;
                write('You don\'t have enough stamina'),nl
            )
            ;
            write('You can\'t dig here'),nl   
        ).
        

plant :- 
    player(SX,SY), currStamina(X,Y),
    (digged(SX, SY) -> 
        (\+ isSoilTaken(SX,SY) ->
            (Y > 0 -> 
            write('What seed do you want to plant?'),nl,
            write('1. Corn seeds'),nl,
            write('2. Wheat seeds'),nl,
            write('3. Rice seeds'),nl,
            write('0 to cancel'), nl,
            write('Pick an option : '), read_integer(Option), nl,
            (Option = 1 -> 
                stored_item(corn_seed,Qty), 
                    (Qty > 0 -> 
                        delete_item(corn_seed,1),useStamina,asserta(plant(SX,SY,corn,2)),asserta(isSoilTaken(SX,SY)),
                        write('You just plant the seed, wait for it to grow...'),nl
                        ;
                        write('You don\'t have enough seeds to plant'),nl
                    );
            Option = 2 -> 
                stored_item(wheat_seed,Qty),
                    (Qty > 0 -> 
                        delete_item(wheat_seed,1),useStamina,asserta(plant(SX,SY,wheat,4)),asserta(isSoilTaken(SX,SY)),
                        write('You just plant the seed, wait for it to grow...'),nl
                        ;
                        write('You don\'t have enough seeds to plant'),nl
                    );
            Option = 3 -> 
                stored_item(rice_seed,Qty),
                    (Qty > 0 -> 
                        delete_item(rice_seed,1),useStamina,asserta(plant(SX,SY,rice,3)),asserta(isSoilTaken(SX,SY)),
                        write('You just plant the seed, wait for it to grow...'),nl
                        ;
                        write('You don\'t have enough seeds to plant'),nl
                    );
            Option = 0 ->
                write('You did\'nt plant anything, come back here again to plant'),nl
            );
            write('You don\'t have enough stamina'),nl
            );
            write('You already planted here, plant somewhere else!'),nl
        );
    write('You are not in the right spot to plant')).


harvest :- 
    player(SX,SY), farmingLevel(Uname,Lv),
    (digged(SX, SY) -> plant(SX,SY,X,Y), objectExp(X,Exp),
    (Y =< 0 -> 
        write('Yeay you just harvest your plant'),nl,
        NewQty is 2 + (1 * Lv), NewExp is NewQty * Exp, 
        asserta(stored_item(X,NewQty)),addFarmingExp(Uname,NewExp),
        retract(isSoilTaken(SX,SY)),
        write('You got '), write(NewQty), write(X), write(' congrats'),nl,
        write('You gained '), write(NewExp), write(' Farming Exp'), nl,
        retract(plant(SX,SY,X,Y))

    ;
        write('Your plant are not ready to be harvested'))    

    ;
    write('You are not in the right spot to harvest')).

updatePlant:- 
    forall(plant(A,B,C,T),
        (T > 0 -> 
            newT is T - 1, retract(plant(A,B,C,T)),asserta(plant(A,B,C,newT))
            ;
            retract(plant(A,B,C,T)),asserta(plant(A,B,C,0))
        )
    ).


/* Fishing */

fish :- 
    player(SX,SY),
    (lakeSide(SX, SY) -> stored_item(fish_bait,Y), 
        (Y >= 0 -> write('You throw your rod into the lake...'),nl,
            delete_item(fish_bait,1),
            random(1,100,X),
            (X =< 1 -> 
                write('Congrats you got a jackpot fish \'Arowana\'!'),nl,
                store_item(arowana_fish), objectExp(arowana_fish, Exp),
                NewExp is Exp
                ;
            X =< 10 -> 
                write('Congrats you got an unique fish \'Koi\'!'),nl,
                store_item(koi_fish), objectExp(koi_fish, Exp),
                NewExp is Exp
                ;
            X =< 30 -> 
                write('Congrats you got a rare fish \'Carp\'!'),nl,
                store_item(carp_fish),objectExp(carp_fish, Exp),
                NewExp is Exp
                ;
            X =< 60 -> 
                write('Congrats you got a normal fish \'Pomfret\'!'),nl,
                store_item(pomfret_fish),objectExp(pomfret_fish, Exp),
                NewExp is Exp
                ;
            X =< 90 -> 
                write('Congrats you got a normal fish \'Catfish\'!'),nl,
                stored_item(catfish),objectExp(catfish, Exp),
                NewExp is Exp
                ;
            X =< 100 -> 
                write('You got a legendary item or is it.... \'Boots\'!'),nl,
                stored_item(boots), objectExp(catfish, Exp),
                NewExp is Exp
                ),
            addFishingExp(Uname,NewExp),write('You gained '), write(NewExp), write(' Exp'),nl 
        ;
        write('You don\'t have bait anymore to fish'),nl
        );
    write('You are not in the right spot to fish')).

/* Ranching */

/*  Primitif */
:- dynamic(stored_animal/2).

store_animal(Animal):- 
    (stored_animal(Animal,Qty) -> 
        NewQ is Qty + 1, retract(stored_animal(Animal,Qty)), asserta(stored_animal(Animal,NewQ))
        ;
        asserta(stored_animal(Animal,1))
    ).

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
    player(SX,SY),
    (ranch(SX, SY) -> write('What animal do you want to take care of, you have: '),nl,
        forall(stored_animal(Animal,Qty),
            (write(Qty), write(' '), write(Animal),nl)
        )
    ;
    write('You are not in the right spot to ranch')).


chicken:- 
    player(SX,SY), currStamina(Uname,Y), ranchingLevel(Uname,Lv),
    (ranch(SX, SY) -> 
        (Y > 0 ->
            animalTime(chicken, Time),
            (Time =< 0 ->
                write('Yeay your chicken produced something'),nl,
                objectProduced(chicken,Res),objectExp(chicken,Exp),
                NewQ is 2 + (1 * Lv), NewExp is Exp * NewQ, useStamina,
                store_many_item(Res,NewQ), addRanchingExp(Uname,NewExp),
                write('You got '), write(NewQ), write(' '), write(Res), nl,
                write('You gained '), write(NewExp), write(' Exp'),nl,
                retract(animalTime(chicken,_)),asserta(animalTime(chicken,2))

            )
            ;
            write('Your chicken did not produce anything, come back later'),nl
        )
        ;
        write('You don\'t have enough stamina'),nl
    ;
    write('You are not in the right spot to ranch')).

cow:- 
    player(SX,SY), currStamina(Uname,Y), ranchingLevel(Uname,Lv),
    (ranch(SX, SY) -> 
        (Y > 0 ->
            animalTime(cow, Time),
            (Time =< 0 ->
                write('Yeay your cow produced something'),nl,
                objectProduced(cow,Res),objectExp(cow,Exp),
                NewQ is 2 + (1 * Lv), NewExp is Exp * NewQ, useStamina,
                store_many_item(Res,NewQ), addRanchingExp(Uname,NewExp),
                write('You got '), write(NewQ), write(' '), write(Res), nl,
                write('You gained '), write(NewExp), write(' Exp'),nl,
                retract(animalTime(cow,_)), asserta(animalTime(cow,5))

            )
            ;
            write('Your cow did not produce anything, come back later'),nl
        )
        ;
        write('You don\'t have enough stamina'),nl
    ;
    write('You are not in the right spot to ranch')).

sheep:- 
    player(SX,SY), currStamina(Uname,Y), ranchingLevel(Uname,Lv),
    (ranch(SX, SY) -> 
        (Y > 0 ->
            animalTime(sheep, Time),
            (Time =< 0 ->
                write('Yeay your sheep produced something'),nl,
                objectProduced(sheep,Res),objectExp(sheep,Exp),
                NewQ is 2 + (1 * Lv), NewExp is Exp * NewQ, useStamina,
                store_many_item(Res,NewQ), addRanchingExp(Uname,NewExp),
                write('You got '), write(NewQ), write(' '), write(Res), nl,
                write('You gained '), write(NewExp), write(' Exp'),nl,
                retract(animalTime(sheep,_)), asserta(animalTime(sheep,3))
            )
            ;
            write('Your sheep did not produce anything, come back later'),nl
        )
        ;
        write('You don\'t have enough stamina'),nl
    ;
    write('You are not in the right spot to ranch')).

updateAnimalTime:- 
    forall(stored_animal(Type,Qty), 
        animalTime(Type,Time), NewT is Time-1,
        (NewT > 0 -> 
            retract(animalTime(Type,Time)), asserta(animalTime(Type,NewT))
            ;
            retract(animalTime(Type,Time)), asserta(animalTime(Type,0))
        )
        
    ).

