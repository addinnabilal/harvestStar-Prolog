/* house.pl */

:- dynamic (time/2).
addTime(X, Add) :-  time(X, PrevTime), retract(time(X, PrevTime)),
                    NewTime is PrevTime + Add, asserta(time(X, NewTime)),
                    write('changing day'), nl.
:- dynamic (stamina/2).
updateStamina(X) :- maxStamina(X, PrevMax), retract(stamina(X, PrevStamina)),
                    NewStamina is PrevMax, asserta(stamina(X, NewStamina)),
                    write('charging my energy'), nl.


visitHouse :-   write('what do you want to do?'), nl,
                write('- 1. Sleep'), nl, 
                write('- 2. writeDiary'), nl,
                write('- 3. readDiary'), nl,
                write('- 4. exit'), nl.
                write('Pick an option: '), read_integer(HouseChoice), nl,

                (HouseChoice = 1 -> 
                    write('Good Night'), nl,
                    addTime(Username, 1),
                    updateStamina(Username), nl
                    ,visitHouse;
                HouseChoice = 2 ->
                    write('writing diary'), nl;
                HouseChoice = 3 ->
                    write('reading diary'), nl;
                HouseChoice = 4 ->
                    write(' exit game'), nl).

                    
                

