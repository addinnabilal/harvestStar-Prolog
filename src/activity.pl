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


/* Primitif */
useStamina:-   
            currStamina(X,Y), NewStamina is Y-1,
            retract(currStamina(X,Y)), asserta(currStamina(X,NewStamina)).

/* Farming */
:- dynamic(plant/4).
:- dynamic(isSoilTaken/2).

dig :-  player(X,Y),isTaken(X,Y), currStamina(Uname,St),
        (\+ isTaken(X,Y) -> 
            (St > 0 -> 
                diggingTile,useStamina;
                write('You don\'t have enough stamina'),nl
            )
            ;
            write("You can\t dig here"),nl   
        ).
        

plant :- 
    player(SX,SY), currStamina(X,Y),
    (digged(SX, SY) -> 
        (Y > 0 -> 
        write('What seed do you want to plant?'),nl,
        write('1. Corn seeds'),nl,
        write('2. Wheat seeds'),nl,
        write('3. Rice seeds'),nl,
        write('0 to cancel'), nl,
        write('Pick an option : '), read(option), nl,
        (option = 1 ->
            stored_item(corn_seed,Qty),
                (Qty > 0 -> 
                    delete_item(corn_seed,1),useStamina,asserta(plant(SX,SY,corn,2));
                    write('You don\'t have enough seeds to plant'),nl
                );
         option = 2 ->
            stored_item(wheat_seed,Qty),
                (Qty > 0 -> 
                    delete_item(wheat_seed,1),useStamina,asserta(plant(SX,SY,wheat,4));
                    write('You don\'t have enough seeds to plant'),nl
                );
         option = 3 ->
            stored_item(rice_seed,Qty),
                (Qty > 0 -> 
                    delete_item(rice_seed,1),useStamina,asserta(plant(SX,SY,rice,3));
                    write('You don\'t have enough seeds to plant'),nl
                );
         option = 0 ->
            write('You did\'nt plant anything, come back here again to plant'),nl
        );
        write('You don\'t have enough stamina'),nl
        );
    write('You are not in the right spot to plant')).


harvest :- 
    player(SX,SY),
    (digged(SX, SY) -> plant(SX,SY,X,Y),
    (Y =< 0 -> 
        write('Yeay you just harvest your plant'),nl
    
    ;
        write('Your planet are not ready to be harvested'))    

    ;
    write('You are not in the right spot to harvest')).

/* updatePlant:- */


/* Fishing */

fish :- 
    player(SX,SY),
    (lakeSide(SX, SY) -> stored_item(fish_bait,Y), 
        (Y >= 0 -> write('You throw your rod into the lake...'),nl,
            delete_item(fish_bait,1),
            random(1,100,X),
            (X =< 1 -> 
                write('Congrats you got a jackpot fish \'Arowana\'!'),nl,
                store_item(arowana_fish);
            X =< 10 -> 
                write('Congrats you got an unique fish \'Koi\'!'),nl,
                store_item(koi_fish);
            X =< 30 -> 
                write('Congrats you got a rare fish \'Carp\'!'),nl,
                store_item(carp_fish);
            X =< 60 -> 
                write('Congrats you got a normal fish \'Pomfret\'!'),nl,
                store_item(pomfret_fish);
            X =< 90 -> 
                write('Congrats you got a normal fish \'Catfish\'!'),nl,
                stored_item(catfish);
            X =< 100 -> 
                write('You got a legendary item or is it.... \'Boots\'!'),nl,
                stored_item(boots));
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
    ), write('Animal stored to ranch.'), nl.

delete_animal(Animal,Qty):- 
    (stored_animal(Animal,PrevQ) -> 
        NewQ is PrevQ - Qty, 
        (NewQ > 0 -> 
            retract(stored_animal(Animal,PrevQ)), asserta(stored_animal(Animal,NewQ))
            ;
            retract(stored_animal(Animal,PrevQ))
        ) 
    ).



/* Ranchin Activity */
ranch :- 
    player(SX,SY),
    (ranch(SX, SY) -> write('What animal do you want to take care of ?'),nl
        /*stored_animal()*/    
    ;
    write('You are not in the right spot to ranch')).

/*
chicken :- 

sheep :- 

cow :- 
*/

