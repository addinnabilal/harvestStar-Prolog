/* Aktivitas pemain */

/* Farming */
:- dynamic(plant/2).
dig :-  diggingTile.

plant :- 
    player(SX,SY),
    (digged(SX, SY) -> 
        write('What do you want to plant?'),nl,
        write('1. Corn seeds'),nl,
        write('2. Wheat seeds'),nl,
        write('3. Rice'),nl,
        write('0 to cancel'), nl,
        write('Pick an option : '), read(option), nl,
        (option = 1 -> 
            asserta(plant(corn,2));
         option = 2 ->
            asserta(plant(wheat,4));
         option = 3 ->
            asserta(plant(rice,3));
         option = 0 ->
            write('You did\'nt plant anything, come back here again to plant'),nl
        )
    ;
    write('You are not in the right spot to plant')).


harvest :- 
    player(SX,SY),
    (digged(SX, SY) -> plant(_,Y),
    (Y =< 0 -> 
        write('Yeay you just harvest your plant'),nl
    
    ;
        write('Your planet are not ready to be harvested'))    

    ;
    write('You are not in the right spot to harvest')).


/* Fishing */

fish :- 
    player(SX,SY),
    (lakeSide(SX, SY) -> stored_item(fish_bait,Y), 
        (Y >= 0 -> write('You throw your rod into the lake...'),nl,
            delete_item(fish_bait,1),
            random(1,100,X),
            (X =< 1 -> 
                write('Congrats you got a jackpot fish \'Arwana\''),nl,
                asserta(stored_item(arwana,1));
            X =< 10 -> 
                write('Congrats you got an uniqe fish \'Koi\''),nl,
                asserta(stored_item(koi,1));
            X =< 30 -> 
                write('Congrats you got a rare fish \'Gurame\''),nl,
                asserta(stored_item(gurame,1));
            X =< 60 -> 
                write('Congrats you got a normal fish \'Bawal\''),nl,
                asserta(stored_item(bawal,1));
            X =< 90 -> 
                write('Congrats you got a normal fish \'Lele\''),nl,
                asserta(stored_item(lele,1));
            X =< 100 -> 
                write('You got a legendary item or is it.... \'Sendal\''),nl,
                asserta(stored_item(sendal,1)));
        write('You don\'t have bait anymore to fish'),nl
        );
    write('You are not in the right spot to fish')).


/* Ranching */
:- dynamic(animals/2).
ranch :- 
    player(SX,SY),
    (ranch(SX, SY) -> write('What animal do you want to take care of ?'),nl;
    write('You are not in the right spot to ranch')).
